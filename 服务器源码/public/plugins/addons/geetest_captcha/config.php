<?php

return [
    'captcha_id' => [
        'title' => '验证 ID（Captcha ID / API Key）',
        'type'  => 'text',
        'value' => '',
        'tip'   => '从极验 GT4 后台复制。该值会下发到浏览器。',
    ],
    'captcha_key' => [
        'title' => '验证私钥（Captcha Key）',
        'type'  => 'password',
        'value' => '',
        'tip'   => '仅用于服务端生成 sign_token，不会下发到浏览器。',
    ],
    'product' => [
        'title'   => '展现方式',
        'type'    => 'select',
        'options' => [
            'bind'  => '隐藏触发（提交时唤起，推荐）',
            'popup' => '弹出式',
            'float' => '浮动式',
        ],
        'value' => 'bind',
        'tip'   => '对应 GT4 Web API 的 product 参数。',
    ],
    'risk_type' => [
        'title'   => '验证方式',
        'type'    => 'select',
        'options' => [
            'auto'     => '智能策略（由极验配置决定）',
            'slide'    => '滑动拼图验证',
            'icon'     => '图标点选验证',
            'ai'       => '一点即过 / 无感验证',
            'word'     => '文字点选验证',
            'phrase'   => '字序点选验证',
            'match'    => '消消乐验证',
            'winlinze' => '五子棋验证',
        ],
        'value' => 'auto',
        'tip'   => '对应 GT4 Web API 的 riskType 参数；智能策略不会强制指定题型。',
    ],
    'enable_login' => [
        'title'   => '登录页',
        'type'    => 'select',
        'options' => [
            '1' => '强制开启',
        ],
        'value' => '1',
        'tip'   => '登录页始终启用，无法关闭。',
    ],
    'enable_register' => [
        'title'   => '注册页',
        'type'    => 'select',
        'options' => [
            '0' => '关闭',
            '1' => '开启',
        ],
        'value' => '0',
        'tip'   => '开启后保护邮箱注册和手机注册。',
    ],
    'enable_password' => [
        'title'   => '修改/重置密码页',
        'type'    => 'select',
        'options' => [
            '0' => '关闭',
            '1' => '开启',
        ],
        'value' => '0',
        'tip'   => '同时保护忘记密码重置和登录后的修改密码。',
    ],
];
