{include file="themes/cart/ABCLOUD/header.tpl" title="产品中心" /}

<main class="store-main-container">
  <div class="server-cart-layout">
    {include file="themes/cart/ABCLOUD/topbar-categories.tpl" /}

    <section class="server-cart-content" id="cart-content">
      <!-- 移动端顶部触发卡片与快捷登录 -->
      <div class="cscart-mobile-portal server-mobile-only">
        {if !$Userinfo && !$userInfo}
        <section class="cscart-mobile-login">
          <div style="display: flex; align-items: center; gap: 8px;">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--cscart-primary, #1a56db);"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
            <strong style="font-size: 13px; color: #1e293b;">登录查看专属价格</strong>
          </div>
          <a href="{$setting.web_url|default=''}/login" class="promo-btn" style="padding: 4px 14px; font-size: 12px; height: 28px;">立即登录</a>
        </section>
        {/if}

        {php}
          $rawCheckedName = isset($Cart['product_groups_checked']['name']) ? $Cart['product_groups_checked']['name'] : '全部产品';
          $heroInfo = function_exists('parseGroupName') ? parseGroupName($rawCheckedName, true) : ['name' => $rawCheckedName, 'full' => $rawCheckedName];
        {/php}
        <button type="button" class="cscart-mobile-menu-trigger" id="mobileCatTrigger">
          <span style="display: flex; align-items: center; gap: 6px;">
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
            <b>产品分类</b>
          </span>
          <span style="color: var(--cscart-primary, #1a56db); font-weight: 600;">{$heroInfo.full|raw}</span>
          <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
        </button>
      </div>

      <!-- 桌面端分组标题与说明卡片 -->
      <div class="cart-hero-card server-desktop-only">
        <div class="cart-hero-badge">
          <span class="badge-dot"></span>
          <span>云计算产品选购</span>
        </div>
        <h1 class="cart-hero-title">{$heroInfo.full|raw}</h1>
        {if isset($Cart.product_groups_checked.headline) && $Cart.product_groups_checked.headline}
        <div class="cart-hero-notice">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="notice-icon"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
          <span>{$Cart.product_groups_checked.headline}</span>
        </div>
        {/if}
      </div>

      <div class="main-card">
        <!-- 未登录提示卡片：紧凑单行横条 -->
        {if !$Userinfo && !$userInfo}
        <section class="cart-login-promo server-desktop-only">
          <div class="promo-left">
            <div class="promo-icon" aria-hidden="true">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
            </div>
            <div class="promo-text">
              <strong>登录后查看专属优惠价</strong>
              <span>根据您的账户等级与专享优惠资格展示实际结算价格</span>
            </div>
          </div>
          <a href="{$setting.web_url|default=''}/login" class="promo-btn">立即登录</a>
        </section>
        {/if}

        <!-- 顶部工具栏：产品数量统计与搜索输入框单行左右对齐 -->
        <div class="cart-toolbar server-desktop-only">
          <div class="toolbar-left">
            <span class="count-pill">当前分类共有 <strong>{:count($Cart.products)}</strong> 款在售产品</span>
          </div>
          <div class="toolbar-right">
            <div class="cart-search-box">
              <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="search-svg"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
              <input type="text" id="cartProductSearch" placeholder="搜索当前分类商品..." autocomplete="off">
            </div>
          </div>
        </div>

        <!-- 产品网格 -->
        <div class="shopping-box">
          {if $Cart.products}
          <div class="server-product-grid" id="productGrid">
            {foreach $Cart.products as $list}
            <article class="server-product-card {if $list.has_bates}is-featured{/if}" data-name="{$list.name}">
              <header class="server-product-header">
                <div>
                  <h2 class="server-product-title">{$list.name}</h2>
                </div>
                {if $list.has_bates}
                <span class="server-product-featured-badge">特惠</span>
                {/if}
                {if $list.stock_control == 1 && $list.qty < 1}
                <span class="server-product-stock is-empty">售罄</span>
                {elseif $list.stock_control == 1/}
                <span class="server-product-stock">库存 {$list.qty}</span>
                {else/}
                <span class="server-product-stock">库存充足</span>
                {/if}
              </header>

              <div class="server-product-body">
                <div class="server-product-description">
                  <pre>{$list.description}</pre>
                </div>

                {if $list.ontrial == 1}
                <p class="server-product-trial">
                  {$Lang.on_trial|default="试用"}：{$Cart.currency.prefix}{$list.ontrial_setup_fee+$list.ontrial_price} / {$list.ontrial_cycle}{$list.ontrial_cycle_type == 'day' ? $Lang.day : $Lang.hour}
                </p>
                {/if}

                <div class="server-product-footer">
                  <div class="server-product-price">
                    {if $list.has_bates}
                    <span class="server-product-currency">{$Cart.currency.prefix}</span>
                    <strong>{$list.sale_price}</strong>
                    <span>起 / {$list.billingcycle_zh}</span>
                    <del>{$Cart.currency.prefix}{$list.product_price}</del>
                    {else/}
                    <span class="server-product-currency">{$Cart.currency.prefix}</span>
                    <strong>{$list.product_price}</strong>
                    <span>起 / {$list.billingcycle_zh}</span>
                    {/if}
                  </div>

                  {if $list.stock_control == 1 && $list.qty < 1}
                  <button type="button" class="cart-buy-btn is-soldout" disabled>暂时售罄</button>
                  {else/}
                  <a href="{$setting.web_url|default=''}/cart?action=configureproduct&pid={$list.id}{if $Get.site}&site={$Get.site}{/if}" class="cart-buy-btn is-active">
                    {$Lang.buy_now|default="立即购买"}
                  </a>
                  {/if}
                </div>
              </div>
            </article>
            {/foreach}
          </div>

          <!-- 搜索空状态 -->
          <div class="no-goods" id="searchEmptyState" style="display: none; text-align: center; padding: 60px 0;">
            <p style="color: #8c9ba5; font-size: 15px;">没有找到匹配的商品，请更换关键词</p>
          </div>

          {if $Pages}
          <nav class="store-pagination" style="margin-top: 30px; display: flex; justify-content: center;">
            <ul class="pagination pagination-sm">{$Pages}</ul>
          </nav>
          {/if}

          {else/}
          <!-- 分类下无商品 -->
          <div class="no-goods" style="text-align: center; padding: 80px 0; background: #ffffff; border-radius: 10px; border: 1px solid #e2e8f0;">
            <p style="color: #8c9ba5; font-size: 16px; margin-bottom: 20px;">当前分类暂无可售商品</p>
            <a href="{$setting.web_url|default=''}/cart" class="cart-buy-btn is-active" style="padding: 10px 24px;">查看全部产品</a>
          </div>
          {/if}

          <!-- 购买须知 -->
          {if isset($CustomDepot.cart_gg) && $CustomDepot.cart_gg}
          <div class="cscart-purchase-notice">
            <div style="font-weight: 700; color: #1e293b; margin-bottom: 8px; display: flex; align-items: center; gap: 8px; font-size: 14px;">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: #f59e0b;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
              购买须知
            </div>
            <div style="font-size: 13px; color: #64748b; line-height: 1.7;">
              {$CustomDepot.cart_gg}
            </div>
          </div>
          {/if}
        </div>
      </div>
    </section>
  </div>
</main>

{include file="themes/cart/ABCLOUD/footer.tpl" /}
