<?php
namespace addons\product_removal\controller;

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
        if ($this->lang == "chinese") {
            $title = "使用说明";
        } else {
            if ($this->lang == "english") {
                $title = "Instructions";
            } else {
                if ($this->lang == "chinese_tw") {
                    $title = "使用说明";
                }
            }
        }
        $this->assign("Title", $title);
        return $this->fetch("/index");
    }
}

?>