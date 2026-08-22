<section class="configure-summary" aria-label="{$Lang.order_summary}">
  <div class="configure-summary-head">
    <div>
      <span>当前配置</span>
      <h2>{$Lang.order_summary}</h2>
    </div>
    <span class="configure-summary-live">实时计价</span>
  </div>

  <div class="configure-summary-lines">
    <div class="configure-summary-line is-product">
      <div>
        <strong>{$ConfigureTotal.product_name}</strong>
        {if $ConfigureTotal.product_setup_fee>0}
        <small>含 {$ConfigureTotal.currency.prefix}{$ConfigureTotal.product_setup_fee}{$Lang.initial_installation_fee}</small>
        {/if}
      </div>
      <span>{$ConfigureTotal.currency.prefix}{$ConfigureTotal.product_price}</span>
    </div>

    {foreach $ConfigureTotal.child as $configure}
    <div class="configure-summary-line">
      <div>
        <span class="configure-summary-option">{$configure.option_name}</span>
        <strong>
          {if $configure.option_type == '12' && $configure.icon_flag}
          <img src="/upload/common/country/{$configure.icon_flag}.png" alt="" height="15">
          {elseif $configure.option_type == '5' && $configure.icon_os}
          <img src="/upload/common/system/{$configure.icon_os}.svg" alt="" height="18">
          {/if}
          {if $configure.qty}{$configure.qty}{else/}{$configure.sub_name}{/if}
        </strong>
        {if $configure.suboption_setup_fee > 0}
        <small>含 {$ConfigureTotal.currency.prefix}{$configure.suboption_setup_fee}{$Lang.initial_installation_fee}</small>
        {/if}
      </div>
      <span>{$ConfigureTotal.currency.prefix}{$configure.suboption_price}</span>
    </div>
    {/foreach}
  </div>

  {if $ConfigureTotal.type}
  <div class="configure-summary-discount">
    <div>
      <span>{$Lang.price}</span>
      <strong>{$ConfigureTotal.currency.prefix}{$ConfigureTotal.total}</strong>
    </div>
    <div>
      <span>
        {if $ConfigureTotal.type.type == '1'}
        {$Lang.customer_discount_price} <span class="discount-num"></span>{$Lang.fracture}
        {elseif $ConfigureTotal.type.type == '2'}
        {$Lang.customer_discount_province} {$ConfigureTotal.currency.prefix}{$ConfigureTotal.type.bates}
        {/if}
      </span>
      <strong>-{$ConfigureTotal.currency.prefix}{:bcsub(bcsub($ConfigureTotal.total,$ConfigureTotal.sale_setupfee_total),$ConfigureTotal.sale_signal_price)}</strong>
    </div>
  </div>
  {/if}

  <div class="configure-summary-total">
    <span>{$Lang.total_price}</span>
    <strong>
      {if !$ConfigureTotal.type}
      {$ConfigureTotal.currency.prefix}{:bcadd($ConfigureTotal.signal_price,$ConfigureTotal.signal_setupfee)}
      {else/}
      {$ConfigureTotal.currency.prefix}{:bcadd($ConfigureTotal.sale_signal_price,$ConfigureTotal.sale_setupfee_total)}
      {/if}
    </strong>
  </div>

  <button type="button" class="configure-submit" id="addToCartBtn">
    <span aria-hidden="true">+</span>{$Lang.add_cart}
  </button>

  <div class="configure-summary-meta">
    <span>价格随配置自动更新</span>
    <a href="{$setting.web_url}/cart?action=viewcart">查看购物车</a>
  </div>
</section>

<div class="configure-mobile-total" aria-label="移动端订单操作">
  <div>
    <span>{$Lang.total_price}</span>
    <strong>
      {if !$ConfigureTotal.type}
      {$ConfigureTotal.currency.prefix}{:bcadd($ConfigureTotal.signal_price,$ConfigureTotal.signal_setupfee)}
      {else/}
      {$ConfigureTotal.currency.prefix}{:bcadd($ConfigureTotal.sale_signal_price,$ConfigureTotal.sale_setupfee_total)}
      {/if}
    </strong>
  </div>
  <button type="button" class="configure-submit" id="addToCartBtnTwo">{$Lang.add_cart}</button>
</div>

<script>
  $(function () {
    var configureProducts = {:json_encode($ConfigureTotal)};

    if ('{$ConfigureTotal.type.type}' === '1') {
      var discountValue = parseFloat(configureProducts.type.bates) / 10;
      $('.discount-num').text(discountValue % 1 === 0 ? discountValue : discountValue.toFixed(2));
    }

    $('#addToCartBtn,#addToCartBtnTwo')
      .off('click.codexOrder')
      .on('click.codexOrder', function () {
        $('#addCartForm .getVal, #addCartForm .getTextareaVal').trigger('blur');

        var invalidCustomField = $('#addCartForm .is-invalid').not('.getPassword').first();
        if (invalidCustomField.length) {
          $('html,body').animate({ scrollTop: Math.max(0, invalidCustomField.offset().top - 100) }, 260);
          if (window.toastr) toastr.error('请完善必填信息');
          return;
        }

        var passwordResult = { flag: true };
        if (
          typeof passwordRules !== 'undefined' &&
          passwordRules !== null &&
          typeof showPassword !== 'undefined' &&
          showPassword == 1 &&
          typeof checkingPwd1 === 'function'
        ) {
          passwordResult = checkingPwd1(
            $('.getPassword').val(),
            passwordRules.num,
            passwordRules.upper,
            passwordRules.lower,
            passwordRules.special
          );
        }

        if (!passwordResult.flag) {
          if (typeof verConfigGPsd === 'function') verConfigGPsd();
          if (window.toastr) toastr.error(passwordResult.msg);
          return;
        }

        $('#addToCartBtn,#addToCartBtnTwo').prop('disabled', true).attr('aria-busy', 'true');
        $('#addCartForm').submit();
      });
  });
</script>
