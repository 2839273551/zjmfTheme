

<!-- 左侧边栏 -->
<div class="sidebar-wrapper">
    <div class="sidebar">
        <!-- 侧边栏标题 -->
        <div class="sidebar-header">
            <h4 class="sidebar-title">请选择产品大类</h4>
        </div>

        {foreach $Cart.product_groups as $group_index=>$group}
        {assign name="current_fid" value="$Think.get.fid" /}
        {assign name="current_gid" value="$Think.get.gid" /}

        <!-- 动态产品分组 -->
        <div class="sidebar-category">
            {if isset($group.second) && is_array($group.second) && count($group.second) > 0}
            <div class="category-header">
                <div class="category-title">
                    <i class="category-icon"></i>
                    {$group.name}
                </div>
                <i class="bi bi-chevron-right category-toggle" id="toggle-group-{$group.id}"></i>
            </div>
            <div class="category-items" id="group-{$group.id}">
                {foreach $group.second as $second_index=>$secondItem}
                {assign name="is_active" value="false" /}
                {if $secondItem.id == $current_gid}
                    {assign name="is_active" value="true" /}
                {elseif !$current_gid && $group.id == $current_fid && $second_index==0}
                    {assign name="is_active" value="true" /}
                {elseif !$current_gid && !$current_fid && $group_index==0 && $second_index==0}
                    {assign name="is_active" value="true" /}
                {/if}
                <a href="/cart?fid={$group.id}&gid={$secondItem.id}{if $Get.site}&site={$Get.site}{/if}"
                   class="sidebar-item {if $is_active == 'true'}active{/if}"
                   onclick="selectCategoryItem(this, 'group-{$group.id}'); loadProducts({$group.id}, {$secondItem.id})">
                    <i></i>
                    {$secondItem.name}
                </a>
                {if $is_active == 'true'}
                {assign name="cart_first_id" value="$group.id" /}
                {assign name="cart_gid" value="$secondItem.id" /}
                {assign name="cart_second" value="$group.second" /}
                {/if}
                {/foreach}
            </div>
            {else/}
            <!-- 没有二级分类：外观与有二级时一致，仍可展开（展开为空） -->
            {assign name="is_group_active" value="false" /}
            {if $group.id == $current_fid}
                {assign name="is_group_active" value="true" /}
            {elseif !$current_fid && $group_index==0}
                {assign name="is_group_active" value="true" /}
            {/if}
            <div class="category-header">
                <div class="category-title">
                    <i class="category-icon"></i>
                    {$group.name}
                </div>
                <i class="bi bi-chevron-right category-toggle" id="toggle-group-{$group.id}"></i>
            </div>
            <div class="category-items" id="group-{$group.id}">
                <!-- 无二级分类，展开为空 -->
            </div>
            {if $is_group_active == 'true'}
            {assign name="cart_first_id" value="$group.id" /}
            {/if}
            {/if}
        </div>
        {/foreach}
    </div>
</div>

<script>
// 加载产品列表的函数
function loadProducts(fid, gid) {
    // 构建URL参数
    let url = '/cart?fid=' + fid;
    if (gid && gid > 0) {
        url += '&gid=' + gid;
    }

    // 如果有site参数，保持传递
    {if $Get.site}
    url += '&site={$Get.site}';
    {/if}

    // 跳转到新页面
    window.location.href = url;
    return false;
}

// 分类折叠功能（允许多个分类同时展开）
function toggleCategory(categoryId) {
    try {
        const categoryItems = document.getElementById(categoryId);
        const toggleIcon = document.getElementById('toggle-' + categoryId);

        if (!categoryItems) {
            console.warn('Category element not found:', categoryId);
            return;
        }

        // 只切换当前分类的状态，不影响其他分类
        if (categoryItems.classList.contains('expanded')) {
            // 收起当前分类
            categoryItems.classList.remove('expanded');
            if (toggleIcon) {
                toggleIcon.classList.remove('expanded');
            }
        } else {
            // 展开当前分类
            categoryItems.classList.add('expanded');
            if (toggleIcon) {
                toggleIcon.classList.add('expanded');
            }
        }
    } catch (error) {
        console.error('Error in toggleCategory:', error);
    }
}

