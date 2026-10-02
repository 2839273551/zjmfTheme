{include file="themes/cart/ABCLOUD/header.tpl" title="配置产品" /}
<!-- 配置页核心依赖 (jQuery / Bootstrap / Toastr) -->
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/jquery/jquery.min.js?v=3.0.0"></script>
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/bootstrap/js/bootstrap.bundle.min.js?v=3.0.0"></script>
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/toastr/build/toastr.min.js?v=3.0.0"></script>
<link rel="stylesheet" href="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/toastr/build/toastr.min.css?v=3.0.0">
<link rel="stylesheet" href="/themes/cart/ABCLOUD/assets/css/configure.css?v=3.0.0">

<main class="store-main-container configure-page-main">
  <div class="configure-layout-wrap">

    <!-- 顶部步骤指示条 (Stepper) -->
    <div class="configure-stepper-card">
      <div class="configure-stepper">
        <a href="{$setting.web_url|default=''}/cart" class="step-item is-completed">
          <span class="step-num">✓</span>
          <span class="step-text">选择产品规格</span>
        </a>
        <div class="step-divider"></div>
        <div class="step-item is-active">
          <span class="step-num">2</span>
          <span class="step-text">配置业务参数</span>
        </div>
        <div class="step-divider"></div>
        <div class="step-item is-pending">
          <span class="step-num">3</span>
          <span class="step-text">确认订单结账</span>
        </div>
      </div>
    </div>

    <!-- 当前产品主标题与返回栏 -->
    <div class="configure-header-card">
      <a href="{$setting.web_url|default=''}/cart" class="configure-back-link">
        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
        返回产品大厅
      </a>
      <h1 class="configure-product-title">{$CartConfig.product.name|default='配置产品'}</h1>
      {if isset($CartConfig.product.description) && $CartConfig.product.description}
      <div class="configure-product-desc">
        {$CartConfig.product.description}
      </div>
      {/if}
    </div>

    <!-- 业务错误强提醒横幅 (防止由于任何验证拦截导致不跳转时用户无感知) -->
    {if isset($ErrorMsg) && $ErrorMsg}
    <div class="configure-error-banner alert alert-danger" style="margin-bottom: 24px; border-radius: 10px; display: flex; align-items: center; justify-content: space-between; padding: 16px 20px; background: #fef2f2; border: 1.5px solid #fecaca; box-shadow: 0 4px 12px rgba(239, 68, 68, 0.08);">
      <div style="display: flex; align-items: center; gap: 12px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
        <span id="configureErrorMessage" style="font-size: 14px; font-weight: 600; color: #991b1b;">{$ErrorMsg|htmlspecialchars}</span>
      </div>
      <div style="display: flex; gap: 10px;">
        <a href="{$setting.web_url|default=''}/login" class="btn btn-sm btn-primary" style="border-radius: 6px; font-size: 12px; padding: 6px 14px;">立即登录</a>
        <a href="{$setting.web_url|default=''}/register" class="btn btn-sm btn-outline-danger" style="border-radius: 6px; font-size: 12px; padding: 6px 14px; border-color: #ef4444; color: #ef4444;">免费注册</a>
      </div>
    </div>
    <script>
      $(document).ready(function() {
        if (typeof toastr !== 'undefined') {
          toastr.error(document.getElementById('configureErrorMessage').textContent, '', {escapeHtml: true});
        }
      });
    </script>
    {/if}

    <!-- 游客选购贴心提示 -->
    {if !$Userinfo && !$userInfo}
    <div class="configure-guest-tip" style="margin-bottom: 20px; padding: 12px 18px; background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 8px; display: flex; align-items: center; justify-content: space-between; font-size: 13px; color: #1e40af;">
      <div style="display: flex; align-items: center; gap: 8px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
        <span>您当前以访客身份配置，点击“加入购物车”后将直接进入结算中心快速结账或登录。</span>
      </div>
      <div>
        <a href="{$setting.web_url|default=''}/login" style="color: #2563eb; font-weight: 600; text-decoration: underline;">已有账号？点此登录</a>
      </div>
    </div>
    {/if}

    <!-- 原生表单深度美化工作区 -->
    <div class="abcloud-config-workspace">
      {include file="themes/cart/ABCLOUD/native/configureproduct.tpl" /}
    </div>

  </div>
</main>

{include file="themes/cart/ABCLOUD/footer.tpl" /}
