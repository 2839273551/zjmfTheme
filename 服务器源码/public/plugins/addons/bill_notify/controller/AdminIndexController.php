<?php
namespace addons\bill_notify\controller;

class AdminIndexController extends \app\admin\controller\PluginAdminBaseController
{
    public function setting()
    {
        $configurationsModel = \Think\Db::name("bill_notify");
        $configData = $configurationsModel->find();
        $isMismatch = false;
        $mismatchMessage = "恭喜您，授权成功";
        $this->assign("Title", "功能设置");
        $this->assign("Data", $configData);
        $this->assign("IsMismatch", $isMismatch);
        $this->assign("MismatchMessage", $mismatchMessage);
        return $this->fetch("/setting");
    }
    public function submit()
    {
        $data = $this->request->post();
        $zzemail = isset($data["zzemail"]) ? $data["zzemail"] : NULL;
        $zzqq = isset($data["zzqq"]) ? $data["zzqq"] : NULL;
        $mfauth = isset($data["mfauth"]) ? $data["mfauth"] : NULL;
        $smtp_is = isset($data["smtp_is"]) ? $data["smtp_is"] : NULL;
        $smtp_host = isset($data["smtp_host"]) ? $data["smtp_host"] : NULL;
        $smtp_name = isset($data["smtp_name"]) ? $data["smtp_name"] : NULL;
        $smtp_pass = isset($data["smtp_pass"]) ? $data["smtp_pass"] : NULL;
        $smtp_port = isset($data["smtp_port"]) ? $data["smtp_port"] : NULL;
        $smtp_secure = isset($data["smtp_secure"]) ? $data["smtp_secure"] : NULL;
        $from_name = isset($data["from_name"]) ? $data["from_name"] : NULL;
        $chongzhi = isset($data["chongzhi"]) ? $data["chongzhi"] : NULL;
        $chanpin = isset($data["chanpin"]) ? $data["chanpin"] : NULL;
        $xufei = isset($data["xufei"]) ? $data["xufei"] : NULL;
        $tzemail = isset($data["tzemail"]) ? $data["tzemail"] : NULL;
        $amount = isset($data["amount"]) ? $data["amount"] : NULL;
        if (empty($data["amount"])) {
            $response = ["code" => 400, "msg" => "请正确输入通知起始金额。"];
            return json($response);
        }
        $dbConfig = ["zzemail" => $zzemail, "zzqq" => $zzqq, "mfauth" => $mfauth, "smtp_host" => $smtp_host, "smtp_name" => $smtp_name, "smtp_pass" => $smtp_pass, "smtp_port" => $smtp_port, "smtp_secure" => $smtp_secure, "from_name" => $from_name, "chongzhi" => $chongzhi, "chanpin" => $chanpin, "xufei" => $xufei, "tzemail" => $tzemail, "amount" => $amount, "weburl" => $_SERVER["HTTP_HOST"]];
        $result = \Think\Db::name("bill_notify")->where("id", 1)->find();
        if ($result) {
            $updateResult = \Think\Db::name("bill_notify")->where("id", 1)->update($dbConfig);
            if ($updateResult !== false) {
                $response = ["code" => 200, "msg" => "设置已成功更新。"];
            } else {
                $response = ["code" => 500, "msg" => "更新设置时出错。"];
            }
        } else {
            $dbConfig["id"] = 1;
            $insertResult = \Think\Db::name("bill_notify")->insert($dbConfig);
            if ($insertResult !== false) {
                $response = ["code" => 200, "msg" => "设置首次配置已成功。"];
            } else {
                $response = ["code" => 500, "msg" => "设置首次配置时出错。"];
            }
        }
        return json($response);
    }
}

?>