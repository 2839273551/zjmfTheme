<?php

namespace addons\geetest_captcha\controller;

use app\admin\controller\PluginAdminBaseController;
use think\Db;

class AdminIndexController extends PluginAdminBaseController
{
    const PLUGIN_NAME = 'GeetestCaptcha';

    const PRODUCTS = ['bind', 'popup', 'float'];

    const RISK_TYPES = ['auto', 'slide', 'icon', 'ai', 'word', 'phrase', 'match', 'winlinze'];

    public function setting()
    {
        $plugin = Db::name('plugin')->where('name', self::PLUGIN_NAME)->find();
        if (!$plugin) {
            $this->error('极验验证码插件尚未安装。');
        }

        $settings = array_merge(
            $this->getDefaultSettings(),
            $this->decodeConfig(isset($plugin['config']) ? $plugin['config'] : '')
        );
        $settings['enable_login'] = 1;

        $this->assign('Title', '极验验证码设置');
        $this->assign('Data', $settings);

        return $this->fetch('/setting');
    }

    public function submit()
    {
        if (!$this->request->isPost()) {
            return json(['code' => 405, 'msg' => '请求方式不正确。']);
        }

        $data = $this->request->post();
        $captchaId = trim(isset($data['captcha_id']) ? (string) $data['captcha_id'] : '');
        $captchaKey = trim(isset($data['captcha_key']) ? (string) $data['captcha_key'] : '');
        $product = isset($data['product']) ? (string) $data['product'] : 'bind';
        $riskType = isset($data['risk_type']) ? (string) $data['risk_type'] : 'auto';

        if ($captchaId === '' || $captchaKey === '') {
            return json(['code' => 400, 'msg' => 'Captcha ID 和 Captcha Key 均不能为空。']);
        }
        if (strlen($captchaId) > 255 || strlen($captchaKey) > 255) {
            return json(['code' => 400, 'msg' => '极验认证信息长度不正确。']);
        }
        if (!in_array($product, self::PRODUCTS, true)) {
            return json(['code' => 400, 'msg' => '请选择有效的展现方式。']);
        }
        if (!in_array($riskType, self::RISK_TYPES, true)) {
            return json(['code' => 400, 'msg' => '请选择有效的验证方式。']);
        }

        $plugin = Db::name('plugin')->where('name', self::PLUGIN_NAME)->find();
        if (!$plugin) {
            return json(['code' => 404, 'msg' => '极验验证码插件尚未安装。']);
        }

        $settings = array_merge(
            $this->decodeConfig(isset($plugin['config']) ? $plugin['config'] : ''),
            [
                'captcha_id'      => $captchaId,
                'captcha_key'     => $captchaKey,
                'product'         => $product,
                'risk_type'       => $riskType,
                'enable_login'    => 1,
                'enable_register' => empty($data['enable_register']) ? 0 : 1,
                'enable_password' => empty($data['enable_password']) ? 0 : 1,
            ]
        );

        $encoded = json_encode($settings, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        if ($encoded === false) {
            return json(['code' => 500, 'msg' => '配置编码失败，请重试。']);
        }

        $updated = Db::name('plugin')
            ->where('name', self::PLUGIN_NAME)
            ->update(['config' => $encoded]);

        if ($updated === false) {
            return json(['code' => 500, 'msg' => '保存失败，请稍后重试。']);
        }

        return json(['code' => 200, 'msg' => '极验验证码设置已保存。']);
    }

    private function getDefaultSettings()
    {
        $definitions = require dirname(__DIR__) . '/config.php';
        $defaults = [];

        foreach ($definitions as $name => $definition) {
            $defaults[$name] = isset($definition['value']) ? $definition['value'] : '';
        }

        return $defaults;
    }

    private function decodeConfig($config)
    {
        if (is_array($config)) {
            return $config;
        }

        $decoded = json_decode((string) $config, true);

        return is_array($decoded) ? $decoded : [];
    }
}
