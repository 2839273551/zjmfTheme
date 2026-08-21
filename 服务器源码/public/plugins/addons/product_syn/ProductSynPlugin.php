<?php
namespace addons\product_syn;

class ProductSynPlugin extends \app\admin\lib\Plugin
{
    public $info = ["name" => "ProductSyn", "title" => "一键同步上游产品", "description" => "一键同步上游产品", "status" => 1, "author" => "GZHX Technology", "version" => "1.0.3", "module" => "addons", "update_description" => "一键同步上游产品", "not_install" => true];
    public function install()
    {
        return true;
    }
    public function uninstall()
    {
        return true;
    }
}

?>