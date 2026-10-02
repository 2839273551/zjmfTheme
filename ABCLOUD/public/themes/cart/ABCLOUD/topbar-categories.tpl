<!-- 桌面端左侧产品分类侧边栏 -->
<aside class="server-cart-sidebar server-desktop-only">
  <div class="server-cart-sidebar-search">
    <div style="position: relative; width: 100%;">
      <input type="text" id="categorySidebarSearch"
        placeholder="搜索产品..." value="{$Get.keywords|default=''}" autocomplete="off">
      <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
        style="position: absolute; left: 11px; top: 11px; color: #94a3b8; pointer-events: none;">
        <circle cx="11" cy="11" r="8"></circle>
        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
      </svg>
    </div>
  </div>

  <div class="server-cart-categories">
    {if $Cart.product_groups}
    {foreach $Cart.product_groups as $fIndex=>$group}
    {php}
      $fid = isset($Get['fid']) ? $Get['fid'] : '';
      $gid = isset($Get['gid']) ? $Get['gid'] : '';
      $isFirstActive = ($fid == $group['id']) || (!$fid && $fIndex == 0);
      $gInfo = function_exists('parseGroupName') ? parseGroupName($group['name'], false) : ['name' => $group['name'], 'full' => $group['name']];
    {/php}
    <div class="server-cart-category {if $isFirstActive}is-open{/if}">
      <a href="{$setting.web_url|default=''}/cart?fid={$group.id}{if isset($group.second.0.id)}&gid={$group.second.0.id}{/if}"
         class="server-cart-category-title {if $isFirstActive}active{/if}">
        <span class="category-title-left">
          {$gInfo.icon|raw}
          <span class="category-name-text">{$gInfo.name}</span>
        </span>
        <svg class="category-arrow" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <polyline points="9 18 15 12 9 6"></polyline>
        </svg>
      </a>

      {if $isFirstActive && isset($group.second) && is_array($group.second) && count($group.second) > 0}
      <div class="server-cart-subcategories">
        {foreach $group.second as $sIndex=>$second}
        {php}
          $isSecondActive = ($gid == $second['id']) || (!$gid && $sIndex == 0);
          $sInfo = function_exists('parseGroupName') ? parseGroupName($second['name'], false) : ['name' => $second['name'], 'full' => $second['name']];
          $headlineTip = isset($second['headline']) ? htmlspecialchars($second['headline'], ENT_QUOTES, 'UTF-8') : '';
        {/php}
        <a href="{$setting.web_url|default=''}/cart?fid={$group.id}&gid={$second.id}"
           class="server-cart-subcategory {if $isSecondActive}active{/if}"
           title="{$sInfo.name}{if $headlineTip}（{$headlineTip}）{/if}">
          <span class="subcategory-title-inner">
            {$sInfo.icon|raw}
            <span class="subcategory-name-text">{$sInfo.name}</span>
          </span>
        </a>
        {/foreach}
      </div>
      {/if}
    </div>
    {/foreach}
    {else/}
    <div style="padding: 24px 18px; color: #94a3b8; font-size: 13px;">暂无产品分类</div>
    {/if}
  </div>
</aside>

<!-- 移动端产品分类抽屉（可在手机端滑出） -->
<div class="cscart-mobile-drawer-wrap" id="mobileDrawerWrap" style="display: none;">
  <div class="cscart-mobile-drawer-backdrop" id="mobileDrawerBackdrop"></div>
  <aside class="cscart-mobile-drawer" id="mobileDrawer">
    <header class="cscart-mobile-drawer-header">
      <strong>产品分类</strong>
      <button type="button" id="closeDrawerBtn" aria-label="关闭">✕</button>
    </header>
    <div class="cscart-mobile-drawer-body">
      {if $Cart.product_groups}
      <!-- 左侧一级分组列表 -->
      <div class="cscart-mobile-first-groups">
        {foreach $Cart.product_groups as $fIndex=>$group}
        {php}
          $fid = isset($Get['fid']) ? $Get['fid'] : '';
          $isFirstActive = ($fid == $group['id']) || (!$fid && $fIndex == 0);
          $gInfo = function_exists('parseGroupName') ? parseGroupName($group['name'], false) : ['name' => $group['name'], 'full' => $group['name']];
        {/php}
        <a href="{$setting.web_url|default=''}/cart?fid={$group.id}{if isset($group.second.0.id)}&gid={$group.second.0.id}{/if}"
           class="{if $isFirstActive}active{/if}"
           style="display: flex; align-items: center; width: 100%; min-height: 44px; padding: 0 12px; border-left: 3px solid {if $isFirstActive}var(--cscart-primary, #1a56db){else/}transparent{/if}; color: {if $isFirstActive}var(--cscart-primary, #1a56db){else/}#64748b{/if}; background: {if $isFirstActive}#eff6ff{else/}transparent{/if}; font-size: 12px; font-weight: {if $isFirstActive}600{else/}normal{/if}; text-decoration: none; box-sizing: border-box;">
          <span>{$gInfo.full|raw}</span>
        </a>
        {/foreach}
      </div>

      <!-- 右侧二级分组列表：高度对齐，统一展示 -->
      <div class="cscart-mobile-second-groups">
        {foreach $Cart.product_groups as $fIndex=>$group}
        {php}
          $fid = isset($Get['fid']) ? $Get['fid'] : '';
          $gid = isset($Get['gid']) ? $Get['gid'] : '';
          $isFirstActive = ($fid == $group['id']) || (!$fid && $fIndex == 0);
        {/php}
        {if $isFirstActive && isset($group.second) && is_array($group.second)}
        {foreach $group.second as $sIndex=>$second}
        {php}
          $isSecondActive = ($gid == $second['id']) || (!$gid && $sIndex == 0);
          $sInfo = function_exists('parseGroupName') ? parseGroupName($second['name'], false) : ['name' => $second['name'], 'full' => $second['name']];
          $headlineTip = isset($second['headline']) ? htmlspecialchars($second['headline'], ENT_QUOTES, 'UTF-8') : '';
        {/php}
        <a href="{$setting.web_url|default=''}/cart?fid={$group.id}&gid={$second.id}"
           class="cscart-mobile-second-item {if $isSecondActive}active{/if}"
           title="{$sInfo.name}{if $headlineTip}（{$headlineTip}）{/if}"
           style="display: flex; align-items: center; min-height: 42px; padding: 0 12px; border-bottom: 1px solid #f1f5f9; color: {if $isSecondActive}var(--cscart-primary, #1a56db){else/}#334155{/if}; background: {if $isSecondActive}#eff6ff{else/}#fff{/if}; font-weight: {if $isSecondActive}700{else/}normal{/if}; text-decoration: none; font-size: 13px;">
          <span style="display: inline-flex; align-items: center; gap: 6px;">
            {$sInfo.icon|raw}
            <span>{$sInfo.name}</span>
          </span>
        </a>
        {/foreach}
        {/if}
        {/foreach}
      </div>
      {/if}
    </div>
  </aside>
</div>
