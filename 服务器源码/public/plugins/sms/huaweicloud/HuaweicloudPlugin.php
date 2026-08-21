<?php
namespace sms\huaweicloud;

class HuaweicloudPlugin extends \app\admin\lib\Plugin
{
    public $info = ["name" => "Huaweicloud", "title" => "华为云", "description" => "华为云", "status" => 1, "author" => "智简魔方", "version" => "1.0", "help_url" => "https://www.huaweicloud.com/product/msgsms.html"];
    public function huaweicloudidcsmartauthorize()
    {
    }
    public function install()
    {
        $smsTemplate = [];
        if (file_exists(__DIR__ . "/config/smsTemplate.php")) {
            $smsTemplate = (require __DIR__ . "/config/smsTemplate.php");
        }
        return $smsTemplate;
    }
    public function uninstall()
    {
        return true;
    }
    public function description()
    {
        return file_get_contents(__DIR__ . "/config/description.html");
    }
    public function getCnTemplate($params)
    {
        $data["status"] = "success";
        $data["template"]["template_status"] = 2;
        return $data;
    }
    public function createCnTemplate($params)
    {
        $data["status"] = "success";
        $data["template"]["template_status"] = 2;
        return $data;
    }
    public function putCnTemplate($params)
    {
        $data["status"] = "success";
        $data["template"]["template_status"] = 2;
        return $data;
    }
    public function deleteCnTemplate($params)
    {
        $data["status"] = "success";
        return $data;
    }
    public function sendCnSms($params)
    {
        $content = $this->templateParam($params["content"], $params["templateParam"]);
        $param["content"] = $params["content"];
        $param["template_id"] = trim($params["template_id"]);
        $param["mobile"] = trim($params["mobile"]);
        $param["templateParam"] = $params["templateParam"];
        $resultTemplate = $this->APIHttpRequestCURL("cn", $param, $params["config"]);
        if ($resultTemplate["status"] == "success") {
            $data["status"] = "success";
            $data["content"] = $content;
        } else {
            $data["status"] = "error";
            $data["content"] = $content;
            $data["msg"] = $resultTemplate["msg"];
        }
        return $data;
    }
    public function getGlobalTemplate($params)
    {
        $data["status"] = "success";
        $data["template"]["template_status"] = 2;
        return $data;
    }
    public function createGlobalTemplate($params)
    {
        $data["status"] = "success";
        $data["template"]["template_status"] = 2;
        return $data;
    }
    public function putGlobalTemplate($params)
    {
        $data["status"] = "success";
        $data["template"]["template_status"] = 2;
        return $data;
    }
    public function deleteGlobalTemplate($params)
    {
        $data["status"] = "success";
        return $data;
    }
    public function sendGlobalSms($params)
    {
        $content = $this->templateParam($params["content"], $params["templateParam"]);
        $param["content"] = $params["content"];
        $param["template_id"] = trim($params["template_id"]);
        $param["mobile"] = trim($params["mobile"]);
        $param["templateParam"] = $params["templateParam"];
        $resultTemplate = $this->APIHttpRequestCURL("global", $param, $params["config"]);
        if ($resultTemplate["status"] == "success") {
            $data["status"] = "success";
            $data["content"] = $content;
        } else {
            $data["status"] = "error";
            $data["content"] = $content;
            $data["msg"] = $resultTemplate["msg"];
        }
        return $data;
    }
    private function APIHttpRequestCURL($sms_type = "cn", $params, $config)
    {
        $url = "https://smsapi.cn-north-4.myhuaweicloud.com:443/sms/batchSendSms/v1";
        if ($sms_type == "cn") {
            $sender = $config["cn_sender"];
            $APP_KEY = $config["cn_app_key"];
            $APP_SECRET = $config["cn_app_secret"];
            $receiver = "+86" . $params["mobile"];
        } else {
            if ($sms_type == "global") {
                $sender = $config["global_sender"];
                $APP_KEY = $config["global_app_key"];
                $APP_SECRET = $config["global_app_secret"];
                $receiver = $params["mobile"];
            }
        }
        $TEMPLATE_ID = $params["template_id"];
        $signature = $config["SignName"];
        $statusCallback = "";
        $templateParam = $this->templateParamArray($params["content"], $params["templateParam"]);
        $TEMPLATE_PARAS = !empty($templateParam) ? "[\"" . implode("\",\"", $templateParam) . "\"]" : "";
        $headers = ["Content-Type: application/x-www-form-urlencoded", "Authorization: WSSE realm=\"SDP\",profile=\"UsernameToken\",type=\"Appkey\"", "X-WSSE: " . $this->buildWsseHeader($APP_KEY, $APP_SECRET)];
        $data = ["from" => $sender, "to" => $receiver, "templateId" => $TEMPLATE_ID, "templateParas" => $TEMPLATE_PARAS, "statusCallback" => $statusCallback, "signature" => $signature];
        if ($sms_type == "global") {
            unset($data["signature"]);
        }
        $context_options = ["http" => ["method" => "POST", "header" => $headers, "content" => http_build_query($data), "ignore_errors" => true], "ssl" => ["verify_peer" => false, "verify_peer_name" => false]];
        $response = file_get_contents($url, false, stream_context_create($context_options));
        $result = json_decode($response, true);
        if (isset($result["description"])) {
            if ($result["code"] == "000000") {
                return ["status" => "success", "msg" => "短信发送成功"];
            }
            return ["status" => "error", "msg" => $result["description"]];
        }
        return ["status" => "error", "msg" => "短信发送失败"];
    }
    private function templateParam($content, $templateParam)
    {
        foreach ($templateParam as $key => $para) {
            $content = str_replace("\${" . $key . "}", $para, $content);
        }
        $content = preg_replace("/\\\$\\{.*?\\}/is", "", $content);
        return $content;
    }
    private function contentParamReplace($content = "")
    {
        if (empty($content)) {
            return $content;
        }
        preg_match_all("/(?<=\\{)([^\\}]*?)(?=\\})/", $content, $arr);
        if (empty($arr[0])) {
            return $content;
        }
        foreach ($arr[0] as $k => $v) {
            $content = str_replace("{" . $v . "}", "{" . ($k + 1) . "}", $content);
        }
        return $content;
    }
    private function templateParamArray($content = "", $templateParam = [])
    {
        if (empty($content)) {
            return [];
        }
        preg_match_all("/(?<=\\{)([^\\}]*?)(?=\\})/", $content, $arr);
        if (empty($arr[0])) {
            return [];
        }
        $params = [];
        foreach ($arr[0] as $k => $v) {
            $params[] = (string) $templateParam[$v];
        }
        return $params;
    }
    private function buildWsseHeader($appKey, $appSecret)
    {
        date_default_timezone_set("Asia/Shanghai");
        $now = date("Y-m-d\\TH:i:s\\Z");
        $nonce = uniqid();
        $base64 = base64_encode(hash("sha256", $nonce . $now . $appSecret));
        return sprintf("UsernameToken Username=\"%s\",PasswordDigest=\"%s\",Nonce=\"%s\",Created=\"%s\"", $appKey, $base64, $nonce, $now);
    }
}

?>