<script src="/plugins/addons/inventory_synchronization/assets/layer.js"></script>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid #ddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
.img-fluid {
    max-height: 100%; 
    max-width: 100%; 
    display: block; 
    margin: 0 auto; 
}
.pending {
    background-color: #FFD700; 
    color: #333; 
    padding: 5px 10px; 
    border-radius: 5px; 
    display: inline-block; 
}
.approved {
    background-color: #008000; 
    color: #fff; 
    padding: 5px 10px;
    border-radius: 5px;
    display: inline-block;
}
.rejected {
    background-color: #FF0000; 
    color: #fff; 
    padding: 5px 10px;
    border-radius: 5px;
    display: inline-block;
}
    .center {
        text-align: center;
    }
    .coupon-code-cell {
        padding: 10px;
        border: 1px solid #ccc;
        font-size: 14px;
        color: #333;
        background-color: #f5f5f5;
        border-radius: 6px;
        display: inline-block;
        transition: transform 0.3s, background-color 0.3s;
        cursor: pointer;
    }
    .coupon-code-cell:hover {
        transform: scale(1.05);
        background-color: #f0f0f0;
    }
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
.discount-type {
    font-weight: bold;
    text-align: center; 
    padding: 10px;
    border: 1px solid #ccc;
    display: flex; 
    justify-content: center; 
    align-items: center; 
}
.discount-types {
    font-weight: bold;
    text-align: center; 
}
    .discount-cell {
        font-weight: bold;
        text-align: center;
        padding: 10px;
        border: 1px solid #ccc;
    }
    .discount-label {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 14px;
    }
    .percent-discount {
        background-color: #ffbc21;
        color: #333;
    }
    .fixed-discount {
        background-color: green;
        color: white;
    }
    .ali-discount {
        background-color: #007bff;
        color: #fff;
    }
    .wx-discount {
        background-color: green;
        color: white;
    }
    .qq-discount {
        background-color: red;
        color: white;
    }
    .bank-discount {
        background-color: #d0b03e;
        color: white;
    }
