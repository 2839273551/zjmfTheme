{include file="themes/cart/ABCLOUD/header.tpl" title="购物车结算" /}
<!-- 核心交互依赖 (必须在 viewcart.tpl 内联脚本执行前载入) -->
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/jquery/jquery.min.js?v=3.0.0"></script>
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/bootstrap/js/bootstrap.bundle.min.js?v=3.0.0"></script>
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/toastr/build/toastr.min.js?v=3.0.0"></script>
<link rel="stylesheet" href="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/toastr/build/toastr.min.css?v=3.0.0">
<link rel="stylesheet" href="/themes/cart/ABCLOUD/vendor/clientarea/assets/css/icons.min.css?v=3.0.0">
<link rel="stylesheet" href="/themes/cart/ABCLOUD/assets/css/viewcart.css?v=3.0.0">

<main class="store-main-container viewcart-page-main">
  <div class="viewcart-layout-wrap">

    <!-- 顶部步骤指示条 (Stepper) -->
    <div class="viewcart-stepper-card">
      <div class="viewcart-stepper">
        <a href="{$setting.web_url|default=''}/cart" class="step-item is-completed">
          <span class="step-num">✓</span>
          <span class="step-text">选择产品规格</span>
        </a>
        <div class="step-divider"></div>
        <div class="step-item is-completed">
          <span class="step-num">✓</span>
          <span class="step-text">配置业务参数</span>
        </div>
        <div class="step-divider"></div>
        <div class="step-item is-active">
          <span class="step-num">3</span>
          <span class="step-text">确认订单结账</span>
        </div>
      </div>
    </div>

    <!-- 头部栏与返回选购 -->
    <div class="viewcart-header-card">
      <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px;">
        <div>
          <a href="{$setting.web_url|default=''}/cart" class="viewcart-back-link">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
            返回产品大厅选购
          </a>
          <h1 class="viewcart-title">确认订单与结算</h1>
        </div>
        <div class="viewcart-trust-badge" style="display: inline-flex; align-items: center; gap: 6px; color: #059669; font-size: 13px; font-weight: 600; background: #ecfdf5; padding: 6px 14px; border-radius: 20px; border: 1px solid #a7f3d0;">
          <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
          官方安全加密支付通道
        </div>
      </div>
    </div>

    <!-- 原生结算表单深度美化工作区 -->
    <div class="viewcart-workspace">
      {include file="themes/cart/ABCLOUD/native/viewcart.tpl" /}
    </div>

    <!-- 增强注册与登录模式切换平滑监听 -->
    <script>
      $(document).ready(function() {
        // 监听“手机注册 / 邮箱注册”切换（彻底消灭邮箱模式下手机号残留问题）
        $(document).on('click', '#register .btn', function(e) {
          var $input = $(this).find('input');
          $('#register input').removeClass('input_active');
          $input.addClass('input_active');
          var type = $input.val();
          if (type === 'email') {
            $('.registerphone').hide().find('input, select, button').attr('disabled', 'disabled');
            $('.registeremail').show().find('input, button').removeAttr('disabled');
          } else {
            $('.registeremail').hide().find('input, button').attr('disabled', 'disabled');
            $('.registerphone').show().find('input, select, button').removeAttr('disabled');
          }
        });

        // 监听“手机登录 / 邮箱登录”切换
        $(document).on('click', '#login .btn', function(e) {
          var $input = $(this).find('input');
          $('#login input').removeClass('input_active');
          $input.addClass('input_active');
          var type = $input.val();
          if (type === 'email') {
            $('.loginphone').hide().find('input, select, button').attr('disabled', 'disabled');
            $('.loginemail').show().find('input, button').removeAttr('disabled');
          } else {
            $('.loginemail').hide().find('input, button').attr('disabled', 'disabled');
            $('.loginphone').show().find('input, select, button').removeAttr('disabled');
          }
        });
      });
    </script>

  </div>
</main>

{include file="themes/cart/ABCLOUD/footer.tpl" /}
