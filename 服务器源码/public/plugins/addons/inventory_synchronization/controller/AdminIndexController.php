<?php
namespace addons\inventory_synchronization\controller;

class AdminIndexController extends \app\admin\controller\PluginAdminBaseController
{
    public function setting()
    {
        $configData = \think\DB::name("inventory_synchronization_config")->find();
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
        $apiid = isset($data["apiid"]) ? $data["apiid"] : NULL;
        $apikey = isset($data["apikey"]) ? $data["apikey"] : NULL;
        $webmasteremail = isset($data["webmasteremail"]) ? $data["webmasteremail"] : NULL;
        $webmasterqq = isset($data["webmasterqq"]) ? $data["webmasterqq"] : NULL;
        $authorize = isset($data["authorize"]) ? $data["authorize"] : NULL;
        $sitename = isset($data["sitename"]) ? $data["sitename"] : NULL;
        $open = isset($data["open"]) ? $data["open"] : NULL;
        $automatic = isset($data["automatic"]) ? $data["automatic"] : NULL;
        $dbConfig = ["open" => $open, "apiid" => $apiid, "apikey" => $apikey, "sitename" => $sitename, "webmasteremail" => $webmasteremail, "webmasterqq" => $webmasterqq, "authorize" => $authorize, "automatic" => $automatic, "weburl" => $_SERVER["HTTP_HOST"]];
        $result = \think\DB::name("inventory_synchronization_config")->where("id", 1)->find();
        if ($result) {
            $updateResult = \think\DB::name("inventory_synchronization_config")->where("id", 1)->update($dbConfig);
            if ($updateResult !== false) {
                $response = ["code" => 200, "msg" => "设置更新成功。"];
            } else {
                $response = ["code" => 500, "msg" => "设置更新出错。"];
            }
        } else {
            $dbConfig["id"] = 1;
            $insertResult = \think\DB::name("inventory_synchronization_config")->insert($dbConfig);
            if ($insertResult !== false) {
                $response = ["code" => 200, "msg" => "设置首次配置已成功。"];
            } else {
                $response = ["code" => 500, "msg" => "设置首次配置时出错。"];
            }
        }
        return json($response);
    }
    public function records()
    {
        $page = input("page", 1);
        $pageSize = 10;
        $rules = \think\DB::name("inventory_synchronization_record")->alias("isr")->field("isr.*, p.name, p.hidden")->join("products p", "isr.product_id = p.id", "LEFT")->order("isr.id", "desc")->paginate($pageSize, false, ["page" => $page]);
        $url = $_SERVER["REQUEST_URI"];
        $domain = dirname($url);
        $this->assign("domain", $domain);
        $this->assign("data", $rules);
        $this->assign("Title", "同步记录");
        return $this->fetch("/records");
    }
    public function tongbu()
    {
        $Info = \think\DB::name("inventory_synchronization_config")->where("id", 1)->find();
        if ($Info["open"] == 1) {
            $products = \think\DB::name("products")->where("upstream_stock_control", 1)->where("api_type", "zjmf_api")->select();
            $count = 0;
            foreach ($products as $product) {
                if ($product["stock_control"] == 0) {
                    if ($Info["automatic"] == 1 && $product["upstream_qty"] == 0) {
                        $res = \think\DB::name("products")->where("id", $product["id"])->update(["stock_control" => 1, "hidden" => 1, "qty" => $product["upstream_qty"]]);
                        if ($res) {
                            $data = ["product_id" => $product["id"], "product_name" => $product["name"], "local_inventory" => $product["qty"], "upstream_inventory" => $product["upstream_qty"], "method" => "0", "time" => time(), "status" => $product["hidden"]];
                            \think\DB::name("inventory_synchronization_record")->insert($data);
                            $count++;
                        }
                    } else {
                        if ($Info["automatic"] == 1 && $product["upstream_qty"] !== 0) {
                            $res = \think\DB::name("products")->where("id", $product["id"])->update(["stock_control" => 1, "hidden" => 0, "qty" => $product["upstream_qty"]]);
                            if ($res) {
                                $data = ["product_id" => $product["id"], "product_name" => $product["name"], "local_inventory" => $product["qty"], "upstream_inventory" => $product["upstream_qty"], "method" => "0", "time" => time(), "status" => $product["hidden"]];
                                \think\DB::name("inventory_synchronization_record")->insert($data);
                            }
                        } else {
                            if ($product["upstream_qty"] == $product["qty"]) {
                                \think\DB::name("products")->where("id", $product["id"])->update(["stock_control" => 1]);
                            } else {
                                $res = \think\DB::name("products")->where("id", $product["id"])->update(["stock_control" => 1, "qty" => $product["upstream_qty"]]);
                                if ($res) {
                                    $data = ["product_id" => $product["id"], "product_name" => $product["name"], "local_inventory" => $product["qty"], "upstream_inventory" => $product["upstream_qty"], "method" => "0", "time" => time(), "status" => $product["hidden"]];
                                    \think\DB::name("inventory_synchronization_record")->insert($data);
                                    $count++;
                                }
                            }
                        }
                    }
                } else {
                    if ($product["stock_control"] == 1) {
                        if ($product["qty"] !== $product["upstream_qty"]) {
                            if ($Info["automatic"] == 1 && $product["upstream_qty"] == 0) {
                                $res = \think\DB::name("products")->where("id", $product["id"])->update(["hidden" => 1, "qty" => $product["upstream_qty"]]);
                                if ($res) {
                                    $data = ["product_id" => $product["id"], "product_name" => $product["name"], "local_inventory" => $product["qty"], "upstream_inventory" => $product["upstream_qty"], "method" => "0", "time" => time(), "status" => $product["hidden"]];
                                    \think\DB::name("inventory_synchronization_record")->insert($data);
                                    $count++;
                                }
                            } else {
                                if ($Info["automatic"] == 1 && $product["upstream_qty"] !== 0 && $product["qty"] !== $product["upstream_qty"]) {
                                    $res = \think\DB::name("products")->where("id", $product["id"])->update(["hidden" => 0, "qty" => $product["upstream_qty"]]);
                                    if ($res) {
                                        $data = ["product_id" => $product["id"], "product_name" => $product["name"], "local_inventory" => $product["qty"], "upstream_inventory" => $product["upstream_qty"], "method" => "0", "time" => time(), "status" => $product["hidden"]];
                                        \think\DB::name("inventory_synchronization_record")->insert($data);
                                        $count++;
                                    }
                                }
                            }
                        } else {
                            if ($Info["automatic"] == 1 && $product["qty"] == $product["upstream_qty"] && $product["upstream_qty"] !== 0) {
                                $res = \think\DB::name("products")->where("id", $product["id"])->update(["hidden" => 0]);
                            } else {
                                if ($Info["automatic"] == 1 && $product["qty"] == $product["upstream_qty"] && $product["upstream_qty"] == 0) {
                                    $res = \think\DB::name("products")->where("id", $product["id"])->update(["hidden" => 1]);
                                } else {
                                    $res = \think\DB::name("products")->where("id", $product["id"])->update(["qty" => $product["upstream_qty"]]);
                                    if ($res) {
                                        $data = ["product_id" => $product["id"], "product_name" => $product["name"], "local_inventory" => $product["qty"], "upstream_inventory" => $product["upstream_qty"], "method" => "0", "time" => time(), "status" => $product["hidden"]];
                                        \think\DB::name("inventory_synchronization_record")->insert($data);
                                        $count++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return json(["code" => 200, "msg" => "共同步成功 " . $count . " 条数据"]);
        } else {
            return json(["code" => 400, "msg" => "同步功能未开启"]);
        }
    }
    public function deletelists()
    {
        $result = \think\DB::execute("TRUNCATE TABLE shd_inventory_synchronization_record");
        if ($result !== false) {
            return json(["code" => 200, "msg" => "清理日志成功"]);
        }
        return json(["code" => 500, "msg" => "清理日志失败"]);
    }
    public function customerdetail3()
    {
        $this->assign("Title", "Demo样式4");
        return $this->fetch("/customerdetail3");
    }
    public function customerdetail4()
    {
        $this->assign("Title", "Demo样式5");
        return $this->fetch("/customerdetail4");
    }
    public function helplist()
    {
        $this->assign("Title", "Demo样式6");
        return $this->fetch("/helplist");
    }
}

?>