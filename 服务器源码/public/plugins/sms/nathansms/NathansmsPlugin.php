<?php
// +--------------------------------------------------+
// | Name: NathanSmsPlugin.php
// +--------------------------------------------------+
// | Author: Nathan <www.nanyinet.com>
// +--------------------------------------------------+
// | Copyright (c) 2024 NanYiNet All rights reserved.
// +--------------------------------------------------+
// | Date: 2024-02-25 23:39
// +--------------------------------------------------+
// | Created: PHPStorm
// +--------------------------------------------------+
namespace sms\nathansms;

use app\admin\lib\Plugin;


class NathansmsPlugin extends Plugin
{
    # 基础信息
    public $info = array(
    'name'        => 'Nathansms',//插件类名不带Plugin
    'title'       => 'NathanSMS发信系统插件',
    'description' => 'NathanSMS发信系统插件',
    'status'      => 1,
    'author'      => 'Nathan',
    'version'     => '1.0.0',
    'help_url'    => 'http://www.nanyinet.com/',
    );

    # 插件安装
    public function install()
    {
		//导入模板
		$smsTemplate= [];
		if (file_exists(__DIR__.'/config/smsTemplate.php')){
            $smsTemplate = require __DIR__.'/config/smsTemplate.php';
        }
		
        return $smsTemplate;
    }

    # 插件卸载
    public function uninstall()
    {
        return true;//卸载成功返回true，失败false
    }
	
	# 后台页面创建模板时可用参数
	public function description()
	{
		return file_get_contents(__DIR__.'/config/description.html');    
    } 
	
	#获取国内模板
	public function getCnTemplate($params)
	{				
		$data['status']='success';
		$data['template']['template_status']=2;
		return $data;
	}
	#创建国内模板
	public function createCnTemplate($params)
	{
		$data['status']='success';
		$data['template']['template_status']=2;
		return $data;
	}
	#修改国内模板
	public function putCnTemplate($params)
	{
		$data['status']='success';
		$data['template']['template_status']=2;
		return $data;
	}
	#删除国内模板
	public function deleteCnTemplate($params)
	{
		$data['status']='success';
		return $data;
	}
	#发送国内短信
    public function sendCnSms($params)
    {	   	
        $content=$this->templateParam($params['content'],$params['templateParam']);
		$param['content']=$this->templateSign($params['config']['sign']).$content;
		$param['mobile']=trim($params['mobile']);
        $resultTemplate= $this->APIHttpRequestCURL('cn',$param,$params['config']);
		if($resultTemplate['status']=="success"){
			$data['status']="success";
			$data['content']=$content;
		}else{
			$data['status']="error";
			$data['content']=$content;
			$data['msg']=$resultTemplate['msg'];
		}
		return $data;
    }	
	#获取国际模板
	public function getGlobalTemplate($params)
	{		
		$data['status']='success';
		$data['template']['template_status']=2;
		return $data;
	}
	#创建国际模板
	public function createGlobalTemplate($params)
	{
		$data['status']='success';
		$data['template']['template_status']=2;
		return $data;
	}
	#修改国际模板
	public function putGlobalTemplate($params)
	{
		$data['status']='success';
		$data['template']['template_status']=2;
		return $data;
	}
	#删除国际模板
	public function deleteGlobalTemplate($params)
	{
		$data['status']='success';
		return $data;
	}
	#发送国际短信
    public function sendGlobalSms($params)
    {
    	$content=$this->templateParam($params['content'],$params['templateParam']);
		
		$param['content']=$this->templateSign($params['config']['sign']).$content;
		$param['mobile']=trim($params['mobile']);
        $resultTemplate= $this->APIHttpRequestCURL('global',$param,$params['config']);
		if($resultTemplate['status']=="success"){
			$data['status']="success";
			$data['content']=$content;
		}else{
			$data['status']="error";
			$data['content']=$content;
			$data['msg']=$resultTemplate['msg'];
		}
		return $data;
    }	
	
	# 以下函数名自定义

	private function APIHttpRequestCURL($sms_type = "cn",$params,$config)
	{
		if($sms_type = 'cn') {
            $url = $config['url'] . 'sendApi';
        } else if($sms_type = 'global') {
            $url = $config['url'] . 'sendApi';
        }
        
        if (!isset($config["url"]) || !$config["url"]) {
            return array('status' => "error", 'msg' => '配置错误，通道域名不能为空!');
        }
        
        if (!isset($config["channel"]) || !$config["channel"]) {
            return array('status' => "error", 'msg' => '配置错误，通道ID不能为空!');
        }
        
		if (!isset($config["username"]) || !$config["username"]) {
            return array('status' => "error", 'msg' => '配置错误，用户名不能为空!');
        }

        if (!isset($config["key"]) || !$config["key"]) {
            return array('status' => "error", 'msg' => '配置错误，用户密钥不能为空!');
        }

        if (!isset($config["sign"]) || !$config["sign"]) {
            return array('status' => "error", 'msg' => '配置错误，短信签名不能为空!');
        }

        if (!isset($params["mobile"]) || !$params["mobile"]) {
            return array('status' => "error", 'msg' => '接收手机号不能为空!');
        }
        $apiUrl = $config['url'].'sendApi';//通道域名
        $channel = $config['channel'];//通道ID
        $username = $config['username']; //短信平台用户名
        $key = md5($config['key']); //短信平台密钥
        $content= $params['content'];//要发送的短信内容
        $phone = $params['mobile'];//要发送短信的手机号码
        $queryParams = [
            'channel' => $channel,
            'username' => $username,
            'key' => $key,
            'phone' =>$phone,
            'content' => $content,
        ];
        $requestUrl = $apiUrl . '?' . http_build_query($queryParams);
        $result = file_get_contents($requestUrl);
        $result = json_decode($result,true);
        if ($result['code']  == '1') {
            return array('status' => "success", 'msg' => $result['msg']);
        } else {
            return array('status' => "error", 'msg' =>  $result['msg']);
            }
    }
    private function templateParam($content,$templateParam){
        foreach ($templateParam as $key => $para) {
            $content = str_replace('@var(' . $key . ')', $para, $content);//模板中的参数替换
        }       
		$content =preg_replace("/@var\(.*?\)/is","",$content);
        return $content;
    }
	private function templateSign($sign){
		$sign = str_replace("【","",$sign);
		$sign = str_replace("】","",$sign);
		$sign = "【".$sign."】";  
        return $sign;
    }
}