// 选择分类项目时，折叠其他未选中的大类
function selectCategoryItem(selectedElement, categoryId) {
    try {
        // 移除所有项目的active类
        document.querySelectorAll('.sidebar-item').forEach(item => {
            item.classList.remove('active');
        });

        // 添加active类到当前选中项
        selectedElement.classList.add('active');

        // 折叠其他未选中的大类（保持当前选中项所在的大类展开）
        document.querySelectorAll('.category-items').forEach(items => {
            if (items.id !== categoryId && items.classList.contains('expanded')) {
                // 检查这个分类是否包含当前选中的项目
                const hasActiveItem = items.querySelector('.sidebar-item.active');
                if (!hasActiveItem) {
                    // 如果这个分类没有选中项目，则折叠它
                    items.classList.remove('expanded');
                    const toggleIcon = document.getElementById('toggle-' + items.id);
                    if (toggleIcon) {
                        toggleIcon.classList.remove('expanded');
                    }
                }
            }
        });
    } catch (error) {
        console.error('Error in selectCategoryItem:', error);
    }
}

// 确保函数在全局作用域中可用
window.toggleCategory = toggleCategory;

// 初始化分类展开逻辑的函数
function initializeCategoryExpansion() {
    // 获取当前激活的分组ID
    {if $Think.get.fid}
    const activeFid = '{$Think.get.fid}';
    // 使用toggleCategory函数确保只展开当前分类
    if (document.getElementById('group-' + activeFid)) {
        toggleCategory('group-' + activeFid);
    }
    {else}
    // 如果没有指定fid，默认展开第一个分类
    const firstCategory = document.querySelector('.category-items');
    if (firstCategory) {
        toggleCategory(firstCategory.id);
    }
    {/if}

    // 重新绑定所有分类头部的点击事件，确保使用最新的逻辑
    document.querySelectorAll('.category-header').forEach(header => {
        // 移除旧的onclick属性（如果有的话）
        header.removeAttribute('onclick');

        // 添加新的事件监听器
        header.addEventListener('click', function(e) {
            const categoryId = this.nextElementSibling?.id;
            if (categoryId) {
                e.preventDefault();
                toggleCategory(categoryId);
            }
        });
    });

    // 重新绑定所有分类项目的点击事件
    document.querySelectorAll('.sidebar-item').forEach(item => {
        // 移除旧的onclick属性中的selectCategoryItem调用，保留loadProducts
        const originalOnclick = item.getAttribute('onclick');
        if (originalOnclick) {
            // 提取loadProducts调用
            const loadProductsMatch = originalOnclick.match(/loadProducts\([^)]+\)/);
            if (loadProductsMatch) {
                const loadProductsCall = loadProductsMatch[0];

                // 获取分类ID
                const categoryItems = item.closest('.category-items');
                const categoryId = categoryItems ? categoryItems.id : null;

                // 设置新的onclick
                item.setAttribute('onclick', `selectCategoryItem(this, '${categoryId}'); ${loadProductsCall}`);
            }
        }
    });
}

// 页面加载完成后，等待图标加载完成再展开分类
document.addEventListener('DOMContentLoaded', function() {
    // 监听图标加载完成事件
    document.addEventListener('sidebarIconsLoaded', function() {
        // 图标加载完成后，初始化分类展开
        setTimeout(initializeCategoryExpansion, 50);
    });

    // 备用方案：如果图标加载事件没有触发，使用延迟执行
    setTimeout(function() {
        // 检查是否已经初始化过
        const hasExpandedCategory = document.querySelector('.category-items.expanded');
        if (!hasExpandedCategory) {
            initializeCategoryExpansion();
        }
    }, 800);
});
</script>