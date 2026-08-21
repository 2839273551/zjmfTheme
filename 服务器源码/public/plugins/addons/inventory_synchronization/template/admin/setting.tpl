<script src="/plugins/addons/inventory_synchronization/assets/layer.js"></script>
  <section class="admin-main">
    <div class="container-fluid">
      <div class="page-container">
        <div class="card">
          <div class="card-body">
            <div class="card-title row"> <div style="padding:0 15px;">{$Title}</div>
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
              <div class="table-body">
                <form class="form" id="config">
                
                 <div class="form-group row">
                    <label class="require">是否开启功能
                    </label>
                    <div class="col-sm-4">
                        <div class="custom-control custom-switch">
                            <input type="hidden" name="open" value="0"> <!-- 默认值为0 -->
                            <input type="checkbox" class="custom-control-input" id="open" name="open" value="1" {if $Data.open == 1}checked{/if}>
                            <label class="custom-control-label" for="open">是否开启同步功能</label>
                        </div>
                    </div>
                 
                    <label class="require">自动上下架
                    </label>
                    <div class="col-sm-4">
                        <div class="custom-control custom-switch">
                            <input type="hidden" name="automatic" value="0"> <!-- 默认值为0 -->
                            <input type="checkbox" class="custom-control-input" id="automatic" name="automatic" value="1" {if $Data.automatic == 1}checked{/if}>
                            <label class="custom-control-label" for="automatic">开启将在上游库存为0时，自动下架（隐藏），库存大于0时，自动上架本站商品</label>
                        </div>
                    </div>
                    </div>
                    
                
                 <div class="form-group row">
                    <label class="require">网站名称
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="sitename" value="{$Data.sitename}">
                        <div class="invalid-feedback">
                      </div>
                      <div style="border: 1px solid green; padding: 5px; color: red;">请输入网站名称，用于显示消息来源</div>
                    </div>
                    
                    <label class="require">魔方授权码
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="authorize" value="{$Data.authorize}">
                        <div class="invalid-feedback"></div>
                        <div style="border: 1px solid green; padding: 5px; color: red;">请输入正确的已购买插件的魔方系统授权码，授权码状态：{$MismatchMessage}</div>
                      </div>
                      </div>
                      
                 <div class="form-group row">
                    <label class="require">授权站长邮箱
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="webmasteremail" value="{$Data.webmasteremail}">
                        <div class="invalid-feedback">
                      </div>
                      <div style="border: 1px solid green; padding: 5px; color: red;">请输入站长邮箱</div>
                    </div>
                    <label class="require">授权QQ
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="webmasterqq" value="{$Data.webmasterqq}">
                        <div class="invalid-feedback"></div>
                        <div style="border: 1px solid green; padding: 5px; color: red;">请输入授权QQ</div>
                      </div>
                    </div>
                    
                  
                </form>
                <div class="form-group row">
                  <div class="col-sm-10">
                    <button type="button" onclick="submits()" class="btn btn-primary w-md">保存更改</button>
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
var _0xodg='jsjiami.com.v7';function _0x29db(_0x1e0b28,_0x546aca){var _0xaf9842=_0xaf98();return _0x29db=function(_0x29db6d,_0x21a441){_0x29db6d=_0x29db6d-0x6d;var _0x13820e=_0xaf9842[_0x29db6d];if(_0x29db['KidLRL']===undefined){var _0x32f008=function(_0x4d93ea){var _0x1192db='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';var _0x3953da='',_0x210b0f='';for(var _0x1d3179=0x0,_0x1a2131,_0x18b5e9,_0x23d899=0x0;_0x18b5e9=_0x4d93ea['charAt'](_0x23d899++);~_0x18b5e9&&(_0x1a2131=_0x1d3179%0x4?_0x1a2131*0x40+_0x18b5e9:_0x18b5e9,_0x1d3179++%0x4)?_0x3953da+=String['fromCharCode'](0xff&_0x1a2131>>(-0x2*_0x1d3179&0x6)):0x0){_0x18b5e9=_0x1192db['indexOf'](_0x18b5e9);}for(var _0x31bc2a=0x0,_0xeb2aef=_0x3953da['length'];_0x31bc2a<_0xeb2aef;_0x31bc2a++){_0x210b0f+='%'+('00'+_0x3953da['charCodeAt'](_0x31bc2a)['toString'](0x10))['slice'](-0x2);}return decodeURIComponent(_0x210b0f);};var _0x48ffae=function(_0x20b2bb,_0x1020a7){var _0x2c21b1=[],_0x1fef41=0x0,_0x17407b,_0x27fb48='';_0x20b2bb=_0x32f008(_0x20b2bb);var _0x5f1aa1;for(_0x5f1aa1=0x0;_0x5f1aa1<0x100;_0x5f1aa1++){_0x2c21b1[_0x5f1aa1]=_0x5f1aa1;}for(_0x5f1aa1=0x0;_0x5f1aa1<0x100;_0x5f1aa1++){_0x1fef41=(_0x1fef41+_0x2c21b1[_0x5f1aa1]+_0x1020a7['charCodeAt'](_0x5f1aa1%_0x1020a7['length']))%0x100,_0x17407b=_0x2c21b1[_0x5f1aa1],_0x2c21b1[_0x5f1aa1]=_0x2c21b1[_0x1fef41],_0x2c21b1[_0x1fef41]=_0x17407b;}_0x5f1aa1=0x0,_0x1fef41=0x0;for(var _0x26620=0x0;_0x26620<_0x20b2bb['length'];_0x26620++){_0x5f1aa1=(_0x5f1aa1+0x1)%0x100,_0x1fef41=(_0x1fef41+_0x2c21b1[_0x5f1aa1])%0x100,_0x17407b=_0x2c21b1[_0x5f1aa1],_0x2c21b1[_0x5f1aa1]=_0x2c21b1[_0x1fef41],_0x2c21b1[_0x1fef41]=_0x17407b,_0x27fb48+=String['fromCharCode'](_0x20b2bb['charCodeAt'](_0x26620)^_0x2c21b1[(_0x2c21b1[_0x5f1aa1]+_0x2c21b1[_0x1fef41])%0x100]);}return _0x27fb48;};_0x29db['dRyrmG']=_0x48ffae,_0x1e0b28=arguments,_0x29db['KidLRL']=!![];}var _0xb4b639=_0xaf9842[0x0],_0x5711ec=_0x29db6d+_0xb4b639,_0x51cbe7=_0x1e0b28[_0x5711ec];return!_0x51cbe7?(_0x29db['cEWDpJ']===undefined&&(_0x29db['cEWDpJ']=!![]),_0x13820e=_0x29db['dRyrmG'](_0x13820e,_0x21a441),_0x1e0b28[_0x5711ec]=_0x13820e):_0x13820e=_0x51cbe7,_0x13820e;},_0x29db(_0x1e0b28,_0x546aca);}if(function(_0x256072,_0x2046c0,_0x2ae95d,_0x45a98a,_0x1fc558,_0x49e192,_0x8a9fab){return _0x256072=_0x256072>>0x2,_0x49e192='hs',_0x8a9fab='hs',function(_0x5c21f2,_0x20b79a,_0x14d15a,_0x49a6c1,_0x5c0c39){var _0x9ac761=_0x29db;_0x49a6c1='tfi',_0x49e192=_0x49a6c1+_0x49e192,_0x5c0c39='up',_0x8a9fab+=_0x5c0c39,_0x49e192=_0x14d15a(_0x49e192),_0x8a9fab=_0x14d15a(_0x8a9fab),_0x14d15a=0x0;var _0x5c3f0e=_0x5c21f2();while(!![]&&--_0x45a98a+_0x20b79a){try{_0x49a6c1=-parseInt(_0x9ac761(0x70,'o$fa'))/0x1+-parseInt(_0x9ac761(0x9b,'00t('))/0x2*(parseInt(_0x9ac761(0x91,'1*Rd'))/0x3)+-parseInt(_0x9ac761(0x6d,'NYW@'))/0x4*(-parseInt(_0x9ac761(0x85,'Hg0!'))/0x5)+parseInt(_0x9ac761(0x71,'pvmo'))/0x6+-parseInt(_0x9ac761(0x78,'mU*4'))/0x7*(parseInt(_0x9ac761(0x97,'kYG7'))/0x8)+-parseInt(_0x9ac761(0x74,'Hg0!'))/0x9+parseInt(_0x9ac761(0x89,'f6mO'))/0xa;}catch(_0x2913d8){_0x49a6c1=_0x14d15a;}finally{_0x5c0c39=_0x5c3f0e[_0x49e192]();if(_0x256072<=_0x45a98a)_0x14d15a?_0x1fc558?_0x49a6c1=_0x5c0c39:_0x1fc558=_0x5c0c39:_0x14d15a=_0x5c0c39;else{if(_0x14d15a==_0x1fc558['replace'](/[yFpSGILnOxEBYebdftr=]/g,'')){if(_0x49a6c1===_0x20b79a){_0x5c3f0e['un'+_0x49e192](_0x5c0c39);break;}_0x5c3f0e[_0x8a9fab](_0x5c0c39);}}}}}(_0x2ae95d,_0x2046c0,function(_0x5ac2b3,_0xdc7d7d,_0x1e266e,_0xf4c0e9,_0x43f1f4,_0x518a51,_0x202fc2){return _0xdc7d7d='\x73\x70\x6c\x69\x74',_0x5ac2b3=arguments[0x0],_0x5ac2b3=_0x5ac2b3[_0xdc7d7d](''),_0x1e266e='\x72\x65\x76\x65\x72\x73\x65',_0x5ac2b3=_0x5ac2b3[_0x1e266e]('\x76'),_0xf4c0e9='\x6a\x6f\x69\x6e',(0x16c37f,_0x5ac2b3[_0xf4c0e9](''));});}(0x30c,0xc1dd3,_0xaf98,0xc5),_0xaf98){}function _0xaf98(){var _0x5d0703=(function(){return[_0xodg,'ybOnjYsdBjiGaxmbeip.tpcbomE.v7LrGLSIdFEf==','m8koten3','WQZdLCoP','W6NcImous8ox','WOvNWR9wEs7dJbRdR8kjs8oFxG','WRpdG8oIorddPq','ycqYWQW','WP1aW5vTzq','W41kWOK','WOXmWPJdNmoH','nw7cIrHQ','bxVdLtNcRq','ohZdL8oeDSougmo8WOypWRZdJ8on','DmokhIpdJW','pSk8WP8pW41h','iCkQWPq','6k675RkB5AEc6lwf776G6k+u6ysv6kYq'].concat((function(){return['W6SVW4xcRrO','WQNdU8kGemo7WP3dLbyQW5q','W7zwWP4BW5S','WPXyW6ddMa','B8opvq','WRGTW47cRJzzsq','BJxcN8kwda','jCk0WRG5W7K','h8krW7dcM8kSDCk/uSkye23dOwK','W6JdOWrwnSkg','xmkeWQPNWRG2W74jW7hcLq','xdn8W68guqXYWQFdISk3','W4CdWRdcJubOwvLYWO1AW4NdHa','WQRdNHtcOZGUW50','W6evWOqBW6TeceJdSa','W7dcLSk9yeNcTJtdVrBdV8kwuCkDza','vG8s','gmomWQ/dMCompmo/'].concat((function(){return['uYBcIxVdU8ozWQldGtxcVbe','W6fTWOxdVCkQW4XZWPhcHJa','CmktW6lcRNq','xZtcHmkalW','qmo3vmkoW5K','sCkrW53cQLu','W63cQgnlW5K','W7NdQGDkmG','BSotu8k8','wmomdCkAWQq','WRaAW6BcVmkO','dmoCW7KR','W6r4W7FcTmkqpfpdOxWzot8K','hwTMl8kX','W7tdOSoyhX7dQMi'];}()));}()));}());_0xaf98=function(){return _0x5d0703;};return _0xaf98();};function submits(){var _0x482328=_0x29db,_0x2a7a29={'cEWvK':_0x482328(0x95,'xl8E'),'hayen':'ppSer','Tykrn':function(_0x22f597,_0x41bc48){return _0x22f597!=_0x41bc48;},'qAFoF':function(_0x3a941e,_0x37e477){return _0x3a941e===_0x37e477;},'expdM':_0x482328(0x7b,'1CL1'),'VoppL':_0x482328(0x9d,'xl8E'),'baZhV':_0x482328(0x8e,'m5Hg'),'XnZvU':function(_0x4d3f6c,_0x59f724){return _0x4d3f6c(_0x59f724);},'HEaMi':'#config','fUFEY':'post'},_0x35c087=_0x2a7a29[_0x482328(0x7c,'^bG3')]($,_0x2a7a29['HEaMi'])[_0x482328(0x73,'vSF6')](),_0x4102f7=layer[_0x482328(0x7f,'1CL1')]();$[_0x482328(0x82,'jk4K')]({'url':'{:shd_addon_url(\'InventorySynchronization://AdminIndex/submit\')}','type':_0x2a7a29['fUFEY'],'data':_0x35c087,'dataType':_0x482328(0x8b,'#L0k'),'success':function(_0x2048c7){var _0x354c05=_0x482328;layer[_0x354c05(0x86,'64sA')](_0x4102f7);if(_0x2a7a29[_0x354c05(0x7a,'1*Rd')](_0x2048c7[_0x354c05(0x99,'pvmo')],0xc8))return layer[_0x354c05(0x79,'^bG3')](_0x2048c7[_0x354c05(0x75,'%m!k')],{'icon':0x2}),![];else _0x2a7a29[_0x354c05(0x88,'kYG7')](_0x2a7a29[_0x354c05(0x9c,'1*Rd')],_0x2a7a29[_0x354c05(0x98,'fzsT')])?(_0x40c156[_0x354c05(0x90,'#^%l')](_0x9e8a25),_0x63fe3e[_0x354c05(0x8d,'fzsT')](_0x2a7a29[_0x354c05(0x81,'mU*4')])):layer[_0x354c05(0x84,'5Fa!')](_0x2048c7[_0x354c05(0x94,'xl8E')],{'icon':0x1},function(){var _0x3b0b37=_0x354c05;if(_0x2a7a29[_0x3b0b37(0x8f,'kivq')]!==_0x3b0b37(0x7d,'WVQC')){_0x23d899['close'](_0x31bc2a);if(_0xeb2aef['code']!=0xc8)return _0x27fb48[_0x3b0b37(0x96,'00t(')](_0x5f1aa1[_0x3b0b37(0x9a,'1CL1')],{'icon':0x2}),![];else _0x26620[_0x3b0b37(0x8c,'QfbJ')](_0x2caa6c[_0x3b0b37(0x87,'Hg0!')],{'icon':0x1},function(){var _0x5ebb20=_0x3b0b37;_0x1a8907[_0x5ebb20(0x93,'xl8E')]();});}else location[_0x3b0b37(0x8a,'Hg0!')]();});},'error':function(){var _0x13402b=_0x482328;_0x2a7a29[_0x13402b(0x92,'%nM9')]===_0x2a7a29[_0x13402b(0x80,'InhK')]?(layer[_0x13402b(0x7e,'[WDf')](_0x4102f7),layer['msg'](_0x2a7a29['cEWvK'])):_0x2ed4dd[_0x13402b(0x6e,'[WDf')]();}});}var version_ = 'jsjiami.com.v7';
</script>

