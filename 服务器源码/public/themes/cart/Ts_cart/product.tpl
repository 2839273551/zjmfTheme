{include file="themes/web/Ts_Theme/static/cart/header.html" title="所有产品" /} 
{php} 
$pget = Db::name('product_groups')->where('hidden',0)->where('id',$Get['gid'])->find();
{/php}
<body>

  <!-- 提前预加载（可选） -->
  <link rel="preload" href="/themes/cart/Ts_cart/assets/js/topbar-shoping.css.js" as="script">
  <!-- 样式注入脚本：同步执行，确保首屏无样式闪动 -->
  <script src="/themes/cart/Ts_cart/assets/js/topbar-shoping.css.js"></script>

    <!-- 主要内容区域 -->
    <div class="main-content">
        <div class="container">
            <!-- 页面标题 -->
            <div class="page-header">
                <div class="page-title">
                    <div class="page-title-icon">
                        CA
                    </div>
                    <div class="page-title-content">
                        <h1>创建一个云实例</h1>
                        <p class="subtitle">当前商品组：{$Cart.product_groups_checked.name}</p>
                    </div>
                    <div class="page-title-badge">
                        <div class="dot"></div>
                        公告: {$CustomDepot.cart_gg}
                    </div>
                </div>
            </div>

            <div class="page-layout">
                {include file="cart/Ts_cart/topbar-categories"}

                <!-- 右侧内容区 -->
                <div class="content-wrapper" style="flex: 1; min-width: 0;">
                    <!-- 面包屑导航 -->
                    <div class="breadcrumb-area">
                        <i class="bi bi-info-circle"></i>
                        <span class="breadcrumb-text">{$Cart.product_groups_checked.headline}</span>
                    </div>

                    <!-- 产品网格 -->
                    <div class="product-grid">
                        {foreach $Cart.products as $list}
                        <!-- 产品卡片 -->
                       <div class="product-card" style="position: relative;">
                            <div class="cp-title">
                                <h3 class="product-title">{$list.name}</h3>
                                <div class="region-badge">库存: {$list.qty}</div>
                            </div>
                            <div class="cp-xinxi">
                                {$list.description}
                            </div>
                            <div class="price-section">
                                {if $list.sale_price>0}
                                <span class="price-amount">{$Cart.currency.prefix}{$list.sale_price}</span>
                                <span class="price-unit">{$Cart.currency.suffix}</span>
                                {if $list.ontrial==1}
                                <div class="trial-price">
                                    <small>{$Cart.currency.prefix}{$list.ontrial_setup_fee+$list.ontrial_price} / {$Lang.on_trial} {$list.ontrial_cycle} {$list.ontrial_cycle_type == 'day' ? $Lang.day : $Lang.hour}</small>
                                </div>
                                {/if}
                                <div class="original-price">
                                    <small>({$Lang.original_price}：{$Cart.currency.prefix} {$list.product_price} / {$list.billingcycle_zh})</small>
                                </div>
                                {else}
                                <span class="price-amount">{$Cart.currency.prefix}{$list.product_price}</span>
                                <span class="price-unit">{$Cart.currency.suffix} / {$list.billingcycle_zh}</span>
                                {if $list.ontrial==1}
                                <div class="trial-price">
                                    <small>{$Cart.currency.prefix}{$list.ontrial_setup_fee+$list.ontrial_price} / {$Lang.on_trial} {$list.ontrial_cycle} {$list.ontrial_cycle_type == 'day' ? $Lang.day : $Lang.hour}</small>
                                </div>
                                {/if}
                                {/if}
                            </div>

                         {if $list.stock_control==1 && $list.qty<1}
<button class="buy-button" disabled style="cursor: not-allowed; opacity: 0.6;">
    <i class="bi bi-cart-x"></i>
    产品售罄
</button>

{else}
<button class="buy-button" onclick="location.href='/cart?action=configureproduct&pid={$list.id}{if $Get.site}&site={$Get.site}{/if}'">
    <i class="bi bi-cart-plus"></i>
    {$Lang.buy_now}
