<?php
namespace addons\delete_products\controller;

class AdminIndexController extends \app\admin\controller\PluginAdminBaseController
{
    private $_config = [];
    private $lang;
    public function initialize()
    {
        parent::initialize();
        if (file_exists(dirname(__DIR__) . "/config/config.php")) {
            $con = (require dirname(__DIR__) . "/config/config.php");
        } else {
            $con = [];
        }
        $this->_config = array_merge($con, $this->getPlugin()->getConfig());
        $lang = request()->languagesys;
        if (empty($lang)) {
            $lang = configuration("language") ? configuration("language") : config("default_lang");
        }
        if ($lang == "CN") {
            $lang = "chinese";
        } else {
            if ($lang == "US") {
                $lang = "english";
            } else {
                if ($lang == "HK") {
                    $lang = "chinese_tw";
                }
            }
        }
        $this->lang = $lang;
    }
    public function index()
    {
        $page = input("page", 1);
        $pageSize = 10;
        $activities = \think\Db::name("products")->order("id", "desc")->paginate($pageSize, false, ["page" => $page]);
        $this->assign("Title", "商品删除管理");
        return $this->fetch("/index", ["List" => $activities]);
    }
    public function deletelists()
    {
        if (request()->isPost()) {
            $id = input("post.id");
            $order_ids = \think\Db::name("host")->where("productid", $id)->column("orderid");
            $host_ids = \think\Db::name("host")->where("productid", $id)->column("id");
            $upgrades_ids = \think\Db::name("upgrades")->where("relid", "IN", $host_ids)->column("order_id");
            foreach ($upgrades_ids as $order_id) {
                $result = \think\Db::name("orders")->where("id", $order_id)->delete();
            }
            foreach ($host_ids as $upgrades_id) {
                $result = \think\Db::name("upgrades")->where("relid", $upgrades_id)->delete();
            }
            foreach ($order_ids as $order_id) {
                $result = \think\Db::name("orders")->where("id", $order_id)->delete();
            }
            $result = \think\Db::name("products")->where("id", $id)->delete();
            $result = \think\Db::name("host")->where("productid", $id)->delete();
            if ($result !== false) {
                return json(["code" => 200, "msg" => "活动删除成功"]);
            }
            return json(["code" => 500, "msg" => "活动删除失败"]);
        }
    }
}

?>