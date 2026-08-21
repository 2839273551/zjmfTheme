
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

                        <div class="table-header">
                            <form action="?" method="get">
                            <div class="table-tools">
                                <input type="text" name="uid" class="form-control" placeholder="用户ID" value="{$_GET['uid']}">
                                <input type="text" name="keyword" class="form-control" placeholder="奖品说明" value="{$_GET['keyword']}">
                                <button type="submit" class="btn btn-primary w-xs"><i class="fas fa-search"></i> 搜索</button>
                                <input type="hidden" name="page" class="form-control" value="1">
                                {foreach $_GET as $key=>$vo}
                                    {if condition="($key != 'uid') AND ($key != 'page' ) AND ($key != 'keyword' ) "}
                                        <input type="hidden" name="{$key}" class="form-control" value="{$vo}">
                                        {/if}
                                {/foreach}
                            </div></form>
                            <div class=""></div>
                        </div>
                        <div class="table-body auto-login-content" style="margin-top: 10px;">
                            <table class="table table-bordered table-hover activity-table">
                                <thead class="thead-light">
                                <tr>

                                    <th class="center t1">ID </th>
                                    <th class="t4">活动</th>
                                    <th class="t4">用户</th>


                                    <th>优惠码</th>
                                    <th>奖品来源</th>
                                    <th>状态</th>
                                    <th class="center t5">时间</th>
                                </tr>
                                </thead>
                                <tbody>
                                {foreach $List as $key=>$item}
                                    <tr>
                                        <td class="center">{$item.id}</td>


                                        <td>{$item.title}</td>
                                        <td>{$item.username}({$item.uid})</td>


                                        <td>{$item.code}</td>
                                        <td>{$item.msg}</td>
                                        <td>{empty name="$item.error"}未领取{else /}{$item.error}{/empty}</td>
                                        <td>{$item.add_time} </td>
                                    </tr>
                                {/foreach}
                                </tbody>
                            </table>
                            <div class="table-pagination">

                                <nav>
                                    <ul class="pagination">
                                        {php}
                                            if($Page<=1){
                                                echo '<li class="page-item disabled"><a class="page-link" href="javascript:;">上一页</a></li>';
                                            }else{
                                                echo '<li class="page-item"><a class="page-link" href="addons?'.$PageLink.'&page='.($Page-1).'">上一页</a></li>';
                                            }
                                            for($i=1;$i<=$PageSize;$i++){
                                                if($i==$Page){
                                                    echo '<li class="page-item disabled"><a class="page-link" href="javascript:;">'.$i.'</a></li>';
                                                    }else{
                                                       echo '<li class="page-item"><a class="page-link" href="addons?'.$PageLink.'&page='.$i.'">'.$i.'</a></li>';
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      }
                                            }
                                            if($Page>=$PageSize){
                                              echo '<li class="page-item disabled"><a class="page-link" href="javascript:;">下一页</a></li>';
                                            }else{
                                               echo '<li class="page-item"><a class="page-link" href="addons?'.$PageLink.'&page='.($Page+1).'">下一页</a></li>';
                                            }
                                        {/php}

                                        </ul>
                                </nav>
                            </div>

                        </div>


                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
