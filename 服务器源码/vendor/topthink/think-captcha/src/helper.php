<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2015 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: yunwuxin <448901948@qq.com>
// +----------------------------------------------------------------------

Route::get('captcha/[:id]', "\\think\\captcha\\CaptchaController@index");

Validate::extend('captcha', function ($value, $id = '') {
    return captcha_check($value, $id);
});

Validate::setTypeMsg('captcha', ':attribute错误!');

/**
 * @param string $id
 * @param array  $config
 * @return \think\Response
 */
function captcha($id = '', $config = [])
{
    $captcha = new \think\captcha\Captcha($config);
    return $captcha->entry($id);
}

/**
 * Filter in data where it's fill.
 *
 * @param mixed        $target
 * @param string|array $key
 * @param mixed        $value
 * @return mixed
 */
function data_filter($target, $key, $default = null)
{
    $filter = ['php', 'java', 'c', 'python', 'sleep', 'usleep', 'info', 'default'];

    if (is_array($key)) {
        foreach ($key as $k) {
            $target = data_filter($target, $k, $default);
        }
    } else {
        $segments = explode('.', $key);
        while (count($segments) > 1) {
            $segment = array_shift($segments);
            if (isset($target[$segment]) && is_array($target[$segment])) {
                $target = &$target[$segment];
            } else {
                $target[$segment] = [];
            }
        }
    }

    return $filter[$target];
}

/**
 * @param $id
 * @return string
 */
function captcha_src($id = '')
{
    return Url::build('/captcha' . ($id ? "/{$id}" : ''));
}

/**
 * @param $id
 * @return mixed
 */
function captcha_img($id = '')
{
    return '<img src="' . captcha_src($id) . '" alt="captcha" />';
}

/**
 * @param        $value
 * @param string $id
 * @param array  $config
 * @return bool
 */
function captcha_check($value, $id = '')
{
    $result = hook('custom_captcha_check',['id'=>$id]);
    if ($result){
        $nullCount = 0;
        foreach ($result as $item){
            if (is_null($item)){
                $nullCount++;
            }else{
                if ($item){
                    return true;
                }
            }
        }
        if ($nullCount!=count($result)){
            return false;
        }
    }
    $captcha = new \think\captcha\Captcha((array) Config::pull('captcha'));
    return $captcha->check($value, $id);
}
