<?php
namespace addons\bill_notify;

class BillNotifyPlugin extends \app\admin\lib\Plugin
{
    public $info = ["name" => "BillNotify", "title" => "账单支付通知【邮件版】", "description" => "账单支付通知，支持开启购买产品支付通知，充值支付通知，续费通知", "status" => 1, "author" => "<a href=\"http://www.yunbuyun.com\">云步云计算</a>", "version" => "1.0.3", "module" => "addons"];
    public function install()
    {
        $fieldsToAdd = [["name" => "id", "type" => "INT AUTO_INCREMENT PRIMARY KEY"], ["name" => "zzqq", "type" => "VARCHAR(255)"], ["name" => "zzemail", "type" => "VARCHAR(255)"], ["name" => "weburl", "type" => "VARCHAR(255)"], ["name" => "mfauth", "type" => "VARCHAR(255)"], ["name" => "amount", "type" => "VARCHAR(255)"], ["name" => "smtp_host", "type" => "VARCHAR(255)"], ["name" => "smtp_name", "type" => "VARCHAR(255)"], ["name" => "smtp_pass", "type" => "VARCHAR(255)"], ["name" => "smtp_port", "type" => "INT"], ["name" => "smtp_secure", "type" => "VARCHAR(255)"], ["name" => "from_name", "type" => "TEXT"], ["name" => "chongzhi", "type" => "TEXT"], ["name" => "chanpin", "type" => "TEXT"], ["name" => "xufei", "type" => "TEXT"], ["name" => "tzemail", "type" => "TEXT"]];
        $tableName = "shd_bill_notify";
        $tableExists = \Think\Db::query("SHOW TABLES LIKE '" . $tableName . "'");
        if (empty($tableExists)) {
            $sql = "\n            CREATE TABLE " . $tableName . " (\n                " . implode(",\n", array_map(function ($fieldInfo) {
                return $fieldInfo["name"] . " " . $fieldInfo["type"] . " COMMENT '" . $fieldInfo["comment"] . "'";
            }, $fieldsToAdd)) . "\n            );\n        ";
            \Think\Db::execute($sql);
        } else {
            foreach ($fieldsToAdd as $fieldInfo) {
                $fieldName = $fieldInfo["name"];
                $fieldExists = \Think\Db::query("SHOW COLUMNS FROM " . $tableName . " LIKE '" . $fieldName . "'");
                if (empty($fieldExists)) {
                    $sql = "\n                    ALTER TABLE " . $tableName . "\n                    ADD COLUMN " . $fieldInfo["name"] . " " . $fieldInfo["type"] . " COMMENT '" . $fieldInfo["comment"] . "';\n                ";
                    \Think\Db::execute($sql);
                }
            }
        }
        return true;
    }
    public function uninstall()
    {
        return true;
    }
    public function invoicePaid($params)
    {
        $invoiceid = $params["invoiceid"];
        $Info = \Think\Db::name("bill_notify")->where("id", 1)->find();
        if (!empty($invoiceid)) {
            $invoicesInfo = \Think\Db::name("invoices")->where("id", $invoiceid)->field("uid, type, notes, payment, credit, subtotal, create_time, paid_time")->find();
            $notes = $invoicesInfo["notes"];
            $uid = $invoicesInfo["uid"];
            $subtotal = $invoicesInfo["subtotal"];
            $create_time = date("Y-m-d H:i:s", $invoicesInfo["create_time"]);
            $paid_time = date("Y-m-d H:i:s", $invoicesInfo["paid_time"]);
            $type = $invoicesInfo["type"];
            $text = $type == "recharge" ? "充值" : ($type == "product" ? "产品" : ($type == "renew" ? "续费" : "未知类型"));
            $payment = $invoicesInfo["subtotal"] == $invoicesInfo["credit"] ? "余额支付" : ($invoicesInfo["credit"] != "0.00" ? "余额+" . (\Think\Db::name("plugin")->where("name", $invoicesInfo["payment"])->value("title") ?: $invoicesInfo["payment"]) : (\Think\Db::name("plugin")->where("name", $invoicesInfo["payment"])->value("title") ?: $invoicesInfo["payment"]));
            $uidInfo = \Think\Db::name("clients")->where("id", $invoicesInfo["uid"])->field("username, email")->find();
            $ename = $uidInfo["username"];
            $email = $uidInfo["email"];
            $invoicestem = \Think\Db::name("invoice_items")->where("invoice_id", $invoiceid)->field("description")->find();
            $description = $invoicestem["description"];
            $notifyField = "";
            if ($type == "recharge") {
                $notifyField = "chongzhi";
            } else {
                if ($type == "product") {
                    $notifyField = "chanpin";
                } else {
                    if ($type == "renew") {
                        $notifyField = "xufei";
                    }
                }
            }
            if (!empty($notifyField)) {
                $notifyInfo = \Think\Db::name("bill_notify")->field($notifyField . ", smtp_host, smtp_name, smtp_pass, smtp_port, smtp_secure, from_name, tzemail")->where("id", 1)->find();
            }
            $notifyValue = $notifyInfo[$notifyField];
            if ($notifyValue != 1) {
                return false;
            }
            $specifiedAmousubab = $Info["amount"];
            if ($specifiedAmousubab <= $subtotal) {
                $mail = new \PHPMailer\PHPMailer\PHPMailer(true);
                try {
                    $mail->isSMTP();
                    $mail->CharSet = "UTF-8";
                    $mail->Host = $notifyInfo["smtp_host"];
                    $mail->SMTPAuth = true;
                    $mail->Username = $notifyInfo["smtp_name"];
                    $mail->Password = $notifyInfo["smtp_pass"];
                    $mail->SMTPSecure = $notifyInfo["smtp_secure"];
                    $mail->Port = $notifyInfo["smtp_port"];
                    $mail->setFrom($notifyInfo["smtp_name"], $notifyInfo["from_name"]);
                    $mail->addAddress($notifyInfo["tzemail"]);
                    $mail->Subject = "账单支付通知";
                    if ($text == "充值") {
                        $mail->Subject = "【充值通知】用户" . $ename . "充值支付到账！";
                    } else {
                        if ($text == "产品") {
                            $mail->Subject = "【购买通知】用户" . $ename . "购买产品支付成功！";
                        } else {
                            if ($text == "续费") {
                                $mail->Subject = "【续费通知】用户" . $ename . "续费成功通知！";
                            } else {
                                $mail->Subject = "【未知类型】账单支付到账通知";
                            }
                        }
                    }
                    $mail->Body = $text . " 账单支付到账通知！\n用户账户：" . $ename . " \n电子邮箱：" . $email . " \n账单编号：" . $invoiceid . " \n账单类型：" . $text . " \n账单金额：" . $subtotal . " 元 \n支付方式：" . $payment . " \n创建时间：" . $create_time . " \n支付时间：" . $paid_time . " \n产品详情：" . $description . " ";
                    $mail->send();
                    $sentStatus = 1;
                    $failReason = "发送成功";
                } catch (\PHPMailer\PHPMailer\Exception $e) {
                    $sentStatus = 0;
                    $failReason = $e->getMessage();
                }
                $logData1 = ["uid" => 1, "subject" => $mail->Subject, "message" => $mail->Body, "to" => $notifyInfo["tzemail"], "create_time" => time(), "is_admin" => 0, "ip" => "0.0.0.0", "port" => 0, "status" => $sentStatus, "fail_reason" => $failReason];
                \Think\Db::name("email_log")->insert($logData1);
            }
        }
    }
}

?>