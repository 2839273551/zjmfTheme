<?php
namespace addons\product_removal;

class ProductRemovalPlugin extends \app\admin\lib\Plugin
{
    public $info = ["name" => "ProductRemoval", "title" => "产品自动隐藏", "description" => "本插件用于检测上游商品删除，本站自动隐藏上游已删除的商品", "status" => 1, "author" => "<a href=\"http://www.yunbuyun.com\">云步云计算</a>", "version" => "1.0.0", "module" => "addons"];
    public function install()
    {
        return true;
    }
    public function uninstall()
    {
        return true;
    }
    public function afterCron()
    {
        $keyword = "已删除该商品,请及时处理";
        $records = \Think\Db::name("activity_log")->order("id", "desc")->limit(20)->select();
        if (!empty($records)) {
            foreach ($records as $record) {
                $text = $record["description"];
                if (strpos($text, $keyword) !== false && preg_match("/PRODUCT ID:(\\d+)/", $text, $matches)) {
                    $productId = $matches[1];
                    $hiddenValue = \Think\Db::name("products")->where("id", $productId)->value("hidden");
                    if ($hiddenValue == 0) {
                        $zjmf_api_id = \Think\Db::name("products")->where("id", $productId)->value("zjmf_api_id");
                        $name = \Think\Db::name("zjmf_finance_api")->where("id", $zjmf_api_id)->value("name");
                        $existingName = \Think\Db::name("products")->where("id", $productId)->value("name");
                        $current_time = date("Y-m-d H:i:s");
                        $newName = "【系统下架" . $current_time . "，上游接口:" . $name . "】" . $existingName;
                        \Think\Db::name("products")->where("id", $productId)->update(["name" => $newName, "hidden" => 1, "zjmf_api_id" => 0]);
                    }
                }
            }
        }
    }
}

?>