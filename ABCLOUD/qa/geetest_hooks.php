<?php
use think\facade\Hook;

Hook::add('app_begin', 'addons\\geetest_captcha\\GeetestCaptchaPlugin');
Hook::add('custom_captcha_check', 'addons\\geetest_captcha\\GeetestCaptchaPlugin');
Hook::add('template_custom_clientarea_captcha_html', 'addons\\geetest_captcha\\GeetestCaptchaPlugin');
Hook::add('client_area_footer_output', 'addons\\geetest_captcha\\GeetestCaptchaPlugin');
