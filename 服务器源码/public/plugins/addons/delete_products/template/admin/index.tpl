<script src="/plugins/addons/delete_products/assets/layer.js"></script>
  <style>
  
/* 通用的优惠类型样式 */
.discount-type {
    text-align: center;
    padding: 6px 10px;
    border-radius: 5px;
    font-weight: bold;
    font-size: 14px;
    color: white;
}

/* 折扣类型样式 */
.discount-type.percent {
    background-color: #999; /* 灰色背景 */
}

/* 立减类型样式 */
.discount-type.fixed {
    background-color: #4CAF50; /* 绿色背景 */
}

/* 未知类型样式 */
.discount-type.unknown {
    background-color: #FF5733; /* 蓝色背景 */
}

/* 通用的结算周期样式开始 */
/* 通用的结算周期样式 */
.settlement-cycle {
    text-align: center;
    padding: 6px 10px;
    border-radius: 5px;
    font-weight: bold;
    font-size: 14px;
    color: white;
}

/* 日付样式 */
.settlement-cycle.day {
    background-color: #FF5733; /* 红色背景 */
}

/* 月付样式 */
.settlement-cycle.monthly {
    background-color: #3498DB; /* 蓝色背景 */
}

/* 季付样式 */
.settlement-cycle.quarterly {
    background-color: #27AE60; /* 绿色背景 */
}

/* 半年付样式 */
.settlement-cycle.semiannually {
    background-color: #F39C12; /* 橙色背景 */
}

/* 年付样式 */
.settlement-cycle.annually {
    background-color: #8E44AD; /* 紫色背景 */
}

/* 不限样式 */
.settlement-cycle {
    background-color: #788eb5; /* 灰色背景 */
}

/* 通用的结算周期样式结束 */

/* 通用的数量单元格样式 */
.quantity-cell {
    text-align: center;
    padding: 6px 10px;
    border-radius: 5px;
    font-weight: bold;
    font-size: 14px;
    color: white;
}

/* 自定义数量值的样式 */
.quantity-cell.high {
    background-color: #FF5733; /* 红色背景 */
}

.quantity-cell.medium {
    background-color: #3498DB; /* 蓝色背景 */
}

.quantity-cell.low {
    background-color: #d48b1e; /* 绿色背景 */
}

/* 可以根据需要继续添加其他样式 */


//时间样式开始
    .center {
        text-align: center;
    }

    .received-time-cell {
        padding: 10px;
        border: 1px solid #ccc;
        font-size: 14px;
        color: #333;
        border-radius: 6px;
        display: inline-block;
        transition: opacity 0.3s;
        cursor: pointer;
    }

    .received-time-cell:hover {
        opacity: 0.7;
    }

    .received-time-cell .detailed-time {
        display: none;
        font-size: 12px;
        color: #999;
        margin-top: 5px;
    }

    .received-time-cell:hover .detailed-time {
        display: block;
    }
//时间样式结束

//商品列表样式
    .center {
        text-align: center;
    }

    .product-names-cell {
        max-width: 500px;
        padding: 10px;
        border: 1px solid #ccc;
        font-size: 14px;
        color: #333;
        border-radius: 6px;
        display: inline-block;
        word-wrap: break-word;
    }
//商品列表样式结束



.pagination {
    text-align: right; /* Align the pagination to the right */
    margin-top: 20px;
}

.pagination-link {
    margin: 0 5px;
    text-decoration: none;
    color: #333;
    border: 1px solid #ccc;
    padding: 5px 10px;
    border-radius: 5px;
}

.jump-input {
    width: 40px;
    padding: 2px;
    text-align: center;
}

.jump-button {
    padding: 2px 8px;
    background-color: #007bff;
    border: none;
    color: #fff;
    border-radius: 5px;
    cursor: pointer;
}

.jump-button:hover {
    background-color: #0056b3;
}


    </style>
