{include file="themes/cart/ABCLOUD/header.tpl" title="产品中心" /}

<main class="store-main-container">
  <div class="nq-cart">
    {include file="themes/cart/ABCLOUD/topbar-categories.tpl" /}

    <section class="nq-cart-main" id="cart-content">
      <!-- 1. 登录后查看专属优惠价格 (未登录展示) -->
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

      <!-- 2. 产品类型横条 -->
      {php}
        $rawCheckedName = isset($Cart['product_groups_checked']['name']) ? $Cart['product_groups_checked']['name'] : '全部产品';
        $heroInfo = function_exists('parseGroupName') ? parseGroupName($rawCheckedName, true) : ['name' => $rawCheckedName, 'full' => $rawCheckedName];
      {/php}
      <div class="nq-cart-group-heading" id="nq-group-heading">
        <svg class="nq-cart-group-heading-icon" viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
          <rect x="3" y="3" width="7" height="7" rx="1.5"></rect>
          <rect x="14" y="3" width="7" height="7" rx="1.5"></rect>
          <rect x="3" y="14" width="7" height="7" rx="1.5"></rect>
          <rect x="14" y="14" width="7" height="7" rx="1.5"></rect>
        </svg>
        <span class="nq-cart-group-heading-label">产品类型：</span>
        <strong class="nq-cart-group-heading-name">{$heroInfo.name}</strong>
      </div>

      <!-- 3. 公告/说明横条 (有 headline 时展示) -->
      {if isset($Cart.product_groups_checked.headline) && $Cart.product_groups_checked.headline}
      <div class="nq-cart-notice-bar nq-cart-notice-bar--info" id="nq-group-notice">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink:0;margin-top:3px;">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="12" y1="8" x2="12" y2="12"></line>
          <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
        <span>{$Cart.product_groups_checked.headline}</span>
      </div>
      {/if}

      <!-- 雾透居中悬浮加载动画 (悬浮在屏幕正中间，不占用文档流高度，绝不引起上下跳动) -->
      <div class="nq-floating-loading" id="nqFloatingLoading">
        <div class="nq-floating-loading-dialog">
          <div class="loading-42"></div>
          <span class="nq-floating-loading-text">正在加载产品配置...</span>
        </div>
      </div>

      <!-- 4. 商品卡片网格列表 (水浒云 4 列格局 + 原生商品信息与彩色图标规格) -->
      <div id="nq-product-list">
        {if $Cart.products}
        <div class="nq-product-grid" id="productGrid">
          {foreach $Cart.products as $list}
          <div class="nq-product-card" data-name="{$list.name}">
            <!-- 头部：名称 + 库存 -->
            <div class="nq-product-header">
              <h5 class="nq-product-name" title="{$list.name}">{$list.name}</h5>
              {if $list.stock_control == 1 && $list.qty < 1}
              <span class="nq-product-stock out-stock">售罄</span>
              {elseif $list.stock_control == 1 && $list.qty <= 5/}
              <span class="nq-product-stock low-stock">库存 {$list.qty}</span>
              {else/}
              <span class="nq-product-stock in-stock">库存充足</span>
              {/if}
            </div>

            <!-- 描述：标准 config-row 规格 -->
            <div class="nq-product-desc">
              {php}
                echo renderShuidcSpecs($list['description']);
              {/php}
            </div>

            <!-- 价格 + 操作 -->
            <div class="nq-product-footer">
              <div class="nq-product-pricing">
                <span class="nq-price-current">
                  {$Cart.currency.prefix|default='¥'}{$list.product_price}<small> 起 / {$list.billingcycle_zh|default='月'}</small>
                </span>
              </div>
              {if $list.stock_control == 1 && $list.qty < 1}
              <button type="button" class="btn nq-btn-soldout btn-block" disabled>暂时售罄</button>
              {else/}
              <a href="{$setting.web_url|default=''}/cart?action=configureproduct&pid={$list.id}{if $Get.site}&site={$Get.site}{/if}"
                 class="btn btn-primary btn-block nq-buy-btn">
                <span class="btn-text">立即购买</span>
                <span class="btn-loading"><span class="nq-spinner"></span> 正在前往配置...</span>
              </a>
              {/if}
            </div>
          </div>
          {/foreach}
        </div>

        <!-- 搜索空状态 -->
        <div class="nq-cart-empty" id="searchEmptyState" style="display: none !important;">
          <div class="nq-cart-empty-inner">
            <p class="nq-cart-empty-text">没有找到匹配的商品，请更换关键词</p>
          </div>
        </div>

        {if $Pages}
        <nav class="store-pagination" style="margin-top: 30px; display: flex; justify-content: center;">
          <ul class="pagination pagination-sm">{$Pages}</ul>
        </nav>
        {/if}

        {else/}
        <!-- 分类下无商品 -->
        <div class="nq-cart-empty">
          <div class="nq-cart-empty-inner">
            <p class="nq-cart-empty-text" style="font-size: 15px; margin-bottom: 16px;">当前分类暂无可售商品</p>
            <a href="{$setting.web_url|default=''}/cart" class="btn btn-primary" style="padding: 8px 24px;">查看全部产品</a>
          </div>
        </div>
        {/if}
      </div>

      <!-- 5. 底部服务使用须知 -->
      <div class="nq-cart-notice">
        <div class="nq-cart-notice-header">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" style="margin-right:4px;">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
            <polyline points="14 2 14 8 20 8"></polyline>
            <line x1="16" y1="13" x2="8" y2="13"></line>
            <line x1="16" y1="17" x2="8" y2="17"></line>
            <polyline points="10 9 9 9 8 9"></polyline>
          </svg>
          <span>服务使用须知</span>
        </div>
        <div class="nq-cart-notice-body">
          {if isset($CustomDepot.cart_gg) && $CustomDepot.cart_gg}
            {$CustomDepot.cart_gg|raw}
          {else/}
            机房禁止用于以下业务及服务：无支付牌照的第三方及第四方支付，易支付，发卡，卡盟，影视，代刷，代挂，刷信誉，买号，卖号，商城，钓鱼网站，虚拟充值，外挂辅助相关网，CC网顶端，DDOS网顶端，短信轰炸，赌博网站，云免网，诈骗网，赌博网，色情网，小说网，等等相关违法违规站点。禁止搭建VPN服务、禁止搭建DNS服务、禁止搭建NTP服务 以上业务及服务一经发现，立即永久关闭。
          {/if}
        </div>
      </div>
    </section>
  </div>
</main>

{include file="themes/cart/ABCLOUD/footer.tpl" /}
