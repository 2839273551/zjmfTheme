<?php
namespace addons\delete_products;

class DeleteProductsPlugin extends \app\admin\lib\Plugin
{
    public $info = ["name" => "DeleteProducts", "title" => "删除商品与订单", "description" => "删除商品后将删除与商品关联的订单", "status" => 1, "author" => "<a href=\"http://www.yunbuyun.com\">云步云计算</a>", "version" => "1.0.0", "module" => "addons"];
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