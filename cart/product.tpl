{include file="themes/web/codex_framework/static/cart/header.html" title="产品中心" /}
<link rel="stylesheet" href="/themes/cart/codex_framework/assets/css/cart.css?v=1.0.1">

<main class="store" id="cart-content">
  <div class="store-shell">
    {include file="cart/codex_framework/topbar-categories"}

    <section class="store-main">
      <button class="store-mobile-menu" type="button" aria-expanded="false" data-category-toggle>
        <span>产品菜单</span>
        <strong>{$Cart.product_groups_checked.name|default="全部产品"}</strong>
        <span aria-hidden="true">›</span>
      </button>

      {if !$Userinfo}
      <section class="store-login-banner" aria-label="登录提示">
        <div class="store-login-icon" aria-hidden="true">ID</div>
        <div>
          <strong>登录后查看账户专属价格</strong>
          <p>结合您的账户等级与优惠信息展示实际可获得的价格。</p>
        </div>
        <a class="store-button store-button-primary" href="{$setting.web_url}/login">立即登录</a>
      </section>
      {/if}

      <header class="store-current-group">
        <span class="store-current-icon" aria-hidden="true">⌘</span>
        <span>产品类型：</span>
        <strong>{$Cart.product_groups_checked.name|default="全部产品"}</strong>
      </header>

      {if $Cart.product_groups_checked.headline}
      <p class="store-group-summary">{$Cart.product_groups_checked.headline}</p>
      {/if}

      {if $Cart.products}
      <div class="store-product-grid" data-product-grid>
        {foreach $Cart.products as $list}
        <article class="store-product-card" data-product-card>
          <header class="store-product-header">
            <div>
              <span class="store-product-id">产品 ID {$list.id}</span>
              <h2>{$list.name}</h2>
            </div>
            {if $list.stock_control==1 && $list.qty<1}
            <span class="store-stock is-empty">已售罄</span>
            {elseif $list.stock_control==1}
            <span class="store-stock">库存 {$list.qty}</span>
            {else/}
            <span class="store-stock">库存充足</span>
            {/if}
          </header>

          <div class="store-product-specs">{$list.description}</div>

          {if $list.ontrial==1}
          <p class="store-trial">
            {$Lang.on_trial|default="试用"}：{$Cart.currency.prefix}{$list.ontrial_setup_fee+$list.ontrial_price}
            / {$list.ontrial_cycle}{$list.ontrial_cycle_type == 'day' ? $Lang.day : $Lang.hour}
          </p>
          {/if}

          <footer class="store-product-footer">
            <div class="store-price-block">
              {if $list.sale_price>0}
              <span class="store-price-label">促销价</span>
              <div>
                <strong>{$Cart.currency.prefix}{$list.sale_price}</strong>
                <span>起 / {$list.billingcycle_zh}</span>
              </div>
              <del>原价 {$Cart.currency.prefix}{$list.product_price}</del>
              {else/}
              <span class="store-price-label">当前价格</span>
              <div>
                <strong>{$Cart.currency.prefix}{$list.product_price}</strong>
                <span>起 / {$list.billingcycle_zh}</span>
              </div>
              {/if}
            </div>

            {if $list.stock_control==1 && $list.qty<1}
            <button class="store-button store-buy-button" type="button" disabled>暂时售罄</button>
            {else/}
            <a class="store-button store-button-primary store-buy-button"
               href="{$setting.web_url}/cart?action=configureproduct&pid={$list.id}{if $Get.site}&site={$Get.site}{/if}">
              {$Lang.buy_now|default="立即购买"}
            </a>
            {/if}
          </footer>
        </article>
        {/foreach}
      </div>

      <div class="store-search-empty" data-search-empty hidden>
        <strong>没有找到匹配的商品</strong>
        <p>请更换关键词或切换其他产品分类。</p>
      </div>

      {if $Pages}
      <nav class="store-pagination" aria-label="商品分页">
        <ul class="pagination pagination-sm">{$Pages}</ul>
      </nav>
      {/if}
      {else/}
      <div class="store-empty">
        <strong>当前分类暂无可售商品</strong>
        <p>请切换产品分类，或联系售前确认上架状态。</p>
        <a class="store-button" href="{$setting.web_url}/cart">返回全部产品</a>
      </div>
      {/if}

      {if $CustomDepot.cart_gg}
      <section class="store-notice">
        <strong>服务使用须知</strong>
        <div>{$CustomDepot.cart_gg}</div>
      </section>
      {/if}
    </section>
  </div>

  <button class="store-category-overlay" type="button" aria-label="关闭产品菜单" data-category-overlay></button>
</main>

<script src="/themes/cart/codex_framework/assets/js/cart.js?v=1.0.1"></script>
{include file="themes/web/codex_framework/static/cart/footer.html"/}