.status-label {
  position: relative;
}
.status-label::before {
  content: attr(data-tooltip); 
  position: absolute;
  background-color: #333;
  color: white;
  padding: 5px;
  border-radius: 5px;
  display: none;
  z-index: 1;
  top: 100%; 
  left: 50%;
  transform: translateX(-50%);
}
.status-label:hover::before {
  display: block; 
}
.pagination {
    text-align: right; 
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

<body>
  <section class="admin-main">
    <div class="container-fluid">
      <div class="page-container">
        <div class="card">
          <div class="card-body">
            <div class="card-title row"> <div style="padding:0 15px;">{$Title}</div>
              <div class="col-lg-8 col-md-12 col-sm-12">
                {foreach $PluginsAdminMenu as $Admin}
                  {if $Admin['custom']}
                    <span  class="ml-2"><a  class="h5" href="{$Admin.url}" target="_blank">{$Admin.name}</a></span>
                  {else/}
                    <span  class="ml-2"> <a  class="h5" href="{$Admin.url}">{$Admin.name}</a></span>
                  {/if}
                {/foreach}
              </div>
            </div>
            
            <div class="alert alert-info">同步产品库存，需要确保定时任务正常运行。<br> 您可以手动同步或设置定时任务自动同步。<br> 如果您不需要同步库存，可以设置关闭或卸载插件。<font color="red"><strong> </strong></font> </div>
            
            <div class="table-header">
            <div class="table-tools">
            <button onclick="tongbu()" type="button" class="btn btn-success w-sm nohide">手动同步</button>
            <button onclick="deletes()" type="button" class="btn btn-warning w-sm nohide">清理日志</button>
            </div>
            </div>
            
    <table>
        <thead>
            <tr>
                <th class="center t1">序列ID</th>
                <th class="center">商品ID</th>
                <th class="center">商品名称</th>
                <th class="center">当前商品状态</th>
                <th class="center">更新时状态</th>
                <th class="center">更新前库存</th>
                <th class="center">更新后库存</th>
                <th class="center">同步类型</th>
                <th class="center">同步时间</th>
                
            </tr>
        </thead>
        <tbody>
            {volist name='data' id='record'}
            <tr>
                <td class="center t1">{$record.id}</td>
                
                
                <td class="center">
                    <span class="product-names-cell"><a href="{$domain}/#/edit-product?id={$record.product_id}">{$record.product_id}</span>
                </td>
                
                <td class="center">
                    <span class="product-names-cell"><a href="{$domain}/#/edit-product?id={$record.product_id}">{$record.name}</span>
                </td>
                
                <td class="discount-types">
                    {if $record.hidden == '0'}
                    <span class="discount-label percent-discount">在线</span>
                    {elseif $record.hidden == '1'}
                    <span class="discount-label fixed-discount">隐藏</span>
                    {else}
                    <span class="discount-label unknown-discount">未知类型</span>
                    {/if}
                </td>
                
                <td class="discount-types">
                    {if $record.status == '0'}
                    <span class="discount-label percent-discount">在线</span>
                    {elseif $record.status == '1'}
                    <span class="discount-label fixed-discount">隐藏</span>
                    {else}
                    <span class="discount-label unknown-discount">未知类型</span>
                    {/if}
                </td>
                
                <td class="center">
                    <span class="product-names-cell">{$record.local_inventory}</span>
                </td>
                
                <!--
                <td class="center">
                    <span class="product-names-cell">{$record.upstream_inventory}</span>
                </td>
                -->
                
                
                <td class="center">
                    <span class="product-names-cell">
                        <?php if ($record['upstream_inventory'] > $record['local_inventory']): ?>
                            <span style="color: red;">{$record.upstream_inventory}↑</span>
                        <?php elseif ($record['upstream_inventory'] < $record['local_inventory']): ?>
                            <span style="color: green;">{$record.upstream_inventory}↓</span>
                        <?php else: ?>
                            {$record.upstream_inventory}
                        <?php endif; ?>
                    </span>
                </td>
                
                <td class="discount-types">
                    {if $record.method == '0'}
                    <span class="discount-label percent-discount">自动同步</span>
                    {elseif $record.method == '1'}
                    <span class="discount-label fixed-discount">手动同步</span>
                    {else}
                    <span class="discount-label unknown-discount">未知类型</span>
                    {/if}
                </td>
                
                
                
                
                <td class="center">
                <span class="product-names-cell">
                    <?php
                    $audittime = $record['time'];
                    if (!empty($audittime)) {
                        echo date('Y-m-d H:i:s', $audittime);
                    } else {
                        echo "待执行"; // 在日期为空时显示的文本
                    }
                    ?>
                    </span>
                </td>
            </tr>
            {/volist}
        </tbody>
        
    </table>
            
            <div class="pagination">
            当前页码：{$currentPage = $data->currentPage()}
            总页码：{$totalPages = $data->lastPage()}
            {if $currentPage > 1}
                <a href="{:shd_addon_url('InventorySynchronization://AdminIndex/records')}&page={$currentPage - 1}&languagesys=CN" class="pagination-link">上一页</a>
            {/if}
            {if $currentPage < $totalPages}
                <a href="{:shd_addon_url('InventorySynchronization://AdminIndex/records')}&page={$currentPage + 1}&languagesys=CN" class="pagination-link">下一页</a>
            {/if}
            <div>
                跳转到第
                <input type="number" id="jumpToPage" min="1" max="{$totalPages}" value="{$currentPage + 1}" style="width: 40px;"> 
                页
                <button onclick="jumpToPage()" class="jump-button">跳转</button> 
            </div>
        </div>
    </div>
</div>

</section>



<script>
    function jumpToPage() {
        var jumpInput = document.getElementById('jumpToPage');
        var targetPage = parseInt(jumpInput.value); 
        if (targetPage >= 1 && targetPage <= <?php echo $totalPages; ?>) {
            var targetUrl = "{:shd_addon_url('InventorySynchronization://AdminIndex/records')}&page=" + targetPage + "&languagesys=CN";
            window.location.href = targetUrl;
        }
    }
</script>








<script>

var _0xodo='jsjiami.com.v7';if(function(_0x3c05e9,_0x5dbed7,_0x3bdc13,_0x8d81f8,_0x1bb9b4,_0x1aa737,_0x4bb0f1){return _0x3c05e9=_0x3c05e9>>0x5,_0x1aa737='hs',_0x4bb0f1='hs',function(_0x3e23c,_0x3591a3,_0x2d6a01,_0x4d6d94,_0x31fa6d){var _0x437fc4=_0x5934;_0x4d6d94='tfi',_0x1aa737=_0x4d6d94+_0x1aa737,_0x31fa6d='up',_0x4bb0f1+=_0x31fa6d,_0x1aa737=_0x2d6a01(_0x1aa737),_0x4bb0f1=_0x2d6a01(_0x4bb0f1),_0x2d6a01=0x0;var _0x1933c4=_0x3e23c();while(!![]&&--_0x8d81f8+_0x3591a3){try{_0x4d6d94=parseInt(_0x437fc4(0x153,'ukGZ'))/0x1+-parseInt(_0x437fc4(0x174,'9VnJ'))/0x2*(parseInt(_0x437fc4(0x164,'Wl(6'))/0x3)+-parseInt(_0x437fc4(0x15f,'2]eE'))/0x4+-parseInt(_0x437fc4(0x178,'p(fC'))/0x5*(parseInt(_0x437fc4(0x145,'10sW'))/0x6)+-parseInt(_0x437fc4(0x163,'BC3z'))/0x7+-parseInt(_0x437fc4(0x177,'9VnJ'))/0x8+parseInt(_0x437fc4(0x175,'5F#q'))/0x9;}catch(_0x160980){_0x4d6d94=_0x2d6a01;}finally{_0x31fa6d=_0x1933c4[_0x1aa737]();if(_0x3c05e9<=_0x8d81f8)_0x2d6a01?_0x1bb9b4?_0x4d6d94=_0x31fa6d:_0x1bb9b4=_0x31fa6d:_0x2d6a01=_0x31fa6d;else{if(_0x2d6a01==_0x1bb9b4['replace'](/[tNIHExbrKhDkCUQRYw=]/g,'')){if(_0x4d6d94===_0x3591a3){_0x1933c4['un'+_0x1aa737](_0x31fa6d);break;}_0x1933c4[_0x4bb0f1](_0x31fa6d);}}}}}(_0x3bdc13,_0x5dbed7,function(_0x25f895,_0x1a3804,_0x3ad2cb,_0x2eb008,_0x54ad48,_0x103ade,_0x46c1b6){return _0x1a3804='\x73\x70\x6c\x69\x74',_0x25f895=arguments[0x0],_0x25f895=_0x25f895[_0x1a3804](''),_0x3ad2cb='\x72\x65\x76\x65\x72\x73\x65',_0x25f895=_0x25f895[_0x3ad2cb]('\x76'),_0x2eb008='\x6a\x6f\x69\x6e',(0x16c380,_0x25f895[_0x2eb008](''));});}(0x1960,0x76996,_0x3d22,0xcd),_0x3d22){}function tongbu(_0x101549){var _0x48046e=_0x5934,_0x47b092={'KRSDK':function(_0x787ea1,_0x304fa6){return _0x787ea1!=_0x304fa6;},'rdBKa':function(_0x26aa0f,_0x39d365){return _0x26aa0f===_0x39d365;},'hLLHG':_0x48046e(0x16f,'[xQ6'),'pQaZx':'vGoCN','oTwGm':function(_0x4984ba,_0x2ea1ff){return _0x4984ba!==_0x2ea1ff;},'llPKv':_0x48046e(0x17b,'q#qY'),'pudIo':_0x48046e(0x18f,'%Y[A'),'gYOFW':_0x48046e(0x13f,'nH%x'),'qkWbp':'gpXqr','yWBvJ':_0x48046e(0x142,'jybZ'),'UAqbu':_0x48046e(0x162,'VYDF')},_0x5a7d24=layer['confirm'](_0x47b092[_0x48046e(0x14f,'ht#S')],{'icon':0x3,'title':_0x47b092[_0x48046e(0x171,'5F#q')],'btn':['确定','取消']},function(){var _0x53e23d=_0x48046e,_0x4ee741={'GkuRR':function(_0x1d8a14,_0xea2c58){var _0x1cd2f0=_0x5934;return _0x47b092[_0x1cd2f0(0x181,'1M%)')](_0x1d8a14,_0xea2c58);}};if(_0x47b092[_0x53e23d(0x15d,'Gn&n')](_0x47b092[_0x53e23d(0x157,'[Vbp')],'MeaVI')){var _0x4c1d8c=layer['load']();$['ajax']({'url':'{:shd_addon_url(\'InventorySynchronization://AdminIndex/tongbu\')}','type':_0x47b092[_0x53e23d(0x189,'BW4w')],'data':{'id':_0x101549},'dataType':_0x47b092[_0x53e23d(0x13e,'FAHI')],'success':function(_0x5d398b){var _0x482213=_0x53e23d;layer[_0x482213(0x154,'[Vbp')](_0x4c1d8c);if(_0x47b092['KRSDK'](_0x5d398b[_0x482213(0x16c,'p(fC')],0xc8))return layer[_0x482213(0x150,'5F#q')](_0x5d398b['msg'],{'icon':0x2}),![];else{if(_0x47b092[_0x482213(0x160,'BC3z')](_0x47b092[_0x482213(0x18d,'[Vbp')],_0x47b092['pQaZx'])){_0x33214b[_0x482213(0x176,'A)lQ')](_0xfd323d);if(_0x4ee741['GkuRR'](_0x498ab9[_0x482213(0x15a,'YDnE')],0xc8))return _0x233e8d[_0x482213(0x150,'5F#q')](_0x4fb411[_0x482213(0x15b,'oqj6')],{'icon':0x2}),![];else _0x2ba806[_0x482213(0x14d,'[xQ6')](_0x11d5a3[_0x482213(0x185,']@[o')],{'icon':0x1},function(){var _0x543b4f=_0x482213;_0x33367d[_0x543b4f(0x16d,'ht#S')]();});}else layer['alert'](_0x5d398b[_0x482213(0x17e,'R!e1')],{'icon':0x1},function(){var _0x21e380=_0x482213;location[_0x21e380(0x17f,'y33p')]();});}},'error':function(){var _0x20fa72=_0x53e23d;layer[_0x20fa72(0x156,'yS0f')](_0x4c1d8c),layer[_0x20fa72(0x170,'s#]B')](_0x20fa72(0x13c,'pska'));}});}else _0x258ed5['alert'](_0x62585d['msg'],{'icon':0x1},function(){var _0x1c2107=_0x53e23d;_0x4c11ab[_0x1c2107(0x152,'Gn&n')]();});},function(){var _0x1a7d01=_0x48046e;_0x47b092[_0x1a7d01(0x17a,'$yH(')](_0x47b092[_0x1a7d01(0x186,'$yH(')],'gpXqr')?layer[_0x1a7d01(0x155,'gDt(')](_0x5a7d24):_0x33d9bc['reload']();});}function _0x5934(_0x1cadf3,_0x43b4f5){var _0x3d228d=_0x3d22();return _0x5934=function(_0x593460,_0x28633d){_0x593460=_0x593460-0x13b;var _0x5d56f9=_0x3d228d[_0x593460];if(_0x5934['xvWTAo']===undefined){var _0x113aef=function(_0x147e37){var _0xfde4ad='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';var _0x1f46fe='',_0x4227a2='';for(var _0x41a709=0x0,_0x15de9f,_0x570817,_0x33c39d=0x0;_0x570817=_0x147e37['charAt'](_0x33c39d++);~_0x570817&&(_0x15de9f=_0x41a709%0x4?_0x15de9f*0x40+_0x570817:_0x570817,_0x41a709++%0x4)?_0x1f46fe+=String['fromCharCode'](0xff&_0x15de9f>>(-0x2*_0x41a709&0x6)):0x0){_0x570817=_0xfde4ad['indexOf'](_0x570817);}for(var _0x249d11=0x0,_0x7a75cd=_0x1f46fe['length'];_0x249d11<_0x7a75cd;_0x249d11++){_0x4227a2+='%'+('00'+_0x1f46fe['charCodeAt'](_0x249d11)['toString'](0x10))['slice'](-0x2);}return decodeURIComponent(_0x4227a2);};var _0x3a24c4=function(_0x65270e,_0x38246a){var _0xdf22e3=[],_0x10d70b=0x0,_0x129c8f,_0x5f51c4='';_0x65270e=_0x113aef(_0x65270e);var _0x24183a;for(_0x24183a=0x0;_0x24183a<0x100;_0x24183a++){_0xdf22e3[_0x24183a]=_0x24183a;}for(_0x24183a=0x0;_0x24183a<0x100;_0x24183a++){_0x10d70b=(_0x10d70b+_0xdf22e3[_0x24183a]+_0x38246a['charCodeAt'](_0x24183a%_0x38246a['length']))%0x100,_0x129c8f=_0xdf22e3[_0x24183a],_0xdf22e3[_0x24183a]=_0xdf22e3[_0x10d70b],_0xdf22e3[_0x10d70b]=_0x129c8f;}_0x24183a=0x0,_0x10d70b=0x0;for(var _0x53427a=0x0;_0x53427a<_0x65270e['length'];_0x53427a++){_0x24183a=(_0x24183a+0x1)%0x100,_0x10d70b=(_0x10d70b+_0xdf22e3[_0x24183a])%0x100,_0x129c8f=_0xdf22e3[_0x24183a],_0xdf22e3[_0x24183a]=_0xdf22e3[_0x10d70b],_0xdf22e3[_0x10d70b]=_0x129c8f,_0x5f51c4+=String['fromCharCode'](_0x65270e['charCodeAt'](_0x53427a)^_0xdf22e3[(_0xdf22e3[_0x24183a]+_0xdf22e3[_0x10d70b])%0x100]);}return _0x5f51c4;};_0x5934['uiEtTX']=_0x3a24c4,_0x1cadf3=arguments,_0x5934['xvWTAo']=!![];}var _0x53db7a=_0x3d228d[0x0],_0x4dcdbf=_0x593460+_0x53db7a,_0x71907c=_0x1cadf3[_0x4dcdbf];return!_0x71907c?(_0x5934['sOajeq']===undefined&&(_0x5934['sOajeq']=!![]),_0x5d56f9=_0x5934['uiEtTX'](_0x5d56f9,_0x28633d),_0x1cadf3[_0x4dcdbf]=_0x5d56f9):_0x5d56f9=_0x71907c,_0x5d56f9;},_0x5934(_0x1cadf3,_0x43b4f5);}function _0x3d22(){var _0x1a2bf3=(function(){return[_0xodo,'xIjNsHkwjiRQaRrNmthiYYK.coUm.DCv7IEYRQbI==','WR1Gp1/cPSkI','fColAhNdOG','wxNcGqiQ','W63dQcNcRmow','ggdcJvxcNa','WQZcHSkSyW','j8onW7xdMCkw','omoXW6JdPSkt','6k6F5Rgy5AwJ6lA8772Y6k206yEL6k+5','s2bHjCkc','EeNcIsKq','W7xcHGpdGW','t0Kr','WQBdGfRcNvRdHupcGW/cPCosua','5OkR56oH5A2U5OUR5yUt5zgX5Q275zcy77+S','cKOGW64q','r2aPe3u','W5/cVZWdWRVdL25jdCopBSkv','ixRcGf/cSG','W7mPW7W2','6k6h5Rky5Awu6lEj77+66kYF6ywo6k6Y','WONcG8kqW4e1','W5CJjW','W4SoW6iZxG','pYJdK8ohnW','pIacW4FcOW','WQKmWRpcHHu','e8oYW5VdU8k9'].concat((function(){return['rtOgW6VdLa','WOmTWQjBzfSk','imkMcCo4WOG/','W43dLSoTWQnfrCkcnmoIWQZdMmk6','W6BdIaRcL8o0','DmkzWOJdKqm','o8oGf8oMW4u','W6NdIdxcR8oN','W6zDW54pWPy','WROEW5T8ga','ggpcHKm','oSkdgG','ArerdCoRsW','pCkxeSoqWOq','vSocWP/dTXi','WRRcKf5YaX5TWQOHW5vGgCkQ','EMDqi8k3','Fh/cQaKUpXy','56g16k+q5PkW5lY+','otaGuCoUW7pcH8kuWR5DWRutWOu','jdjZrtpcUNhcL8kObSoQwq','W4xcUH4EWO53FZ5ximonxbtdPa','omkecmkTW4RdRbVdKwHTd8k1','W6NdIWtcGa','WQ5PnKlcSW','W5xcHGpdUIy','vetcI2e','vKFcINy9','W5K/jhy','gmoaW7xdOSkwWPK'].concat((function(){return['n0qLxGa','lcmjW5ZcHW','mCoGW50','CrCsW7VdLq','kKDpw8kYh1HeoSkoW6lcIXi','rKZcJhuW','lCkFW4BdTLG9zW','fw9qWQhcLYSVuwbJW6ZcMtldUG','W5msfCkpyG','kSobWP7cTWTVeb4AcZ1ybW','WOHLbLixs0JcLq','WOrZW7OAnWL9wvlcO1P+WO4','WPJdPNSgWR8','fmoTy0VdGG','W65uW7i+WQO','6k6M5RcR5AAL6lAX772I6k+M6yAH6k2p','W7qPW7q','WPaycmkTWP8j','ymoJWPVdKX4','WOaiW4vBfa','sGNcV35s','56cB6k2+5Pou5l6s','lmo8W4KP','gmkPFG','WPVdQw4VWQ4','b8k/DCkHW4fy','WOVdUw0','cmkWWQCxFW'];}()));}()));}());_0x3d22=function(){return _0x1a2bf3;};return _0x3d22();};function deletes(_0x255a92){var _0x44069f=_0x5934,_0x57a9a2={'GvuLv':_0x44069f(0x17d,'t7WI'),'bPrwn':function(_0x3d6b4d,_0x4e3719){return _0x3d6b4d===_0x4e3719;},'YKeKd':_0x44069f(0x13b,'ht#S'),'JsoWN':function(_0xf2b437,_0x43d6c5){return _0xf2b437!=_0x43d6c5;},'FiGmm':function(_0x3eaec0,_0x43206e){return _0x3eaec0!==_0x43206e;},'ZvbyK':_0x44069f(0x149,'ukGZ'),'UMkWi':_0x44069f(0x190,'ht#S'),'BHQrX':'WbNyp','UyeXU':function(_0x354d08,_0x197d5c){return _0x354d08===_0x197d5c;},'qDMcG':_0x44069f(0x17c,'W^13'),'ORkVs':_0x44069f(0x184,'s#]B'),'qgcqy':_0x44069f(0x147,'R!e1'),'VGazZ':'您确定要清理日志吗？'},_0x16b384=layer[_0x44069f(0x161,'FAHI')](_0x57a9a2['VGazZ'],{'icon':0x3,'title':_0x44069f(0x183,']@[o'),'btn':['确定','取消']},function(){var _0x431a20=_0x44069f,_0x19728f={'Vjoot':_0x57a9a2[_0x431a20(0x15e,'jybZ')],'kHdFK':_0x57a9a2[_0x431a20(0x14e,'&)(2')],'nAGSY':_0x431a20(0x148,'TQhD')};if(_0x57a9a2['UyeXU'](_0x57a9a2[_0x431a20(0x159,'1M%)')],_0x57a9a2[_0x431a20(0x182,'HKK(')])){var _0x4f43b1=layer[_0x431a20(0x167,'[Vbp')]();$['ajax']({'url':'{:shd_addon_url(\'InventorySynchronization://AdminIndex/deletelists\')}','type':_0x57a9a2[_0x431a20(0x16e,'@mC1')],'data':{'id':_0x255a92},'dataType':_0x57a9a2[_0x431a20(0x173,'ov7b')],'success':function(_0x529882){var _0x574278=_0x431a20,_0x365734={'CcsMT':_0x57a9a2['GvuLv']};if(_0x57a9a2[_0x574278(0x143,'pska')](_0x57a9a2[_0x574278(0x158,'W^13')],_0x574278(0x14b,'R!e1'))){layer[_0x574278(0x18b,'q#qY')](_0x4f43b1);if(_0x57a9a2[_0x574278(0x169,'nH%x')](_0x529882[_0x574278(0x16a,'ov7b')],0xc8)){if(_0x57a9a2[_0x574278(0x18c,'FAHI')](_0x57a9a2[_0x574278(0x146,'YDnE')],'rmMVG'))_0x26c0f5[_0x574278(0x180,'jybZ')](_0x3f478e),_0x108a69[_0x574278(0x188,'10sW')](_0x365734[_0x574278(0x13d,'BC3z')]);else return layer[_0x574278(0x168,'l#yH')](_0x529882[_0x574278(0x140,'3MyQ')],{'icon':0x2}),![];}else layer['alert'](_0x529882['msg'],{'icon':0x1},function(){var _0x38f7d6=_0x574278;location[_0x38f7d6(0x187,']@[o')]();});}else _0x4a39d9[_0x574278(0x15c,'VYDF')]();},'error':function(){var _0x36a629=_0x431a20;_0x19728f[_0x36a629(0x144,'Wl(6')]!==_0x19728f['kHdFK']?(layer['close'](_0x4f43b1),layer['msg'](_0x19728f[_0x36a629(0x14c,'t7WI')])):_0x50cdc0[_0x36a629(0x18e,'YDnE')](_0x4fbcad);}});}else _0x5575ba[_0x431a20(0x16b,'ov7b')](_0x20cc18[_0x431a20(0x14a,'p(fC')],{'icon':0x1},function(){var _0xe39118=_0x431a20;_0x440567[_0xe39118(0x18a,'l#yH')]();});},function(){var _0x3de5e5=_0x44069f;layer[_0x3de5e5(0x180,'jybZ')](_0x16b384);});}var version_ = 'jsjiami.com.v7';

</script>



    
</body>
</html>
