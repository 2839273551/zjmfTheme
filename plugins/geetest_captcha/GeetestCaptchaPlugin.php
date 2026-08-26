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
        'description' => '为登录、注册和密码操作提供极验行为验证第四代及服务端二次校验',
        'status'      => 1,
        'author'      => 'IDCsmart',
        'version'     => '1.0.3',
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
     * Validate protected POST requests before encrypted application controllers run.
     */
    public function appBegin()
    {
        $request = request();
        if (!$request->isPost()) {
            return null;
        }

        $page = $this->resolveBackendPage($request->path());
        if ($page === null) {
            return null;
        }

        $settings = $this->getSettings();
        if (!$this->isPageEnabled($page, $settings)) {
            return null;
        }

        $result = $this->validateCaptcha($request->post(), $settings);
        if (!$result['success']) {
            $this->rejectRequest($result['message']);
        }

        self::$requestValidated = true;

        return null;
    }

    /**
     * Replace IDCsmart's image captcha when its page-level captcha switch is on.
     * The actual GeeTest component is injected once from the footer hook.
     */
    public function templateCustomClientareaCaptchaHtml($params)
    {
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
     * Let the encrypted controller reuse the successful app_begin validation
     * instead of attempting IDCsmart's native image captcha afterwards.
     */
    public function customCaptchaCheck($params)
    {
        return self::$requestValidated ? true : null;
    }

    /**
     * Inject the client integration after the page forms have been rendered.
     */
    public function clientAreaFooterOutput()
    {
        $request = request();
        if ($request->isPost()) {
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
            'configured'  => $configured,
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
        $scripts .= '<script src="/plugins/addons/geetest_captcha/assets/geetest-captcha.js?v=1.0.3"></script>';
        $scripts .= '<script>window.GeetestCaptchaPlugin.boot(' . $json . ');</script>';

        return $scripts;
    }

    private function getSettings()
    {
        $defaults = [
            'captcha_id'     => '',
            'captcha_key'    => '',
            'product'        => 'bind',
            'risk_type'      => 'auto',
            'enable_login'   => 1,
            'enable_register' => 0,
            'enable_password' => 0,
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
                'message' => '极验验证失败或已过期，请重新验证。',
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
                . '<title>安全验证失败</title></head><body>'
                . '<main style="max-width:520px;margin:12vh auto;padding:24px;font-family:Arial,sans-serif">'
                . '<h1 style="font-size:22px">安全验证失败</h1><p>' . $safeMessage . '</p>'
                . '<p><a href="javascript:history.back()">返回重试</a></p></main></body></html>';
            $response = Response::create($html, 'html', 403);
        }

        $response->header(['Cache-Control' => 'no-store']);
        throw new HttpResponseException($response);
    }
}
