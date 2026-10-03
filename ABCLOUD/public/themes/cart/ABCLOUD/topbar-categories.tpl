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

      // 智能客户端导航补齐与联动 (在配置页或未直接渲染分类时自愈并联动)
      function initOrHydrateNav() {
          var nav = document.getElementById('nq-cart-nav');
          if (!nav) return;

          var urlParams = new URLSearchParams(window.location.search);
          var curPid = urlParams.get('pid') || ($('input[name="pid"]').val() || '');
          var curFid = urlParams.get('fid') || '';
          var curGid = urlParams.get('gid') || '';

          var hasServerGroups = nav.querySelectorAll('.nq-cart-nav-group').length > 0;

          fetch('/cart/prolist', { credentials: 'same-origin' })
              .then(function(res) { return res.json(); })
              .then(function(res) {
                  if (res.status !== 200 || !res.data || !Array.isArray(res.data.fgs)) return;
                  var fgs = res.data.fgs;
                  window.cartCatalogFgs = fgs;

                  // 定位当前商品所属的二级分组和一级分组
                  var matchedFg = null, matchedSecond = null, currentGroupProducts = [];
                  if (curPid) {
                      fgs.forEach(function(fg) {
                          (fg.group || []).forEach(function(sec) {
                              (sec.products || []).forEach(function(p) {
                                  if (String(p.id) === String(curPid)) {
                                      matchedFg = fg;
                                      matchedSecond = sec;
                                      currentGroupProducts = sec.products || [];
                                  }
                              });
                          });
                      });
                  } else if (curFid) {
                      matchedFg = fgs.find(function(fg) { return String(fg.id) === String(curFid); });
                      if (matchedFg && curGid) {
                          matchedSecond = (matchedFg.group || []).find(function(sec) { return String(sec.id) === String(curGid); });
                          if (matchedSecond) currentGroupProducts = matchedSecond.products || [];
                      }
                  }

                  // 如果服务端没有渲染左侧分类列表（如配置页），则由客户端极速渲染
                  if (!hasServerGroups) {
                      var html = '';
                      fgs.forEach(function(fg, fIdx) {
                          var isFgActive = matchedFg ? (String(matchedFg.id) === String(fg.id)) : (fIdx === 0);
                          var cleanFgName = String(fg.name || '').replace(/^[a-z]+\|/i, '');
                          html += '<div class="nq-cart-nav-item nq-cart-nav-group ' + (isFgActive ? 'active open' : '') + '" data-fid="' + fg.id + '">';
                          html += '<a href="javascript:void(0);" class="nq-cart-nav-link nq-cart-nav-group-toggle" data-nq-toggle="group">';
                          html += '<span>' + cleanFgName + '</span>';
                          html += '<svg class="nq-cart-nav-arrow" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>';
                          html += '</a>';

                          if (fg.group && fg.group.length > 0) {
                              html += '<div class="nq-cart-nav-sub">';
                              fg.group.forEach(function(sec, sIdx) {
                                  var isSecActive = matchedSecond ? (String(matchedSecond.id) === String(sec.id)) : (isFgActive && sIdx === 0);
                                  var cleanSecName = String(sec.name || '').replace(/^[a-z]+\|/i, '');
                                  var isNew = /new|上新/i.test(sec.name || '');
                                  html += '<div class="nq-cart-nav-item">';
                                  html += '<a href="/cart?fid=' + fg.id + '&gid=' + sec.id + '" class="nq-cart-nav-link nq-cart-nav-sub-link ' + (isSecActive ? 'active' : '') + '">';
                                  html += '<span>' + cleanSecName + '</span>';
                                  if (isNew) html += '<span class="nq-cart-nav-tag">new</span>';
                                  html += '</a></div>';
                              });
                              html += '</div>';
                          }
                          html += '</div>';
                      });
                      nav.innerHTML = html;
                  } else if (matchedFg && matchedSecond) {
                      // 若服务端已渲染，但处于配置页，修正高亮到当前商品所属分类
                      nav.querySelectorAll('.nq-cart-nav-group').forEach(function(el) {
                          var fid = el.getAttribute('data-fid');
                          var isCur = String(fid) === String(matchedFg.id);
                          el.classList.toggle('active', isCur);
                          el.classList.toggle('open', isCur);
                      });
                      nav.querySelectorAll('.nq-cart-nav-sub-link').forEach(function(link) {
                          var href = link.getAttribute('href') || '';
                          link.classList.toggle('active', href.indexOf('gid=' + matchedSecond.id) > -1);
                      });
                  }

                  // 触发配置页型号与推荐列表联动事件
                  if (currentGroupProducts.length > 0) {
                      document.dispatchEvent(new CustomEvent('cart:group-products-ready', {
                          detail: {
                              curPid: curPid,
                              products: currentGroupProducts,
                              matchedSecond: matchedSecond,
                              matchedFg: matchedFg
                          }
                      }));
                  }
              }).catch(function(e) {});
      }

      if (document.readyState === 'loading') {
          document.addEventListener('DOMContentLoaded', initOrHydrateNav);
      } else {
          initOrHydrateNav();
      }
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
