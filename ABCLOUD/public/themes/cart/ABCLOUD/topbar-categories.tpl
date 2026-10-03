<!-- 桌面端左侧产品分类侧边栏 (水浒云格局) -->
<aside class="nq-cart-side server-desktop-only">
  <div class="nq-cart-side-sticky">
    <!-- 搜索 -->
    <div class="nq-cart-search">
      <div style="position: relative; width: 100%;">
        <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
          style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%); color: #94a3b8; pointer-events: none;">
          <circle cx="11" cy="11" r="8"></circle>
          <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
        <input type="text" id="categorySidebarSearch" name="keywords"
          class="form-control" placeholder="搜索产品..." value="{$Get.keywords|default=''}" autocomplete="off">
      </div>
    </div>

    <!-- 分类菜单 -->
    <nav class="nq-cart-menu" id="nq-cart-nav">
      {if $Cart.product_groups}
      {foreach $Cart.product_groups as $fIndex=>$group}
      {php}
        $fid = isset($Get['fid']) ? $Get['fid'] : '';
        $gid = isset($Get['gid']) ? $Get['gid'] : '';
        $isActive = ($fid == $group['id']) || (!$fid && $fIndex == 0);
        // 刷新或刚进来：默认只开最上面的那一栏 (若指定了当前分类则仅开当前分类，绝对不记忆多开历史)
        $isOpen = $fid ? ($fid == $group['id']) : ($fIndex == 0);
        $gInfo = function_exists('parseGroupName') ? parseGroupName($group['name'], false) : ['name' => $group['name'], 'full' => $group['name']];
      {/php}
      <div class="nq-cart-nav-item nq-cart-nav-group {if $isActive}active{/if} {if $isOpen}open{/if}" data-fid="{$group.id}">
        <a href="javascript:void(0);"
           class="nq-cart-nav-link nq-cart-nav-group-toggle" data-nq-toggle="group">
          <span>{$gInfo.name}</span>
          <svg class="nq-cart-nav-arrow" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="9 18 15 12 9 6"></polyline>
          </svg>
        </a>

        {if isset($group.second) && is_array($group.second) && count($group.second) > 0}
        <div class="nq-cart-nav-sub">
          {foreach $group.second as $sIndex=>$second}
          {php}
            $isSecondActive = $isActive && (($gid == $second['id']) || (!$gid && $sIndex == 0));
            $sInfo = function_exists('parseGroupName') ? parseGroupName($second['name'], false) : ['name' => $second['name'], 'full' => $second['name']];
            $headlineTip = isset($second['headline']) ? htmlspecialchars($second['headline'], ENT_QUOTES, 'UTF-8') : '';
            $isNew = (stripos($second['name'], 'new') !== false || mb_strpos($second['name'], '上新') !== false);
          {/php}
          <div class="nq-cart-nav-item">
            <a href="{$setting.web_url|default=''}/cart?fid={$group.id}&gid={$second.id}"
               class="nq-cart-nav-link nq-cart-nav-sub-link {if $isSecondActive}active{/if}"
               title="{$sInfo.name}{if $headlineTip}（{$headlineTip}）{/if}">
              <span class="nq-cart-nav-flag">{$sInfo.icon|raw}</span>
              <span>{$sInfo.name}</span>
              {if $isNew}
              <span class="nq-cart-nav-tag">new</span>
              {/if}
            </a>
          </div>
          {/foreach}
        </div>
        {/if}
      </div>
      {/foreach}
      {else/}
      <div style="padding: 24px 18px; color: #94a3b8; font-size: 13px;">暂无产品分类</div>
      {/if}
    </nav>
  </div>

  <script>
  (function() {
      // 彻底清理之前的跨刷新记忆缓存，刷新或重新进入时一律不记忆
      try {
          localStorage.removeItem('cart_open_groups');
          sessionStorage.removeItem('cart_open_groups');
      } catch(e) {}

      // 全局捕获一级分类点击：在当前页面上独立切换展开/折叠，不关闭已展开项；但刷新后立即重置
      document.addEventListener('click', function(e) {
          var toggle = e.target.closest('.nq-cart-nav-group-toggle');
          if (!toggle) return;

          e.preventDefault();
          e.stopPropagation();

          var item = toggle.closest('.nq-cart-nav-group');
          if (!item) return;

          item.classList.toggle('open');
      });
  })();
  </script>
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
           style="display: flex; align-items: center; width: 100%; min-height: 44px; padding: 0 12px; border-left: 3px solid {if $isFirstActive}#1677ff{else/}transparent{/if}; color: {if $isFirstActive}#1677ff{else/}#64748b{/if}; background: {if $isFirstActive}#eff6ff{else/}transparent{/if}; font-size: 12px; font-weight: {if $isFirstActive}600{else/}normal{/if}; text-decoration: none; box-sizing: border-box;">
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
          $isNew = (stripos($second['name'], 'new') !== false || mb_strpos($second['name'], '上新') !== false);
        {/php}
        <a href="{$setting.web_url|default=''}/cart?fid={$group.id}&gid={$second.id}"
           class="cscart-mobile-second-item {if $isSecondActive}active{/if}"
           title="{$sInfo.name}{if $headlineTip}（{$headlineTip}）{/if}"
           style="display: flex; align-items: center; min-height: 42px; padding: 0 12px; border-bottom: 1px solid #f1f5f9; color: {if $isSecondActive}#1677ff{else/}#334155{/if}; background: {if $isSecondActive}#eff6ff{else/}#fff{/if}; font-weight: {if $isSecondActive}700{else/}normal{/if}; text-decoration: none; font-size: 13px;">
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
