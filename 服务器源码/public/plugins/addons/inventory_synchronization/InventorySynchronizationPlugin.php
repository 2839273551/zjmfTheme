<?php
namespace addons\inventory_synchronization;

class InventorySynchronizationPlugin extends \app\admin\lib\Plugin
{
    public $info = ["name" => "InventorySynchronization", "title" => "库存同步（高级版）", "description" => "库存同步（高级版），支持同步上游库存到本地，支持设置上游无库存时自动下架（隐藏）产品", "status" => 1, "author" => "<a href=\"http://www.yunbuyun.com\">云步云计算</a>", "version" => "1.0.5", "module" => "addons", "lang" => ["chinese" => "库存同步（高级版）", "chinese_tw" => "庫存同步（高级版）", "english" => "Inventory Synchronization"]];
    public function install()
    {
        $fieldsToAddTable1 = [["name" => "id", "type" => "INT AUTO_INCREMENT PRIMARY KEY"], ["name" => "open", "type" => "VARCHAR(255)"], ["name" => "automatic", "type" => "VARCHAR(255)"], ["name" => "apiid", "type" => "VARCHAR(255)"], ["name" => "apikey", "type" => "VARCHAR(255)"], ["name" => "weburl", "type" => "VARCHAR(255)"], ["name" => "sitename", "type" => "VARCHAR(255)"], ["name" => "webmasteremail", "type" => "VARCHAR(255)"], ["name" => "webmasterqq", "type" => "VARCHAR(255)"], ["name" => "authorize", "type" => "VARCHAR(255)"], ["name" => "created_at", "type" => "TIMESTAMP DEFAULT CURRENT_TIMESTAMP"], ["name" => "updated_at", "type" => "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"]];
        $fieldsToAddTable2 = [["name" => "id", "type" => "INT AUTO_INCREMENT PRIMARY KEY"], ["name" => "product_id", "type" => "VARCHAR(255)"], ["name" => "product_name", "type" => "VARCHAR(255)"], ["name" => "local_inventory", "type" => "VARCHAR(255)"], ["name" => "upstream_inventory", "type" => "VARCHAR(255)"], ["name" => "method", "type" => "VARCHAR(255)"], ["name" => "time", "type" => "VARCHAR(255)"], ["name" => "status", "type" => "VARCHAR(255)"], ["name" => "created_at", "type" => "TIMESTAMP DEFAULT CURRENT_TIMESTAMP"], ["name" => "updated_at", "type" => "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"]];
        $tableName1 = "shd_inventory_synchronization_config";
        $tableExists1 = \think\DB::query("SHOW TABLES LIKE '" . $tableName1 . "'");
        if (empty($tableExists1)) {
            $sql1 = "\n                    CREATE TABLE " . $tableName1 . " (\n                        " . implode(",\n", array_map(function ($fieldInfo) {
                return $fieldInfo["name"] . " " . $fieldInfo["type"] . " COMMENT '" . $fieldInfo["comment"] . "'";
            }, $fieldsToAddTable1)) . "\n                    );\n                ";
            \think\DB::execute($sql1);
        } else {
            foreach ($fieldsToAddTable1 as $fieldInfo) {
                $fieldName = $fieldInfo["name"];
                $fieldExists = \think\DB::query("SHOW COLUMNS FROM " . $tableName1 . " LIKE '" . $fieldName . "'");
                if (empty($fieldExists)) {
                    $sql1 = "\n                            ALTER TABLE " . $tableName1 . "\n                            ADD COLUMN " . $fieldInfo["name"] . " " . $fieldInfo["type"] . " COMMENT '" . $fieldInfo["comment"] . "';\n                        ";
                    \think\DB::execute($sql1);
                }
            }
        }
        $tableName2 = "shd_inventory_synchronization_record";
        $tableExists2 = \think\DB::query("SHOW TABLES LIKE '" . $tableName2 . "'");
        if (empty($tableExists2)) {
            $sql2 = "\n                    CREATE TABLE " . $tableName2 . " (\n                        " . implode(",\n", array_map(function ($fieldInfo) {
                return $fieldInfo["name"] . " " . $fieldInfo["type"] . " COMMENT '" . $fieldInfo["comment"] . "'";
            }, $fieldsToAddTable2)) . "\n                    );\n                ";
            \think\DB::execute($sql2);
        } else {
            foreach ($fieldsToAddTable2 as $fieldInfo) {
                $fieldName = $fieldInfo["name"];
                $fieldExists = \think\DB::query("SHOW COLUMNS FROM " . $tableName2 . " LIKE '" . $fieldName . "'");
                if (empty($fieldExists)) {
                    $sql2 = "\n                            ALTER TABLE " . $tableName2 . "\n                            ADD COLUMN " . $fieldInfo["name"] . " " . $fieldInfo["type"] . " COMMENT '" . $fieldInfo["comment"] . "';\n                        ";
                    \think\DB::execute($sql2);
                }
            }
        }
        return true;
    }
    public function uninstall()
    {
        \think\DB::name("products")->where("upstream_stock_control", 1)->where("stock_control", 1)->update(["stock_control" => 0, "qty" => 0]);
        return true;
    }
    public function afterCron()
    {
        $Info = \think\DB::name("inventory_synchronization_config")->where("id", 1)->find();
        if ($Info["open"] == 1) {
            $products = \think\DB::name("products")->where("upstream_stock_control", 1)->where("api_type", "zjmf_api")->select();
            foreach ($products as $product) {
                if ($product["stock_control"] == 0) {
                    if ($Info["automatic"] == 1 && $product["upstream_qty"] == 0) {
                        $res = \think\DB::name("products")->where("id", $product["id"])->update(["stock_control" => 1, "hidden" => 1, "qty" => $product["upstream_qty"]]);
                        if ($res) {
                            $data = ["product_id" => $product["id"], "product_name" => $product["name"], "local_inventory" => $product["qty"], "upstream_inventory" => $product["upstream_qty"], "method" => "0", "time" => time(), "status" => $product["hidden"]];
                            \think\DB::name("inventory_synchronization_record")->insert($data);
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
                                }
                            } else {
                                if ($Info["automatic"] == 1 && $product["upstream_qty"] !== 0 && $product["qty"] !== $product["upstream_qty"]) {
                                    $res = \think\DB::name("products")->where("id", $product["id"])->update(["hidden" => 0, "qty" => $product["upstream_qty"]]);
                                    if ($res) {
                                        $data = ["product_id" => $product["id"], "product_name" => $product["name"], "local_inventory" => $product["qty"], "upstream_inventory" => $product["upstream_qty"], "method" => "0", "time" => time(), "status" => $product["hidden"]];
                                        \think\DB::name("inventory_synchronization_record")->insert($data);
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
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

?>