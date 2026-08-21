<?php
namespace mail\asiayun_smtp_pro;

class AsiayunSmtpProPlugin extends \app\admin\lib\Plugin
{
    public $info = ["name" => "AsiayunSmtpPro", "title" => "Smtp增强版", "description" => "解决smtp不支持ssl的问题", "status" => 1, "author" => "亚洲云", "version" => "1.1", "help_url" => "https://asiayun.com/?from=idcsmart_ext_stmppro"];
    private $isDebug = 0;
    const ATTACHMENTS_ADDRESS = "./upload/common/email/";
    public function asiayunSmtpProidcsmartauthorize()
    {
    }
    public function install()
    {
        return true;
    }
    public function uninstall()
    {
        return true;
    }
    public function send($params)
    {
        $mail = $this->getMail($params["config"]);
        $mail->addAddress($params["email"]);
        $mail->addCC($params["email"]);
        $mail->addBCC($params["email"]);
        if (!empty($params["attachments"])) {
            $attachments = explode(",", $params["attachments"]);
            foreach ($attachments as $attachment) {
                list($originalName) = explode("^", $attachment);
                $mail->AddAttachment(self::ATTACHMENTS_ADDRESS . $attachment, $originalName);
            }
        }
        $mail->Body = $params["content"];
        if ($params["subject"]) {
            $mail->Subject = $params["subject"];
        }
        $result = $mail->send();
        $mail->ClearAllRecipients();
        if (!$result) {
            $encoding = mb_detect_encoding($mail->ErrorInfo, ["ASCII", "UTF-8", "GB2312", "GBK", "BIG5"]);
            if ($encoding != "UTF-8") {
                $mail->ErrorInfo = mb_convert_encoding($mail->ErrorInfo, "UTF-8", $encoding);
            }
            return ["status" => "error", "msg" => $mail->ErrorInfo];
        }
        return ["status" => "success"];
    }
    private function getMail($config = [])
    {
        $mail = new \PHPMailer\PHPMailer\PHPMailer();
        $mail->clearCCs();
        $mail->clearBCCs();
        $mail->clearAddresses();
        $mail->clearAttachments();
        $mail->clearAllRecipients();
        $mail->SMTPDebug = $this->isDebug;
        $mail->isSMTP();
        $mail->SMTPAuth = true;
        $mail->Timeout = 10;
        $mail->Host = $config["host"];
        $mail->SMTPSecure = strtolower($config["smtpsecure"]);
        $mail->Port = $config["port"];
        $mail->SMTPOptions = ["ssl" => ["verify_peer" => false, "verify_peer_name" => false, "allow_self_signed" => true]];
        $mail->CharSet = $config["charset"];
        $mail->FromName = $config["fromname"];
        $mail->Username = $config["username"];
        $mail->Password = $config["password"];
        $mail->From = $config["systememail"];
        $mail->isHTML(true);
        return $mail;
    }
}

?>