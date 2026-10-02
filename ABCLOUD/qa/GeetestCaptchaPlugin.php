<?php

namespace addons\geetest_captcha;

use app\admin\lib\Plugin;
use GuzzleHttp\Client;
use think\Db;
use think\exception\HttpResponseException;
use think\Response;

class GeetestCaptchaPlugin extends Plugin
{
    const VALIDATE_URL = 'https://gcaptcha4.geetest.com/validate';

    const CAPTCHA_FIELDS = [
        'lot_number',
        'captcha_output',
        'pass_token',
        'gen_time',
    ];

    private static $requestValidated = false;

    public $info = [
        'name'        => 'GeetestCaptcha',
        'title'       => '极验验证码',
        'description' => '为前台客户中心登录、注册和密码操作提供极验行为验证第四代及服务端二次校验',
        'status'      => 1,
        'author'      => 'IDCsmart',
        'version'     => '1.0.6',
        'module'      => 'addons',
        'lang'        => [
            'chinese'    => '极验验证码',
            'chinese_tw' => '極驗驗證碼',
            'english'    => 'GeeTest CAPTCHA',
        ],
    ];

    public function install()
    {
        $hooks = [
            [
                'type'        => 3,
                'name'        => '前台页脚输出',
                'hook'        => 'client_area_footer_output',
                'description' => '在客户中心页面底部输出插件内容',
            ],
            [
                'type'        => 3,
                'name'        => '客户中心验证码模板',
                'hook'        => 'template_custom_clientarea_captcha_html',
                'description' => '替换客户中心默认验证码组件',
            ],
            [
                'type'        => 1,
                'name'        => '自定义验证码校验',
                'hook'        => 'custom_captcha_check',
                'description' => '为系统验证码检查提供自定义校验结果',
            ],
        ];

        foreach ($hooks as $hook) {
            if (!Db::name('hook')->where('hook', $hook['hook'])->find()) {
                Db::name('hook')->insert($hook);
            }
        }

        return true;
    }

    public function uninstall()
    {
        return true;
    }

    /**
     * 判断是否属于后台管理系统请求（后台登录及管理接口绝不拦截）
     */
    private function isAdminRequest()
    {
        $request = request();
        if ($request->module() === 'admin') {
            return true;
        }
        $adminDir = function_exists('adminAddress') ? adminAddress() : 'admin';
        $uri = isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : '';
        if (stripos($uri, '/' . $adminDir) !== false) {
            return true;
        }
        return false;
    }

    /**
     * Validate protected POST requests before encrypted application controllers run.
     */
    public function appBegin()
    {
        if ($this->isAdminRequest()) {
            return null;
        }

        $request = request();
        if (!$request->isPost()) {
            return null;
        }

        $post = $request->post();
        if (empty($post['lot_number']) && !empty($request->param('lot_number'))) {
            $post = array_merge($post, (array) $request->param());
        }

        $page = $this->resolveBackendPage($request->path());
        if ($page === null) {
            return null;
        }

        $settings = $this->getSettings();
        if (!$this->isPageEnabled($page, $settings)) {
            return null;
        }

        if (!empty($post['lot_number']) && !empty($post['pass_token'])) {
            $result = $this->validateCaptcha($post, $settings);
            if (!$result['success']) {
                $this->rejectRequest($result['message'] ?: '人机安全验证未通过，请重新验证');
            }
            self::$requestValidated = true;
        }

        return null;
    }

    /**
     * Replace IDCsmart's image captcha when its page-level captcha switch is on.
     * The actual GeeTest component is injected once from the footer hook.
     */
    public function templateCustomClientareaCaptchaHtml($params)
    {
        $id = isset($params['id']) ? (string) $params['id'] : '';
        if (strpos($id, 'admin') !== false || $this->isAdminRequest()) {
            return null;
        }

        $page = $this->resolveFrontendPage(request()->path());
        if ($page === null) {
            return null;
        }

        $settings = $this->getSettings();
        if (!$this->isPageEnabled($page, $settings)) {
            return null;
        }

        return '<!-- GeeTest CAPTCHA is rendered by client_area_footer_output -->';
    }

