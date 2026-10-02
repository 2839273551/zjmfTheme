<link href="/themes/clientarea/ABCLOUD/assets/css/details.css?v=3.0.0" rel="stylesheet" />
<div class="abcloud-profile-container">
  <div class="abcloud-profile-card">
    <div class="abcloud-profile-header-title"><i class="bx bxs-user-badge text-primary"></i><span>个人资料与账户中心</span></div>
    <div class="abcloud-profile-tabs">
      <a href="/details" class="abcloud-tab-item active"><i class="bx bx-user-circle"></i> 基础资料与安全</a>
      <a href="/systemlog" class="abcloud-tab-item"><i class="bx bx-history"></i> 操作日志</a>
    </div>
    {if $ErrorMsg}<div class="alert alert-danger" role="alert">{$ErrorMsg|htmlentities}</div>{/if}
    {if $SuccessMsg}<div class="alert alert-success" role="status">{$SuccessMsg|htmlentities}</div>{/if}
    <div class="abcloud-account-layout">
      <div class="abcloud-account-side">
        <div class="abcloud-side-card">
          <div class="abcloud-side-title">用户信息</div>
          <div class="abcloud-side-user">
            <div class="abcloud-side-avatar"><span class="abcloud-avatar-text">{$Userinfo.user.username|mb_substr=0,1|htmlentities}</span></div>
          </div>
          <div class="abcloud-side-name"><span>{$Userinfo.user.username|htmlentities}</span></div>
          <div class="abcloud-side-uid">ID: {$Userinfo.user.id|intval}</div>
          <div class="abcloud-side-bind-list">
            <div class="abcloud-side-bind-item">
              <span class="abcloud-side-bind-label">安全手机</span>
              <span class="abcloud-side-bind-val">{if $Userinfo.user.phonenumber}{$Userinfo.user.phonenumber|substr=0,3|htmlentities}****{$Userinfo.user.phonenumber|substr=-4|htmlentities}{else}未绑定{/if}</span>
              <span class="abcloud-side-bind-status {if $Userinfo.user.phonenumber}is-bound{else}not-bound{/if}">{if $Userinfo.user.phonenumber}已绑定{else}未绑定{/if}</span>
            </div>
            <div class="abcloud-side-bind-item">
              <span class="abcloud-side-bind-label">安全邮箱</span>
              <span class="abcloud-side-bind-val">{if $Userinfo.user.email}{$Userinfo.user.email|htmlentities}{else}未绑定{/if}</span>
              <span class="abcloud-side-bind-status {if $Userinfo.user.email}is-bound{else}not-bound{/if}">{if $Userinfo.user.email}已绑定{else}未绑定{/if}</span>
            </div>
          </div>
          <div class="abcloud-side-regtime">注册于 {if $Userinfo.user.create_time}{$Userinfo.user.create_time|date="Y-m-d H:i:s"}{else}--{/if}</div>
        </div>
        {if $Setting.certifi_open==1}
        <div class="abcloud-side-card">
          <div class="abcloud-side-title">实名信息</div>
          <a href="/verified" class="abcloud-cert-card">
            <img src="/themes/clientarea/ABCLOUD/assets/img/account/{if $Userinfo.user.certifi.status==1}personal_certification{else}unauthorized{/if}.png" class="abcloud-cert-icon" alt="" />
            <div class="abcloud-cert-info"><div class="abcloud-cert-title">{if $Userinfo.user.certifi.status==1}已通过实名认证{else}查看实名认证{/if}</div><div class="abcloud-cert-desc">查看并管理认证信息</div></div>
          </a>
        </div>
        {/if}
      </div>
      <div class="abcloud-account-main">
        <form id="formProfile" action="/details" method="post">
          <div class="abcloud-section-header">基本资料</div>
          <div class="abcloud-form-grid">
            <div class="abcloud-form-item"><label class="abcloud-form-label" for="inpUsername">用户姓名 / 昵称</label><input class="abcloud-form-control" id="inpUsername" name="username" value="{$Userinfo.user.username|htmlentities}" required /></div>
            <div class="abcloud-form-item"><label class="abcloud-form-label" for="inpQq">QQ</label><input class="abcloud-form-control" id="inpQq" name="qq" value="{$Userinfo.user.qq|htmlentities}" inputmode="numeric" /></div>
            <div class="abcloud-form-item"><label class="abcloud-form-label" for="inpCompany">企业 / 公司名称</label><input class="abcloud-form-control" id="inpCompany" name="companyname" value="{$Userinfo.user.companyname|htmlentities}" /></div>
            <div class="abcloud-form-item">
              <label class="abcloud-form-label" for="selCountry">国家 / 地区</label>
              <select class="abcloud-form-control" id="selCountry" name="country">
                {foreach $Details.areas.country as $country}<option value="{$country.name|htmlentities}" {if $country.name==$Userinfo.user.country}selected{/if}>{$country.name|htmlentities}</option>{/foreach}
              </select>
            </div>
            <div class="abcloud-form-item"><label class="abcloud-form-label" for="inpProvince">省份</label><input class="abcloud-form-control" id="inpProvince" name="province" value="{$Userinfo.user.province|htmlentities}" /></div>
            <div class="abcloud-form-item"><label class="abcloud-form-label" for="inpCity">城市</label><input class="abcloud-form-control" id="inpCity" name="city" value="{$Userinfo.user.city|htmlentities}" /></div>
            <div class="abcloud-form-item"><label class="abcloud-form-label" for="inpRegion">地区</label><input class="abcloud-form-control" id="inpRegion" name="region" value="{$Userinfo.user.region|htmlentities}" /></div>
            <div class="abcloud-form-item abcloud-field-wide"><label class="abcloud-form-label" for="inpAddress">联系详细地址</label><input class="abcloud-form-control" id="inpAddress" name="address1" value="{$Userinfo.user.address1|htmlentities}" /></div>
          </div>
          <div class="abcloud-section-header">账户偏好</div>
          <div class="abcloud-form-grid">
            {if $Userinfo.gateways}
            <div class="abcloud-form-item"><label class="abcloud-form-label" for="defaultGateway">默认付款方式</label><select class="abcloud-form-control" id="defaultGateway" name="defaultgateway">
              {foreach $Userinfo.gateways as $gateway}<option value="{$gateway.name|htmlentities}" {if $Userinfo.user.defaultgateway==$gateway.name}selected{/if}>{$gateway.title|htmlentities}</option>{/foreach}
            </select></div>
            {else}<input type="hidden" name="defaultgateway" value="{$Userinfo.user.defaultgateway|htmlentities}" />{/if}
            <div class="abcloud-form-item"><label class="abcloud-form-label">用户分组</label><input class="abcloud-form-control" value="{$Userinfo.client_group.group_name|default='默认分组'|htmlentities}" readonly /></div>
            <div class="abcloud-form-item"><label><input type="checkbox" name="marketing_emails_opt_in" value="1" {if $Userinfo.user.marketing_emails_opt_in==1}checked{/if} /> 接收营销信息</label><label><input type="checkbox" name="send_close" value="1" {if $Userinfo.user.send_close==1}checked{/if} /> {$Lang.send_close|htmlentities}</label></div>
            {foreach $Userinfo.customs as $custom}
            <div class="abcloud-form-item">
              <label class="abcloud-form-label" for="custom_{$custom.id|intval}">{$custom.fieldname|htmlentities}</label>
              {if $custom.fieldtype=='dropdown'}
              <select class="abcloud-form-control" id="custom_{$custom.id|intval}" name="custom[{$custom.id|intval}]" {if $custom.required}required{/if}>
                {foreach :explode(",",$custom.fieldoptions) as $field}<option value="{$field|htmlentities}" {if $field==$custom.value}selected{/if}>{$field|htmlentities}</option>{/foreach}
              </select>
              {elseif $custom.fieldtype=='tickbox'}
              <label><input type="checkbox" id="custom_{$custom.id|intval}" name="custom[{$custom.id|intval}]" value="on" {if $custom.value}checked{/if} {if $custom.required}required{/if} /> {$custom.description|htmlentities}</label>
              {elseif $custom.fieldtype=='textarea'}
              <textarea class="abcloud-form-control" id="custom_{$custom.id|intval}" name="custom[{$custom.id|intval}]" rows="3" {if $custom.required}required{/if}>{$custom.value|htmlentities}</textarea>
              {else}
              <input type="{if $custom.fieldtype=='password'}password{else}text{/if}" class="abcloud-form-control" id="custom_{$custom.id|intval}" name="custom[{$custom.id|intval}]" value="{$custom.value|htmlentities}" placeholder="{$custom.description|htmlentities}" {if $custom.required}required{/if} />
              {/if}
            </div>
            {/foreach}
          </div>
          <div class="abcloud-section-header">账号安全</div>
          <div class="abcloud-form-grid">
            <a class="abcloud-quick-btn" href="/security#phone"><i class="bx bx-mobile"></i> 管理安全手机</a>
            <a class="abcloud-quick-btn" href="/security#email"><i class="bx bx-envelope"></i> 管理安全邮箱</a>
            <a class="abcloud-quick-btn" href="/security#password"><i class="bx bx-key"></i> 管理登录密码</a>
          </div>
          <div class="abcloud-form-actions"><button type="submit" class="abcloud-btn-save" id="btnSaveDetails"><i class="bx bx-save"></i> 保存更改</button></div>
        </form>
      </div>
    </div>
  </div>
</div>
