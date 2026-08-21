{assign name="configure_page" value="1" /}
{include file="themes/web/codex_framework/static/cart/header.html" title="配置产品" /}
<link rel="stylesheet" href="/themes/cart/codex_framework/assets/css/configure.css?v=1.0.0">
<script src="/themes/cart/codex_framework/assets/js/configure.js?v=1.0.0"></script>

<main class="configure-page main-content" id="cart-content">
  <header class="configure-heading">
    <div class="cloud-shell configure-heading-inner">
      <div class="configure-title">
        <a href="{$setting.web_url}/cart">返回产品中心</a>
        <span>产品 ID {$CartConfig.product.id}</span>
        <h1>{$CartConfig.product.name}</h1>
      </div>

      <ol class="configure-steps" aria-label="订购进度">
        <li class="is-complete"><span>1</span>选择产品</li>
        <li class="is-current" aria-current="step"><span>2</span>配置参数</li>
        <li><span>3</span>确认购物车</li>
      </ol>
    </div>
  </header>

  <section class="cloud-shell configure-workspace" aria-label="产品配置">
    <div class="configure-native">
      {include file="themes/cart/default/configureproduct.tpl" /}
    </div>
  </section>
</main>

{include file="themes/web/codex_framework/static/cart/footer.html"/}