    /**
     * Handle captcha check during native captcha_check() calls.
     * Validates Geetest tokens directly when submitted, or allows native graphic captcha fallback.
     */
    public function customCaptchaCheck($params)
    {
        $id = isset($params['id']) ? (string) $params['id'] : '';
        // 绝不拦截后台管理系统的验证码校验
        if (strpos($id, 'admin') !== false || $this->isAdminRequest()) {
            return null;
        }

        if (self::$requestValidated) {
            return true;
        }

        $request = request();
        if (!$request->isPost()) {
            return null;
        }

        $post = $request->post();
        if (empty($post['lot_number']) && !empty($request->param('lot_number'))) {
            $post = array_merge($post, (array) $request->param());
        }

        $settings = $this->getSettings();

        // 1. 如果提交了极验凭据，直接执行极验服务端二次验证
        if (!empty($post['lot_number']) && !empty($post['pass_token'])) {
            $result = $this->validateCaptcha($post, $settings);
            if (!empty($result['success'])) {
                self::$requestValidated = true;
                return true;
            }
            // 极验校验失败，返回明确的人机安全验证报错
            $this->rejectRequest($result['message'] ?: '人机安全验证未通过，请重新验证');
            return false;
        }

        // 2. 如果提交了原生图形验证码（如短信登录获取验证码时），放行给系统原生 captcha_check
        if (!empty($post['captcha'])) {
            return null;
        }

        // 3. 确定当前页面是否启用了极验（前台客户中心）
        $page = $this->resolveBackendPage($request->path());
        if ($page === null && !empty($id)) {
            if (strpos($id, 'login') !== false) {
                $page = 'login';
            } elseif (strpos($id, 'register') !== false) {
                $page = 'register';
            } elseif (strpos($id, 'forget') !== false || strpos($id, 'pwd') !== false) {
                $page = 'password';
            }
        }

        if ($page !== null && $this->isPageEnabled($page, $settings)) {
            $this->rejectRequest('请先完成人机安全验证');
            return false;
        }

        return null;
    }

    /**
     * Inject the client integration after the page forms have been rendered.
     */
    public function clientAreaFooterOutput()
    {
        if ($this->isAdminRequest()) {
            return '';
        }

        $request = request();
        if ($request->isAjax()) {
            return '';
        }

        $page = $this->resolveFrontendPage($request->path());
        if ($page === null) {
            return '';
        }

        $settings = $this->getSettings();
        if (!$this->isPageEnabled($page, $settings)) {
            return '';
        }

        $riskType = $this->normalizeRiskType($settings['risk_type']);
        $product = $this->normalizeProduct($settings['product']);
        $configured = trim((string) $settings['captcha_id']) !== ''
            && trim((string) $settings['captcha_key']) !== '';

        $clientConfig = [
            'page'        => $page,
            'captchaId'   => trim((string) $settings['captcha_id']),
            'configured'  => true,
            'product'     => $product,
            'riskType'    => $riskType === 'auto' ? '' : $riskType,
            'language'    => 'zho',
            'timeout'     => 10000,
        ];

        $json = json_encode(
            $clientConfig,
            JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT
        );

        $scripts = '';
        if ($configured) {
            $scripts .= '<script src="https://static.geetest.com/v4/gt4.js"></script>';
        }
        $scripts .= '<script src="/plugins/addons/geetest_captcha/assets/geetest-captcha.js?v=1.0.6"></script>';
        $scripts .= '<script>window.GeetestCaptchaPlugin.boot(' . $json . ');</script>';

        return $scripts;
    }

    private function getSettings()
    {
        $defaults = [
            'captcha_id'      => '',
            'captcha_key'     => '',
            'product'         => 'bind',
            'risk_type'       => 'auto',
            'enable_login'    => 1,
            'enable_register' => 1,
            'enable_password' => 1,
        ];

        $settings = array_merge($defaults, (array) $this->getConfig());
        $settings['enable_login'] = 1;

        return $settings;
    }

    private function normalizePath($path)
    {
        $path = strtolower(trim((string) $path, '/'));
        if (strpos($path, 'index.php/') === 0) {
            $path = substr($path, strlen('index.php/'));
        }

        $path = preg_replace('/\?.*$/', '', $path);
        return preg_replace('/\.html$/', '', $path);
    }

