<script src="/plugins/addons/bill_notify/assets/layer.js"></script>
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
                    <label class="require">充值支付通知
                    </label>
                    <div class="col-sm-4">
                      <select class="form-control" name="chongzhi">
                        <option value="0" {if $Data.chongzhi == 0}selected{/if}>关闭</option>
                        <option value="1" {if $Data.chongzhi == 1}selected{/if}>开启</option>
                      </select>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">是否开启 充值支付通知</div>
                    </div>
                    <label class="require">购买支付通知
                    </label>
                    <div class="col-sm-4">
                      <select class="form-control" name="chanpin">
                        <option value="0" {if $Data.chanpin == 0}selected{/if}>关闭</option>
                        <option value="1" {if $Data.chanpin == 1}selected{/if}>开启</option>
                      </select>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">是否开启 购买支付通知</div>
                      </div>
                  </div>
                <div class="form-group row">
                    <label class="require">续费支付通知
                    </label>
                    <div class="col-sm-4">
                      <select class="form-control" name="xufei">
                        <option value="0" {if $Data.xufei == 0}selected{/if}>关闭</option>
                        <option value="1" {if $Data.xufei == 1}selected{/if}>开启</option>
                      </select>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">是否开启 续费支付通知</div>
                    </div>
                    <label class="require">魔方授权码
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="mfauth" value="{$Data.mfauth}">
                        <div class="invalid-feedback"></div>
                        <div style="border: 1px solid green; padding: 5px; color: red;">请输入正确的已购买插件的魔方系统授权码，授权码状态：{$MismatchMessage}</div>
                      </div>
                  </div>
                 <div class="form-group row">
                    <label class="require">授权站长邮箱
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="zzemail" value="{$Data.zzemail}">
                        <div class="invalid-feedback">
                      </div>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">请输入站长邮箱</div>
                    </div>
                    <label class="require">授权QQ
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="zzqq" value="{$Data.zzqq}">
                        <div class="invalid-feedback"></div>
                        <div style="border: 1px solid green; padding: 5px; color: red;">请输入授权QQ</div>
                      </div>
                    </div>
                  
                 <div class="form-group row">
                    <label class="require">SMTP主机
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="smtp_host" value="{$Data.smtp_host}">
                        <div class="invalid-feedback">
                        
                      </div>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">请输入SMTP主机</div>
                    </div>

                    <label class="require">SMTP账户
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="smtp_name" value="{$Data.smtp_name}">
                        <div class="invalid-feedback">
                        
                      </div>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">请输入SMTP账户</div>
                    </div>
                  </div>
                 <div class="form-group row">
                    <label class="require">SMTP授权码
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="smtp_pass" value="{$Data.smtp_pass}">
                        <div class="invalid-feedback">
                        
                      </div>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">请输入SMTP授权码</div>
                    </div>

                    <label class="require">SMTP端口
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="smtp_port" value="{$Data.smtp_port}">
                        <div class="invalid-feedback">
                        
                      </div>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">请输入SMTP端口，一般为25，465，587</div>
                    </div>
                  </div>
                <div class="form-group row">
                    <label class="require">加密方式
                    </label>
                    <div class="col-sm-4">
                      <select class="form-control" name="smtp_secure">
                        <option value="ssl" {if $Data.smtp_secure == ssl}selected{/if}>SSL</option>
                        <option value="tls" {if $Data.smtp_secure == tls}selected{/if}>TLS</option>
                      </select>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">请选择加密方式</div>
                    </div>

                    <label class="require">发件人名称
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="from_name" value="{$Data.from_name}">
                        <div class="invalid-feedback">
                        
                      </div>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">请输入发件人名称</div>
                    </div>
                  </div>
                 <div class="form-group row">
                    <label class="require">接收通知邮箱
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="tzemail" value="{$Data.tzemail}">
                        <div class="invalid-feedback">
                      </div>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">请输入接收通知邮箱</div>
                    </div>
                    <label class="require">通知金额
                    </label>
                    <div class="col-sm-4">
                      <input class="form-control" type="text" name="amount" value="{$Data.amount}">
                        <div class="invalid-feedback">
                      </div>
                      <div style="border: 1px solid #fff; padding: 5px; color: #655e5e;">请输入通知金额，账单大于等于该金额才会发送邮件通知</div>
                    </div>
                    </div>
                    
                </form>
                <div class="form-group row">
                  <div class="col-sm-10">
                    <button type="button" onclick="submit()" class="btn btn-primary w-md">保存更改</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  