</button>
{/if}

                        </div>
                        {/foreach}
                    </div>

                    <!-- 分页 -->
                    <div class="table-footer mt-4 d-flex justify-content-center">
                        <ul class="pagination pagination-sm">
                            {$Pages}
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 手机端浮动按钮 -->
    <button class="mobile-category-btn" id="mobileCategoryBtn">
        <i class="bi bi-grid-3x3-gap"></i>
    </button>

    <!-- 手机端分类面板 -->
    <div class="mobile-category-panel" id="mobileCategoryPanel">
        <div class="panel-header">
            <h3 class="panel-title">选择服务分类</h3>
        </div>
        <div class="panel-content" id="mobilePanelContent">
            <!-- 内容将通过JavaScript从桌面端侧边栏复制 -->
        </div>
    </div>

    <!-- 遮罩层 -->
    <div class="mobile-overlay" id="mobileOverlay"></div>

    <!-- JavaScript -->
    <script src="/themes/cart/Ts_cart/assets/js/bootstrap.bundle.min.js"></script>
    <script src="/themes/cart/Ts_cart/assets/js/jquery-3.6.min.js"></script>

    <script>
        // 全局错误处理
        window.addEventListener('error', function(e) {
            console.warn('JavaScript error caught:', e.error);
            // 防止错误阻止页面功能
            return true;
        });
    </script>
    <script>
        // toggleCategory函数在topbar-categories.tpl中定义，这里不重复定义

        // 页面加载时的分类展开逻辑已在topbar-categories.tpl中处理
        document.addEventListener('DOMContentLoaded', function () {

            // 初始化手机端面板内容和脉冲动画
            setTimeout(() => {
                if (window.innerWidth <= 768) {
                    initializeMobilePanel();
                    mobileCategoryBtn.classList.add('pulse');

                    // 5秒后停止脉冲动画
                    setTimeout(() => {
                        mobileCategoryBtn.classList.remove('pulse');
                    }, 5000);
                }
            }, 1000);
        });

        // 侧边栏导航交互
        document.querySelectorAll('.sidebar-item').forEach(item => {
            item.addEventListener('click', function (e) {
                e.preventDefault();
                // 移除其他项的active类
                document.querySelectorAll('.sidebar-item').forEach(i => i.classList.remove('active'));
                // 添加active类到当前项
                this.classList.add('active');
            });
        });

        // 购买按钮交互（移除样式和文本更改，仅占位）
        document.querySelectorAll('.buy-button').forEach(btn => {
            btn.addEventListener('click', function () {
                // 留空：后端接入购物车逻辑时在此挂载
            });
        });

        // 手机端分类面板功能
        const mobileCategoryBtn = document.getElementById('mobileCategoryBtn');
        const mobileCategoryPanel = document.getElementById('mobileCategoryPanel');
        const mobileOverlay = document.getElementById('mobileOverlay');
        const mobilePanelContent = document.getElementById('mobilePanelContent');

        // 初始化手机端面板内容（复制桌面端一次性的DOM结构，避免维护两份数据）
        function initializeMobilePanel() {
            if (!mobilePanelContent) return;

            // 清空并复制桌面端侧边栏内容
            const desktopSidebar = document.querySelector('.sidebar');
            if (!desktopSidebar) return;

            mobilePanelContent.innerHTML = desktopSidebar.innerHTML;

            // 移除会与桌面端冲突的ID（避免document.getElementById命中桌面端）
            mobilePanelContent.querySelectorAll('[id]').forEach(el => {
                if (el.classList.contains('category-items') || el.classList.contains('category-toggle')) {
                    el.removeAttribute('id');
                }
            });

            // 绑定事件
            setupMobilePanelEvents();

            // 根据当前URL参数展开对应分类
            {if $Think.get.fid}
            const activeFid = '{$Think.get.fid}';
            const activeItems = mobilePanelContent.querySelector('#group-' + activeFid);
            if (activeItems) {
                activeItems.classList.add('expanded');
                const activeIcon = activeItems.previousElementSibling?.querySelector('.category-toggle');
                if (activeIcon) activeIcon.classList.add('expanded');
            }
            {else}
            // 如果没有指定fid，默认展开第一个分类
            const firstItems = mobilePanelContent.querySelector('.category-items');
            if (firstItems) {
                firstItems.classList.add('expanded');
                const firstIcon = firstItems.previousElementSibling?.querySelector('.category-toggle');
                if (firstIcon) firstIcon.classList.add('expanded');
            }
            {/if}
        }

        // 移动端分类切换函数（允许多个分类同时展开）
        function toggleMobileCategory(items, icon) {
            if (!items) return;

            const isExpanded = items.classList.contains('expanded');

            // 只切换当前分类的状态，不影响其他分类
            if (isExpanded) {
                // 收起当前分类
                items.classList.remove('expanded');
                if (icon) icon.classList.remove('expanded');
            } else {
                // 展开当前分类
                items.classList.add('expanded');
                if (icon) icon.classList.add('expanded');
            }
        }

        // 移动端选择分类项目时，折叠其他未选中的大类
        function selectMobileCategoryItem(selectedElement, categoryId) {
            try {
                // 移除所有项目的active类
                mobilePanelContent.querySelectorAll('.sidebar-item').forEach(item => {
                    item.classList.remove('active');
                });

                // 添加active类到当前选中项
                selectedElement.classList.add('active');

                // 折叠其他未选中的大类（保持当前选中项所在的大类展开）
                mobilePanelContent.querySelectorAll('.category-items').forEach(items => {
                    if (items.id !== categoryId && items.classList.contains('expanded')) {
                        // 检查这个分类是否包含当前选中的项目
                        const hasActiveItem = items.querySelector('.sidebar-item.active');
                        if (!hasActiveItem) {
                            // 如果这个分类没有选中项目，则折叠它
                            items.classList.remove('expanded');
                            const toggleIcon = items.previousElementSibling?.querySelector('.category-toggle');
                            if (toggleIcon) {
                                toggleIcon.classList.remove('expanded');
                            }
                        }
                    }
                });
            } catch (error) {
                console.error('Error in selectMobileCategoryItem:', error);
            }
        }

        // 设置手机端面板事件（基于相对节点，不依赖全局ID）
        function setupMobilePanelEvents() {
            // 分类头部展开/收起
            mobilePanelContent.querySelectorAll('.category-header').forEach(header => {
                // 移除桌面端的onclick，防止误用全局toggleCategory
                header.removeAttribute('onclick');

                header.addEventListener('click', function () {
                    const items = this.nextElementSibling; // 紧邻的列表
                    const icon = this.querySelector('.category-toggle');
                    toggleMobileCategory(items, icon);
                });
            });

            // 分类项点击，折叠其他未选中的大类并关闭面板
            mobilePanelContent.querySelectorAll('.sidebar-item').forEach(item => {
                item.addEventListener('click', function (e) {
                    e.preventDefault();

                    // 获取当前项目所属的分类ID
                    const categoryItems = this.closest('.category-items');
                    const categoryId = categoryItems ? categoryItems.id : null;

                    // 调用新的选择函数
                    if (categoryId) {
                        selectMobileCategoryItem(this, categoryId);
                    }

                    // 延迟关闭面板，给用户视觉反馈
                    setTimeout(() => {
                        closeMobileCategoryPanel();
                    }, 300);
                });
            });
        }

        // 打开/关闭分类面板
        function toggleMobileCategoryPanel() {
            const isOpen = mobileCategoryPanel.classList.contains('show');

            if (isOpen) {
                closeMobileCategoryPanel();
            } else {
                openMobileCategoryPanel();
            }
        }

        // 打开分类面板
        function openMobileCategoryPanel() {
            // 如内容未初始化或为空，先初始化一次
            if (mobilePanelContent && mobilePanelContent.querySelectorAll('.sidebar-category').length === 0) {
                initializeMobilePanel();
            }

            mobileCategoryPanel.classList.add('show');
            mobileOverlay.classList.add('show');
            mobileCategoryBtn.classList.add('active');
            mobileCategoryBtn.classList.remove('pulse'); // 停止脉冲动画
            document.body.style.overflow = 'hidden'; // 防止背景滚动
        }

        // 关闭分类面板
        function closeMobileCategoryPanel() {
            mobileCategoryPanel.classList.remove('show');
            mobileOverlay.classList.remove('show');
            mobileCategoryBtn.classList.remove('active');
            document.body.style.overflow = ''; // 恢复滚动
        }

        // 旧的selectMobileCategory函数已被selectMobileCategoryItem替代

        // 事件监听器
        mobileCategoryBtn.addEventListener('click', toggleMobileCategoryPanel);
        mobileOverlay.addEventListener('click', closeMobileCategoryPanel);

        // 阻止面板内部点击事件冒泡
        mobileCategoryPanel.addEventListener('click', function (e) {
            e.stopPropagation();
        });

        // 键盘ESC键关闭面板
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && mobileCategoryPanel.classList.contains('show')) {
                closeMobileCategoryPanel();
            }
        });

        // 窗口大小改变时处理
        window.addEventListener('resize', function () {
            if (window.innerWidth > 768 && mobileCategoryPanel.classList.contains('show')) {
                closeMobileCategoryPanel();
            } else if (window.innerWidth <= 768 && mobilePanelContent.innerHTML.trim() === '') {
                // 如果切换到手机端且面板内容为空，则初始化
                initializeMobilePanel();
            }
        });

        // 标题展开/收起功能 - 已移除，现在标题自动换行显示
        function toggleTitle(element) {
            // 保留函数以避免onclick错误，但不执行任何操作
            // 标题现在会自动换行显示完整内容
            return;
        }

        // 页面加载完成后，优化标题显示
        document.addEventListener('DOMContentLoaded', function() {
            // 检查是否为PC或平板端（非手机端）
            function isDesktopOrTablet() {
                return window.innerWidth > 768;
            }

            // 动态调整产品网格布局
            function adjustProductGridLayout() {
                const productGrid = document.querySelector('.product-grid');
                const productCards = document.querySelectorAll('.product-card');

                if (!productGrid || !productCards.length) return;

                // 只在PC和平板端应用动态布局
                if (isDesktopOrTablet()) {
                    if (productCards.length >= 3) {
                        // 商品数量>=3，使用自适应布局
                        productGrid.classList.add('adaptive-layout');
                    } else {
                        // 商品数量<3，使用固定宽度布局
                        productGrid.classList.remove('adaptive-layout');
                    }
                } else {
                    // 移动端始终移除自适应布局类
                    productGrid.classList.remove('adaptive-layout');
                }
            }

            // 处理标题省略显示的函数
            function handleTitleEllipsis() {
                if (!isDesktopOrTablet()) {
                    // 手机端保持原有逻辑，不做省略处理
                    const titles = document.querySelectorAll('.product-title');
                    titles.forEach(title => {
                        title.removeAttribute('title');
                        title.style.whiteSpace = 'normal';
                        title.style.wordWrap = 'break-word';
                        title.style.wordBreak = 'break-all';
                        title.style.cursor = 'default';
                        title.style.overflow = 'visible';
                        title.style.textOverflow = 'clip';
                    });
                    return;
                }

                // PC和平板端处理逻辑
                const productCards = document.querySelectorAll('.product-card');
                productCards.forEach(card => {
                    const title = card.querySelector('.product-title');
                    const regionBadge = card.querySelector('.region-badge');
                    const titleContainer = card.querySelector('.cp-title');

                    if (!title || !regionBadge || !titleContainer) return;

                    // 保存原始标题文本
                    const originalText = title.textContent.trim();
                    title.setAttribute('data-original-text', originalText);

                    // 设置标题为单行显示
                    title.style.whiteSpace = 'nowrap';
                    title.style.overflow = 'hidden';
                    title.style.textOverflow = 'ellipsis';
                    title.style.wordWrap = 'normal';
                    title.style.wordBreak = 'normal';

                    // 计算可用宽度
                    function calculateAvailableWidth() {
                        const containerRect = titleContainer.getBoundingClientRect();
                        const badgeRect = regionBadge.getBoundingClientRect();
                        const titleMargin = 12; // 标题与库存标签之间的间距

                        return containerRect.width - badgeRect.width - titleMargin;
                    }

                    // 检查并调整标题显示
                    function adjustTitleDisplay() {
                        const availableWidth = calculateAvailableWidth();
                        title.style.maxWidth = availableWidth + 'px';

                        // 检查是否发生了省略
                        if (title.scrollWidth > title.clientWidth) {
                            // 发生了省略，添加title属性显示完整文本
                            title.setAttribute('title', originalText);
                            title.style.cursor = 'help';
                        } else {
                            // 没有省略，移除title属性
                            title.removeAttribute('title');
                            title.style.cursor = 'default';
                        }
                    }

                    // 初始调整
                    adjustTitleDisplay();

                    // 监听窗口大小变化
                    const resizeObserver = new ResizeObserver(() => {
                        if (isDesktopOrTablet()) {
                            adjustTitleDisplay();
                        }
                    });
                    resizeObserver.observe(card);
                });
            }

            // 初始化处理
            adjustProductGridLayout();
            handleTitleEllipsis();

            // 监听窗口大小变化，在PC/平板和手机端之间切换时重新处理
            window.addEventListener('resize', function() {
                // 延迟执行，确保布局已经调整完成
                setTimeout(function() {
                    adjustProductGridLayout();
                    handleTitleEllipsis();
                }, 100);
            });
        });
    </script>
    <script type="text/javascript">
  window["\x64\x6f\x63\x75\x6d\x65\x6e\x74"]['\x61\x64\x64\x45\x76\x65\x6e\x74\x4c\x69\x73\x74\x65\x6e\x65\x72']('\x44\x4f\x4d\x43\x6f\x6e\x74\x65\x6e\x74\x4c\x6f\x61\x64\x65\x64',function(){if(typeof $!=='\x75\x6e\x64\x65\x66\x69\x6e\x65\x64'){$(function(){$("\x61")['\x65\x61\x63\x68'](function(){$(this)['\x74\x65\x78\x74']()===" \x50\x6f\x77\x65\x72\x65\x64 \x62\x79 \xa9\u667a\u7b80\u9b54\u65b9"&&$(this)['\x72\x65\x6d\x6f\x76\x65']()})})}else{window["\x64\x6f\x63\x75\x6d\x65\x6e\x74"]['\x71\x75\x65\x72\x79\x53\x65\x6c\x65\x63\x74\x6f\x72\x41\x6c\x6c']("\x61")['\x66\x6f\x72\x45\x61\x63\x68'](function(link){if(link['\x74\x65\x78\x74\x43\x6f\x6e\x74\x65\x6e\x74']['\x74\x72\x69\x6d']()===" \x50\x6f\x77\x65\x72\x65\x64 \x62\x79 \xa9\u667a\u7b80\u9b54\u65b9"){link['\x72\x65\x6d\x6f\x76\x65']()}})}});
</script>
</body>
{include file="themes/web/Ts_Theme/static/cart/footer.html"/}