{include file="themes/cart/ABCLOUD/header.tpl" title="配置产品" /}
<!-- 配置页核心依赖 (jQuery / Bootstrap / Toastr) -->
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/jquery/jquery.min.js?v=3.0.0"></script>
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/bootstrap/js/bootstrap.bundle.min.js?v=3.0.0"></script>
<script src="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/toastr/build/toastr.min.js?v=3.0.0"></script>
<link rel="stylesheet" href="/themes/cart/ABCLOUD/vendor/clientarea/assets/libs/toastr/build/toastr.min.css?v=3.0.0">
<link rel="stylesheet" href="/themes/cart/ABCLOUD/assets/css/configure.css?v=3.0.0">

<main class="store-main-container">
  <div class="nq-cart">
    <!-- 1. 左侧：商品列表/分类侧边栏（常驻贴左） -->
    {include file="themes/cart/ABCLOUD/topbar-categories.tpl" /}

    <!-- 2. 右侧：动态产品配置区域 -->
    <section class="nq-cart-main nq-cart-main--config" id="cart-content">
      <!-- 雾透居中悬浮加载动画 (切换产品或分类时优雅展示) -->
      <div class="nq-floating-loading" id="nqFloatingLoading">
        <div class="nq-floating-loading-dialog">
          <div class="loading-42"></div>
          <span class="nq-floating-loading-text">正在加载产品配置...</span>
        </div>
      </div>

      <!-- 登录后查看专属优惠价格 (未登录展示) -->
      {php}
        $isCartLoggedIn = !empty($Userinfo['user']['id']) || !empty($Userinfo['id']) || !empty($userInfo['id']);
      {/php}
      {if !$isCartLoggedIn}
      <div class="nq-cart-login">
        <svg class="nq-cart-login-icon" viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
          <polyline points="9 12 11 14 15 10"></polyline>
        </svg>
        <div class="nq-cart-login-text">
          <span class="nq-cart-login-title">登录后查看专属优惠价格</span>
          <span class="nq-cart-login-desc">结合您的账号情况展示您可实际获得的优惠价格</span>
        </div>
        <a href="{$setting.web_url|default=''}/login" class="btn btn-primary btn-sm nq-cart-login-btn">立即登录 <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-left:4px;"><polyline points="9 18 15 12 9 6"></polyline></svg></a>
      </div>
      {/if}

      <!-- 错误提示横幅 -->
      {if isset($ErrorMsg) && $ErrorMsg}
      <div class="alert alert-danger" style="margin-bottom: 16px; border-radius: 6px; display: flex; align-items: center; justify-content: space-between;">
        <span id="configureErrorMessage">{$ErrorMsg|htmlspecialchars}</span>
        <a href="{$setting.web_url|default=''}/login" class="btn btn-sm btn-primary">去登录</a>
      </div>
      <script>
        $(document).ready(function() {
          if (typeof toastr !== 'undefined') {
            toastr.error('{$ErrorMsg|htmlspecialchars}');
          }
        });
      </script>
      {/if}

      <!-- 原生表单深度包装与左右联动工作区 -->
      <div class="abcloud-config-workspace">
        {include file="themes/cart/ABCLOUD/native/configureproduct.tpl" /}
      </div>
    </section>
  </div>
</main>

{include file="themes/cart/ABCLOUD/footer.tpl" /}
