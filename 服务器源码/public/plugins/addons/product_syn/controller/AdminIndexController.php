<?php
namespace addons\product_syn\controller;

class AdminIndexController extends \app\admin\controller\PluginAdminBaseController
{
    public $data;
    public $PluginName = "ProductSyn";
    public function initialize()
    {
        parent::initialize();
        $this->assign("GzhxPluginPath", $this->uncamelize($this->PluginName));
        $this->data = $_POST;
    }
    public function uncamelize($camelCaps, $separator = "_")
    {
        return strtolower(preg_replace("/([a-z])([A-Z])/", "\$1" . $separator . "\$2", $camelCaps));
    }
    public function success($arr)
    {
        echo json_encode(["status" => 1, "encrypt" => 1, "info" => $arr]);
        exit;
    }
    public function error($arr)
    {
        echo json_encode(["status" => 0, "info" => $arr]);
        exit;
    }
    public function index()
    {
        if (!empty($this->data)) {
            switch ($this->data["action"]) {
                case "save":
                    $pay = [];
                    foreach ($this->data["pay"] as $k => $v) {
                        if ($v && !in_array($v, $pay)) {
                            $pay[] = $v;
                        }
                    }
                    $consumption = [];
                    foreach ($this->data["consumption"] as $k => $v) {
                        if ($v && !in_array($v, $consumption)) {
                            $consumption[] = $v;
                        }
                    }
                    ksort($consumption);
                    ksort($pay);
                    $save = ["title" => $this->data["title"], "start_time" => strtotime($this->data["start_time"]), "end_time" => strtotime($this->data["end_time"]), "pay" => $pay, "consumption" => $consumption, "onepay" => $this->data["onepay"], "add" => $this->data["prize_add"], "info" => $this->data["info"]];
                    \Think\Db::name("gzhx_activity")->insert(["plugin" => $this->PluginName, "setting" => serialize($save)], true);
                    $this->success("提交成功");
                    exit;
                    break;
                case "delete":
                    if ($this->data["type"] == "product") {
                        \Think\Db::name("gzhx_activity_group")->where("id", "=", $this->data["data"]["id"])->delete();
                    } else {
                        \Think\Db::name("gzhx_activity_prize_setting")->where("id", "=", $this->data["data"]["id"])->delete();
                    }
                    $this->success("删除完成");
                    exit;
                    break;
                case "prizesetting":
                    if (empty($this->data["data"]["winning"]) && $this->data["data"]["winning"] != 0) {
                        $this->error("请输入充值金额");
                        exit;
                    }
                    $this->data["data"]["type"] = $activity["setting"]["activity_prize"];
                    $this->data["data"]["name"] = "-";
                    $this->data["data"]["plugin"] = $this->PluginName . "_" . $_GET["id"];
                    if (empty($this->data["data"]["id"])) {
                        unset($this->data["data"]["id"]);
                        $this->data["data"]["id"] = \Think\Db::name("gzhx_activity_prize_setting")->insertGetId($this->data["data"]);
                        $this->success($this->data["data"]);
                        exit;
                    }
                    \Think\Db::name("gzhx_activity_prize_setting")->update($this->data["data"]);
                    $this->success($this->data["data"]);
                    exit;
                    break;
                default:
                    $this->error($this->data["action"] . "参数不存在");
                    exit;
            }
        } else {
            $List = \Think\Db::name("zjmf_finance_api")->where("hostname", "like", "http%")->select()->toArray();
            $this->assign("Title", "上游列表");
            $this->assign("List", $List);
            return $this->fetch("/index");
        }
    }
    public function curl($url, $method = "get", $params = [], $timeout = 30, $headers = [], $is_json = false)
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, strtoupper($method));
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch, CURLINFO_HEADER_OUT, 1);
        if (!empty($headers)) {
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        }
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        if (strtoupper($method) !== "GET") {
            if ($is_json) {
                curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($params));
            } else {
                curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($params));
            }
        }
        $data = curl_exec($ch);
        if ($data) {
            curl_close($ch);
            return $data;
        }
        $error = curl_errno($ch);
        curl_close($ch);
        exit($error);
    }
    public function set()
    {
        if (!empty($this->data)) {
            $action = $this->data["action"];
            if (empty($action)) {
                $action = "";
            }
            switch ($action) {
                case "save":
                    $product_first_groups = \Think\Db::name("product_first_groups")->where("id", "=", 1)->find();
                    if (empty($product_first_groups)) {
                        \Think\Db::name("product_first_groups")->insert(["id" => 1, "name" => "默认分组", "hidden" => 0]);
                    }
                    $gid = \Think\Db::name("product_groups")->insertGetId(["name" => $this->data["name"], "headline" => $this->data["name"], "tagline" => $this->data["name"], "gid" => 1]);
                    $this->success($gid);
                    break;
                case "check":
                    $data = $this->data["data"];
                    $productData = [];
                    foreach ($data["data"] as $v) {
                        foreach ($v["products"] as $vv) {
                            $productData[] = $vv["id"];
                        }
                    }
                    if (empty($productData)) {
                        $productData = [0];
                    }
                    $Proucts = \Think\Db::name("products")->field("name,upstream_pid")->where("zjmf_api_id", "=", $_GET["id"])->where("upstream_pid", "IN", $productData)->select()->toArray();
                    $Proucts = array_column($Proucts, NULL, "upstream_pid");
                    $this->success(["server" => $data, "client" => empty($Proucts) ? ["null"] : $Proucts]);
                    break;
                case "get":
                    $url = parse_url($this->data["uri"]);
                    $uri = $url["scheme"] . "://" . $url["host"] . str_ireplace("/addons", "/get_upstream_products", $url["path"]) . "?" . http_build_query(["id" => $_GET["id"], "request_time" => time(), "languagesys" => "CN"]);
                    $Cookie = [];
                    foreach ($_COOKIE as $k => $v) {
                        $Cookie[] = $k . "=" . $v;
                    }
                    $header = ["User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36 Edg/92.0.902.73", "Cookie: " . implode("; ", $Cookie)];
                    $data = $this->curl($uri, "get", NULL, 30, $header);
                    $data = json_decode($data, true);
                    $productData = [];
                    foreach ($data["data"] as $v) {
                        foreach ($v["products"] as $vv) {
                            $productData[] = $vv["id"];
                        }
                    }
                    if (empty($productData)) {
                        $productData = [0];
                    }
                    $Proucts = \Think\Db::name("products")->field("name,upstream_pid")->where("zjmf_api_id", "=", $_GET["id"])->where("upstream_pid", "IN", $productData)->select()->toArray();
                    $Proucts = array_column($Proucts, NULL, "upstream_pid");
                    $this->success(["server" => $data, "client" => empty($Proucts) ? ["null"] : $Proucts, "addpage" => json_decode($this->curl($url["scheme"] . "://" . $url["host"] . str_ireplace("/addons", "/zjmf_finance_api/addpage", $url["path"]) . "?" . http_build_query(["request_time" => time()]), "get", NULL, 30, $header), true)]);
                    break;
                default:
                    $this->error("参数不存在");
            }
        }
        $this->assign("Title", "产品同步");
        return $this->fetch("/set");
    }
    public function winningrecord()
    {
        $page = !intval($_GET["page"]) ? 1 : intval($_GET["page"]);
        if ($page < 1) {
            $page = 1;
        }
        $limit = 10;
        $M = \Think\Db::name("gzhx_activity_user")->alias("a")->leftJoin("clients d", "d.id=a.uid")->leftJoin("gzhx_activity_prize_setting c", "a.aid=c.id")->leftJoin("gzhx_activity b", "CONCAT('" . $this->PluginName . "_',b.id)=c.plugin")->where("a.plugin", "=", $this->PluginName);
        if (!empty($_GET["uid"])) {
            $M = $M->where("a.uid", "=", $_GET["uid"]);
        }
        if (!empty($_GET["activity_id"])) {
            $M = $M->where("b.id", "=", $_GET["activity_id"]);
        }
        if (!empty($_GET["keyword"])) {
            $M = $M->where("a.msg", "LIKE", "%" . $_GET["keyword"] . "%");
        }
        $listM = $M;
        $count = $M->count();
        $list = $listM->field("a.*,b.title,d.username,d.id as c_id")->page($page . "," . $limit)->order("a.id desc")->select()->toArray();
        $this->assign("Title", "中奖记录");
        $this->assign("List", $list);
        $this->assign("Page", $page);
        $this->assign("PageSize", ceil($count / $limit));
        $page_data = $_GET;
        unset($page_data["page"]);
        $this->assign("PageLink", http_build_query($page_data));
        return $this->fetch("/record");
    }
}

?>