<section class="admin-main">
  <div class="container-fluid">
    <div class="page-container">
      <div class="card">
        <div class="card-body">
          <div class="card-title row">
            <div style="padding:0 15px;">{$Title}</div>
            <div class="col-lg-8 col-md-12 col-sm-12">
              {foreach $PluginsAdminMenu as $v}
                {if $v['custom']}
                  <span class="ml-2"><a class="h5" href="{$v.url}" target="_blank">{$v.name}</a></span>
                {else/}
                  <span class="ml-2"><a class="h5" href="{$v.url}">{$v.name}</a></span>
                {/if}
              {/foreach}
            </div>
          </div>
          使用说明：<br>
          1、数据无价，删除前请提前备份一次再操作，<br>2、本插件适用于魔方财务删除商品与删除订单管理，（适用下架后产品不再使用并清理订单）<br>3、不管是本地的还是对接的，已经生产有订单的或没有订单的，（解决了魔方已生产订单无法删除商品的问题）<br>3、删除商品会一并将商品下的本地订单全部删除并不可恢复。（只处理删除本地订单，接口方请自行删除）
          <div class="tab-content mt-4">
            <div class="table-body table-responsive">
              <table class="table table-bordered table-hover">
                <thead class="thead-light">
                  <tr>
                    <th class="center">ID</th>
                    <th class="center">产品类型</th>
                    <th class="center">产品组</th>
                    <th class="center">产品名称</th>
                    <th class="center">操作</th>
                  </tr>
                </thead>
                <tbody>

                  {volist name='List' id='v'}
                    <tr>
                      <td class="center t1">{$v.id}</td>
                                  <td class="center">
            {if $v.type == 'hostingaccount'}
            <span class="settlement-cycle day">虚拟主机</span>
            {elseif $v.type == 'server'}
            <span class="settlement-cycle monthly">独立服务器</span>
            {elseif $v.type == 'cloud'}
            <span class="settlement-cycle quarterly">云服务器</span>
            {elseif $v.type == 'dcim'}
            <span class="settlement-cycle semiannually">魔方DCIM</span>
            {elseif $v.type == 'cdn'}
            <span class="settlement-cycle annually">CDN</span>
            {elseif $v.type == 'cdn'}
            <span class="settlement-cycle annually">CDN</span>
            {elseif $v.type == 'other'}
            <span class="settlement-cycle annually">其他产品</span>
            {else}
            <span class="settlement-cycle unlimited">未知产品类型</span>
            {/if}
            </td>
                      <td class="quantity-cell medium">{$v.gid} </td>
                      <td class="quantity-cell medium">{$v.name} </td>
                      

            


                      <td>
                        <button type="button" class="btn btn-link red" onclick="del('{$v.id}')"><i class="fas fa-times-circle"></i> 删除</button>
                      </td>
                      


                    </tr>
                  {/volist}
                </tbody>
              </table>
              


            </div>
<div class="pagination">
<!-- 获取当前页码 -->
当前页码：{$currentPage = $List->currentPage()}

<!-- 获取总页数 -->
总页码：{$totalPages = $List->lastPage()}

<!-- 上一页链接 -->
{if $currentPage > 1}
    <a href="{:shd_addon_url('DeleteProducts://AdminIndex/index')}&page={$currentPage - 1}" class="pagination-link">上一页</a>
{/if}

<!-- 下一页链接 -->
{if $currentPage < $totalPages}
    <a href="{:shd_addon_url('DeleteProducts://AdminIndex/index')}&page={$currentPage + 1}" class="pagination-link">下一页</a>
{/if}
<!-- 输入框和跳转按钮 -->
<div>
    跳转到第
    <input type="number" id="jumpToPage" min="1" max="{$totalPages}" value="{$currentPage + 1}" style="width: 40px;"> <!-- 输入页码的文本框 -->
    页
    <button onclick="jumpToPage()" class="jump-button">跳转</button> <!-- 跳转按钮 -->
</div>
</div>
          </div>
        </div>
      </div>
    </div>
  </div>
  </div>
</section>




<script>
    function jumpToPage() {
        var jumpInput = document.getElementById('jumpToPage');
        var targetPage = parseInt(jumpInput.value); // 获取输入的目标页码
        if (targetPage >= 1 && targetPage <= <?php echo $totalPages; ?>) {
            // 构建目标页的链接并跳转
            var targetUrl = "{:shd_addon_url('DeleteProducts://AdminIndex/index')}&page=" + targetPage;
            window.location.href = targetUrl;
        }
    }
</script>

<!--
<script>
function del(id) {
    var load = layer.load();
    $.ajax({
        url: "{:shd_addon_url('DeleteProducts://AdminIndex/deletelists')}",
        type: 'post',
        data: { id: id },
        dataType: 'json',
        success: function(data) {
            layer.close(load);
            if (data.code != 200) {
                layer.alert(data.msg, { icon: 2 });
            } else {
                layer.alert(data.msg, { icon: 1 }, function() {
                    location.reload();
                });
            }
        },
        error: function() {
            layer.close(load);
            layer.msg('请求失败');
        }
    });
}
        
        
</script>
-->

<script>








function del(id) {
    if (confirm("删除有风险，提醒您注意备份数据，确定删除？")) {
        var load = layer.load();
        $.ajax({
            url: "{:shd_addon_url('DeleteProducts://AdminIndex/deletelists')}",
            type: 'post',
            data: { id: id },
            dataType: 'json',
            success: function(data) {
                layer.close(load);
                if (data.code != 200) {
                    layer.alert(data.msg, { icon: 2 });
                } else {
                    layer.alert(data.msg, { icon: 1 }, function() {
                        location.reload();
                    });
                }
            },
            error: function() {
                layer.close(load);
                layer.msg('请求失败');
            }
        });
    }
}
</script>
