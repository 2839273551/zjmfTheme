<aside class="store-sidebar" aria-labelledby="store-category-title" data-category-panel>
  <div class="store-search">
    <label class="sr-only" for="store-product-search">搜索当前商品</label>
    <input id="store-product-search" type="search" placeholder="输入关键词搜索产品" autocomplete="off" data-product-search>
    <span aria-hidden="true">⌕</span>
  </div>

  <div class="store-sidebar-heading">
    <h2 id="store-category-title">产品分类</h2>
    <button type="button" aria-label="关闭产品菜单" data-category-close>×</button>
  </div>

  {if $Cart.product_groups}
  <nav class="store-category-nav" aria-label="商品分类">
    {foreach $Cart.product_groups as $group_index=>$group}
    <details class="store-category-group"
      {if $group.id == $Think.get.fid || (!$Think.get.fid && $group_index==0)}open{/if}>
      <summary>
        <span>{$group.name}</span>
        <span aria-hidden="true">›</span>
      </summary>

      <div class="store-category-links">
        {if isset($group.second) && is_array($group.second) && count($group.second)>0}
        {foreach $group.second as $second_index=>$second}
        <a href="{$setting.web_url}/cart?fid={$group.id}&gid={$second.id}{if $Get.site}&site={$Get.site}{/if}"
           class="{if $second.id == $Think.get.gid || (!$Think.get.gid && $group.id == $Think.get.fid && $second_index==0) || (!$Think.get.fid && !$Think.get.gid && $group_index==0 && $second_index==0)}is-active{/if}">
          <span>{$second.name}</span>
          {if $second.id == $Think.get.gid}<small>当前</small>{/if}
        </a>
        {/foreach}
        {else/}
        <a href="{$setting.web_url}/cart?fid={$group.id}{if $Get.site}&site={$Get.site}{/if}"
           class="{if $group.id == $Think.get.fid}is-active{/if}">
          <span>查看{$group.name}</span>
        </a>
        {/if}
      </div>
    </details>
    {/foreach}
  </nav>
  {else/}
  <p class="store-sidebar-empty">后台尚未配置可见商品组。</p>
  {/if}
</aside>
