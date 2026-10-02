{if (isset($Verify.is_captcha) && $Verify.is_captcha==1) || (isset($Login.is_captcha) && $Login.is_captcha==1) || (isset($Register.is_captcha) && $Register.is_captcha==1) || (isset($Pwreset.is_captcha) && $Pwreset.is_captcha==1)}
  {if '[type]' == 'allow_login_code_captcha'}
    {* 短信验证码获取必须使用原生图形验证码，供 login_send AJAX 请求采集验证 *}
    <div class="abcloud-form-group [type]">
      <label class="abcloud-form-label">图形验证码</label>
      <div class="input-group">
        <input {if [id]=='[id]'}id="captcha_[type][id]"{else}id="captcha_[type]"{/if} type="text" name="captcha" class="abcloud-input-field" placeholder="请输入图形验证码" autocomplete="off" />
        <div class="input-group-append" style="margin-left: 8px;">
          <img {if [id]=='[id]'}id="[type][id]"{else}id="[type]"{/if} height="44" class="border pointer" alt="验证码" style="border-radius: 6px; cursor: pointer;" onClick="getVerify('[type]')">
        </div>
      </div>
    </div>
  {else/}
    {if [positon]=='top'}
      <!--  20241015 新增模板钩子 -->
      {php}$hooks=hook('template_custom_clientarea_captcha_html',['id'=>'[type]']);{/php}
      {if !empty($hooks[0])}
        {foreach $hooks as $item}
          {$item}
        {/foreach}
      {else/}
        <div class="abcloud-form-group [type]">
          <label class="abcloud-form-label">图形验证码</label>
          <div class="input-group">
            <input {if [id]=='[id]'}id="captcha_[type][id]"{else}id="captcha_[type]"{/if} type="text" name="captcha" class="abcloud-input-field" placeholder="请输入验证码" autocomplete="off" />
            <div class="input-group-append" style="margin-left: 8px;">
              <img {if [id]=='[id]'}id="[type][id]"{else}id="[type]"{/if} height="44" class="border pointer" alt="验证码" style="border-radius: 6px; cursor: pointer;" onClick="getVerify('[type]')">
            </div>
          </div>
        </div>
      {/if}

    {else}

      <div class="abcloud-form-group row">
        <label class="col-sm-3 col-form-label text-right">图形验证码</label>
        <div class="col-sm-8">
          <div class="input-group">
            <input {if [id]=='[id]'}id="captcha_[type][id]"{else}id="captcha_[type]"{/if} type="text" name="captcha" class="abcloud-input-field" placeholder="请输入验证码" autocomplete="off" />
            <div class="input-group-append" style="margin-left: 8px;">
              <img {if [id]=='[id]'}id="[type][id]"{else} id="[type]"{/if} height="44" class="border pointer" alt="验证码" style="border-radius: 6px; cursor: pointer;" onClick="getVerify('[type]','[id]')">
            </div>
          </div>
        </div>
      </div>
    {/if}
  {/if}

  <script>
    getVerify('[type]','[id]')
  </script>
{/if}