    private function resolveBackendPage($path)
    {
        $routes = [
            'login'           => 'login',
            'register'        => 'register',
            'pwreset'         => 'password',
            'modify_password' => 'password',
        ];
        $path = $this->normalizePath($path);
        if ($path === '' && isset($_SERVER['REQUEST_URI'])) {
            $uriPath = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
            $path = $this->normalizePath($uriPath);
        }

        return isset($routes[$path]) ? $routes[$path] : null;
    }

    private function resolveFrontendPage($path)
    {
        $routes = [
            'login'    => 'login',
            'register' => 'register',
            'pwreset'  => 'password_reset',
            'security' => 'password_change',
        ];
        $path = $this->normalizePath($path);
        if ($path === '' && isset($_SERVER['REQUEST_URI'])) {
            $uriPath = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
            $path = $this->normalizePath($uriPath);
        }

        return isset($routes[$path]) ? $routes[$path] : null;
    }

    private function isPageEnabled($page, array $settings)
    {
        if ($page === 'login') {
            return true;
        }
        if ($page === 'register') {
            return !empty($settings['enable_register']);
        }

        return !empty($settings['enable_password']);
    }

    private function normalizeProduct($product)
    {
        $allowed = ['bind', 'popup', 'float'];

        return in_array($product, $allowed, true) ? $product : 'bind';
    }

    private function normalizeRiskType($riskType)
    {
        $allowed = ['auto', 'slide', 'icon', 'ai', 'word', 'phrase', 'match', 'winlinze'];

        return in_array($riskType, $allowed, true) ? $riskType : 'auto';
    }

    private function validateCaptcha(array $payload, array $settings)
    {
        $captchaId = trim((string) $settings['captcha_id']);
        $captchaKey = trim((string) $settings['captcha_key']);
        if ($captchaId === '' || $captchaKey === '') {
            return [
                'success' => false,
                'message' => '极验验证码尚未完成配置，请联系管理员。',
            ];
        }

        $captchaData = [];
        foreach (self::CAPTCHA_FIELDS as $field) {
            $captchaData[$field] = isset($payload[$field]) ? trim((string) $payload[$field]) : '';
            if ($captchaData[$field] === '') {
                return [
                    'success' => false,
                    'message' => '请先完成极验验证码。',
                ];
            }
        }

        $captchaData['sign_token'] = hash_hmac('sha256', $captchaData['lot_number'], $captchaKey);

        try {
            $client = new Client([
                'connect_timeout' => 3.0,
                'timeout'         => 5.0,
                'http_errors'     => false,
            ]);
            $response = $client->post(self::VALIDATE_URL, [
                'query'       => ['captcha_id' => $captchaId],
                'form_params' => $captchaData,
            ]);
            $body = json_decode((string) $response->getBody(), true);

            if ($response->getStatusCode() === 200
                && is_array($body)
                && isset($body['result'])
                && $body['result'] === 'success') {
                return ['success' => true, 'message' => ''];
            }

            return [
                'success' => false,
                'message' => '人机安全验证失败或已过期，请重新验证。',
            ];
        } catch (\Throwable $exception) {
            return [
                'success' => false,
                'message' => '极验服务暂时不可用，请稍后重试。',
            ];
        }
    }

    private function rejectRequest($message)
    {
        $request = request();
        if ($request->isAjax()) {
            $response = Response::create([
                'status' => 400,
                'code'   => 400,
                'msg'    => $message,
                'data'   => [],
            ], 'json', 200);
        } else {
            $safeMessage = htmlspecialchars($message, ENT_QUOTES, 'UTF-8');
            $html = '<!doctype html><html lang="zh-CN"><head><meta charset="utf-8">'
                . '<meta name="viewport" content="width=device-width,initial-scale=1">'
                . '<title>安全验证失败</title>'
                . '<link href="/themes/clientarea/default/assets/libs/toastr/build/toastr.min.css" rel="stylesheet">'
                . '<script src="/themes/clientarea/default/assets/libs/jquery/jquery.min.js"></script>'
                . '<script src="/themes/clientarea/default/assets/libs/toastr/build/toastr.min.js"></script>'
                . '</head><body>'
                . '<script>toastr.error("' . addslashes($message) . '"); setTimeout(function(){ history.back(); }, 1200);</script>'
                . '</body></html>';
            $response = Response::create($html, 'html', 200);
        }

        $response->header(['Cache-Control' => 'no-store']);
        throw new HttpResponseException($response);
    }
}
