
<link rel="stylesheet" type="text/css" href="https://www.layuicdn.com/layui-v2.8.16/css/layui.css" />
<style>
    .layui-form-item{
        display: flex;
        align-items: stretch;
    }
    .layui-form-label{
        flex: 0 0 auto;
    }
    .layui-input-block{
        flex: 1 1 auto;
        margin-left: 0!important;
    }
</style>
<section class="admin-main">
    <div class="container-fluid">
        <div class="page-container">
            <div class="card">
                <div class="card-body">
                    <!-- class="col-lg-1 col-md-12 col-sm-12" -->
                    <div class="card-title row">
                        <div class="pl-4 pr-4">{$Title}</div>
                        <div class="col-lg-8 col-md-12 col-sm-12">
                            {foreach $PluginsAdminMenu as $v}
                                {if $v['custom']}
                                    <span  class="ml-2"><a  class="h5" href="{$v.url}" target="_blank">{$v.name}</a></span>
                                {else/}
                                    <span  class="ml-2"> <a  class="h5" href="{$v.url}">{$v.name}</a></span>
                                {/if}
                            {/foreach}
                        </div>
                    </div>

                    <div class="tab-content mt-4">


                            </form>
                        </div>
                        <div class="table-body">1、本插件适用于魔方财务管理对接上游商品删除后自动下架本站商品，<br>2、使用本插件的功能，需要保持定时任务的正常运行，<br>3、自动检测上游商品删除后，下架(隐藏)本站商品。</a> </div>
                        <div class="table-body" id="renewMsg" style="color: #ff0000;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