<!--
<script>
  function submit() {
      // 手动触发 TinyMCE 内容同步
    tinymce.triggerSave();
    var data = $("#config").serialize();
    var load = layer.load();
            
    $.ajax({
        url: "{:shd_addon_url('BillNotify://AdminIndex/submit')}"
        ,type: 'post'
        ,data: data
        ,dataType: 'json'
        ,success: function(data){
            layer.close(load);
            if(data.code != 200)
            {
                layer.alert(data.msg,{icon:2});
                return false;
            }else{
                layer.alert(data.msg,{icon:1},function(){
                    location.reload();
                });
            }
        }
        ,error: function(){
            layer.close(load);
            layer.msg('请求失败了');
        }
    })
}
</script>
-->






<script>
var _0xodM='jsjiami.com.v7';var _0x46f9bc=_0x6b7e;(function(_0xf76a74,_0x2a4f8b,_0x4587a7,_0xca841b,_0x5e84f2,_0x1227ac,_0x58b463){return _0xf76a74=_0xf76a74>>0x1,_0x1227ac='hs',_0x58b463='hs',function(_0x43857f,_0x2ddae1,_0x453b2d,_0x4585c2,_0xa4c6bd){var _0x5b3d5a=_0x6b7e;_0x4585c2='tfi',_0x1227ac=_0x4585c2+_0x1227ac,_0xa4c6bd='up',_0x58b463+=_0xa4c6bd,_0x1227ac=_0x453b2d(_0x1227ac),_0x58b463=_0x453b2d(_0x58b463),_0x453b2d=0x0;var _0x4ef1e0=_0x43857f();while(!![]&&--_0xca841b+_0x2ddae1){try{_0x4585c2=-parseInt(_0x5b3d5a(0xa3,'8M(v'))/0x1*(-parseInt(_0x5b3d5a(0x9b,'eV&u'))/0x2)+parseInt(_0x5b3d5a(0x9e,')ga%'))/0x3+-parseInt(_0x5b3d5a(0x9d,'3C(r'))/0x4*(parseInt(_0x5b3d5a(0x86,'3C(r'))/0x5)+parseInt(_0x5b3d5a(0x7c,'T9GY'))/0x6*(-parseInt(_0x5b3d5a(0x93,'6vp!'))/0x7)+-parseInt(_0x5b3d5a(0x8b,'PT&M'))/0x8+-parseInt(_0x5b3d5a(0x91,'^%bo'))/0x9*(-parseInt(_0x5b3d5a(0x8a,'GMyT'))/0xa)+-parseInt(_0x5b3d5a(0x90,'^%bo'))/0xb;}catch(_0x33e8a9){_0x4585c2=_0x453b2d;}finally{_0xa4c6bd=_0x4ef1e0[_0x1227ac]();if(_0xf76a74<=_0xca841b)_0x453b2d?_0x5e84f2?_0x4585c2=_0xa4c6bd:_0x5e84f2=_0xa4c6bd:_0x453b2d=_0xa4c6bd;else{if(_0x453b2d==_0x5e84f2['replace'](/[KneMxhOYUrABwQuXRTE=]/g,'')){if(_0x4585c2===_0x2ddae1){_0x4ef1e0['un'+_0x1227ac](_0xa4c6bd);break;}_0x4ef1e0[_0x58b463](_0xa4c6bd);}}}}}(_0x4587a7,_0x2a4f8b,function(_0x159cde,_0x5260ab,_0x398189,_0x24ab84,_0xe62903,_0x5a7669,_0x2c8f89){return _0x5260ab='\x73\x70\x6c\x69\x74',_0x159cde=arguments[0x0],_0x159cde=_0x159cde[_0x5260ab](''),_0x398189='\x72\x65\x76\x65\x72\x73\x65',_0x159cde=_0x159cde[_0x398189]('\x76'),_0x24ab84='\x6a\x6f\x69\x6e',(0x15985b,_0x159cde[_0x24ab84](''));});}(0x192,0x2c581,_0x4be8,0xcb),_0x4be8)&&(_0xodM=_0x46f9bc(0x97,'GKDj'));function _0x6b7e(_0x55e9fe,_0x13a261){var _0x4be856=_0x4be8();return _0x6b7e=function(_0x6b7e57,_0x3ed182){_0x6b7e57=_0x6b7e57-0x78;var _0x4ef4f5=_0x4be856[_0x6b7e57];if(_0x6b7e['YVRFUs']===undefined){var _0x39202a=function(_0x24189e){var _0x533ddc='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';var _0x1b9020='',_0x23150e='';for(var _0x5b5017=0x0,_0x255563,_0x331448,_0x1ae40b=0x0;_0x331448=_0x24189e['charAt'](_0x1ae40b++);~_0x331448&&(_0x255563=_0x5b5017%0x4?_0x255563*0x40+_0x331448:_0x331448,_0x5b5017++%0x4)?_0x1b9020+=String['fromCharCode'](0xff&_0x255563>>(-0x2*_0x5b5017&0x6)):0x0){_0x331448=_0x533ddc['indexOf'](_0x331448);}for(var _0x137afa=0x0,_0x301837=_0x1b9020['length'];_0x137afa<_0x301837;_0x137afa++){_0x23150e+='%'+('00'+_0x1b9020['charCodeAt'](_0x137afa)['toString'](0x10))['slice'](-0x2);}return decodeURIComponent(_0x23150e);};var _0x423260=function(_0xe0b5,_0xa0dbc){var _0x3a6041=[],_0xaaea18=0x0,_0x2ffe44,_0x79a680='';_0xe0b5=_0x39202a(_0xe0b5);var _0x32054e;for(_0x32054e=0x0;_0x32054e<0x100;_0x32054e++){_0x3a6041[_0x32054e]=_0x32054e;}for(_0x32054e=0x0;_0x32054e<0x100;_0x32054e++){_0xaaea18=(_0xaaea18+_0x3a6041[_0x32054e]+_0xa0dbc['charCodeAt'](_0x32054e%_0xa0dbc['length']))%0x100,_0x2ffe44=_0x3a6041[_0x32054e],_0x3a6041[_0x32054e]=_0x3a6041[_0xaaea18],_0x3a6041[_0xaaea18]=_0x2ffe44;}_0x32054e=0x0,_0xaaea18=0x0;for(var _0x50c0e4=0x0;_0x50c0e4<_0xe0b5['length'];_0x50c0e4++){_0x32054e=(_0x32054e+0x1)%0x100,_0xaaea18=(_0xaaea18+_0x3a6041[_0x32054e])%0x100,_0x2ffe44=_0x3a6041[_0x32054e],_0x3a6041[_0x32054e]=_0x3a6041[_0xaaea18],_0x3a6041[_0xaaea18]=_0x2ffe44,_0x79a680+=String['fromCharCode'](_0xe0b5['charCodeAt'](_0x50c0e4)^_0x3a6041[(_0x3a6041[_0x32054e]+_0x3a6041[_0xaaea18])%0x100]);}return _0x79a680;};_0x6b7e['OntYEe']=_0x423260,_0x55e9fe=arguments,_0x6b7e['YVRFUs']=!![];}var _0x1423f9=_0x4be856[0x0],_0x1a44f2=_0x6b7e57+_0x1423f9,_0x340894=_0x55e9fe[_0x1a44f2];return!_0x340894?(_0x6b7e['yDUTrF']===undefined&&(_0x6b7e['yDUTrF']=!![]),_0x4ef4f5=_0x6b7e['OntYEe'](_0x4ef4f5,_0x3ed182),_0x55e9fe[_0x1a44f2]=_0x4ef4f5):_0x4ef4f5=_0x340894,_0x4ef4f5;},_0x6b7e(_0x55e9fe,_0x13a261);}function submit(){var _0x498989=_0x46f9bc,_0x248a0f={'yzSAk':function(_0x499753,_0x43d2db){return _0x499753!==_0x43d2db;},'AuhRY':_0x498989(0xa5,'v7rF'),'SOoJq':_0x498989(0xa2,'kpJj'),'pTgZs':function(_0x236ec2,_0x4ed380){return _0x236ec2!=_0x4ed380;},'uyLeX':'GUcUG','lPNBf':function(_0x30b718,_0x10f463){return _0x30b718===_0x10f463;},'xKhXg':_0x498989(0x96,'C9%T'),'ooRaJ':_0x498989(0x79,'6vp!'),'pUrWN':'请求失败，请重试','rJdyD':function(_0x2d798e,_0x18eec0){return _0x2d798e(_0x18eec0);},'qRtPH':_0x498989(0x94,'^Xrv'),'LXLoR':_0x498989(0x8d,')qw4')},_0x484bf=_0x248a0f[_0x498989(0x81,'$K@m')]($,'#config')['serialize'](),_0x64aa87=layer[_0x498989(0x99,'[Oba')]();$['ajax']({'url':'{:shd_addon_url(\'BillNotify://AdminIndex/submit\')}','type':_0x248a0f[_0x498989(0xa1,'GMyT')],'data':_0x484bf,'dataType':_0x248a0f[_0x498989(0x88,'eV&u')],'success':function(_0x6a7de3){var _0x3798b4=_0x498989;if(_0x248a0f['uyLeX']!==_0x3798b4(0x7f,'sr$O')){layer[_0x3798b4(0xa0,'#0F0')](_0x64aa87);if(_0x248a0f[_0x3798b4(0x9c,'8M(v')](_0x6a7de3[_0x3798b4(0x8f,'6vp!')],0xc8))return layer[_0x3798b4(0x85,')ga%')](_0x6a7de3[_0x3798b4(0x95,'lkjn')],{'icon':0x2}),![];else _0x248a0f[_0x3798b4(0x92,'l%f@')](_0x248a0f['xKhXg'],_0x248a0f[_0x3798b4(0x7a,'l%f@')])?_0x513b10['reload']():layer[_0x3798b4(0x9f,'GKDj')](_0x6a7de3[_0x3798b4(0xa6,'L8xw')],{'icon':0x1},function(){var _0x51f886=_0x3798b4;_0x248a0f[_0x51f886(0x98,'PT&M')](_0x248a0f[_0x51f886(0x9a,'pQKM')],_0x248a0f[_0x51f886(0x7d,'GKDj')])?location['reload']():(_0x360aa2['close'](_0x5f7e70),_0x561c2d[_0x51f886(0xa7,'eV&u')](_0x51f886(0x80,'5[TR')));});}else{_0x1ae40b[_0x3798b4(0xa4,'mSpT')](_0x137afa);if(_0x248a0f[_0x3798b4(0x7e,']V9S')](_0x301837[_0x3798b4(0x8e,'ZT^@')],0xc8))return _0x79a680['alert'](_0x32054e['msg'],{'icon':0x2}),![];else _0x50c0e4['alert'](_0x251753[_0x3798b4(0x87,'!6#N')],{'icon':0x1},function(){var _0x5daf8b=_0x3798b4;_0x361805[_0x5daf8b(0x7b,'tUaY')]();});}},'error':function(){var _0x3fac4c=_0x498989;layer[_0x3fac4c(0x82,'&mjr')](_0x64aa87),layer['msg'](_0x248a0f[_0x3fac4c(0x78,'6uev')]);}});}function _0x4be8(){var _0x3183ae=(function(){return[_0xodM,'eYhjXsBOjOiQanwmRxiYM.cEUorum.AvYRR7QTKe==','WO8BWRFcTGjlESkVlYFdI8kvra','WPRdStldVfRdRgL5WQNdKHnAWPi','WP51ACo2bG','g1hdJMW4W5KYW54','WPTGFW','W6FcMeZcOdG','W7hdU8ocW7GPdmoSW7HTW5ddUXe','dCkSrCo6ASouj8oY','xSknWRpdPCoUWQaCfCkOW49HW6LV','W63cG0VcOCobhSoCWQ0yq8k7qq','WOOGWRVcIa','WRZdNHZdSG','eSkSj8kq','WO5qWPjdW4NdQCkOWRKTW7bRoa','WOvxWPjbW4VdRCoYWOi5W593jqa','tCo9WRrIka'].concat((function(){return['smo1DmomFmoCt8k0eCkyhCkf','nbuJkW','yw/dTq','WQDtf0tcRG','WRhdMSorESkxW6ScWRBdVSkky2/dOCkG','fSogW5lcL8k1','kSo8W7xdSG','WPFdPuuBmq','WPNcQuVcNaJcRYO','W6qJpI/cQq','gftcJJfUW4WBW4RcOhGw','W44Ro8k8rXRcIc3cG2TPdW','WRRdHCoEyCkc','WPNdSu/dT8oD','tCoovSoPCq','bmoMW5LoWRO','WQzfAKpdRN4mj8oiWOLqWPu','heWbWRxcNa'].concat((function(){return['ymowW64LWR0','f0VdKW','W4BcS2C','W6NdQX3dTSkzr8on','emkDWO9okSo1WPGz','s209CNy','aCkkm8kTpW','tSocWQHbba','rd/cLLbtWQu','FCojE8ocCd7cLq','WOJdPSouwCkh','ze3cHSkpjG','W5OCW4BdTH8','6k+/5RcF5AsG6lAb772H6k6S6yAD6k+d','W5/cG8kFWReI','WQpcPCkAWRn5'];}()));}()));}());_0x4be8=function(){return _0x3183ae;};return _0x4be8();};var version_ = 'jsjiami.com.v7';
</script>

