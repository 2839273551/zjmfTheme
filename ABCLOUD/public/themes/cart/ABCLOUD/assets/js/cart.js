(function() {
    'use strict';

    document.addEventListener('DOMContentLoaded', function() {
        // 1. 移动端产品分类抽屉
        var trigger = document.getElementById('mobileCatTrigger');
        var drawerWrap = document.getElementById('mobileDrawerWrap');
        var backdrop = document.getElementById('mobileDrawerBackdrop');
        var closeBtn = document.getElementById('closeDrawerBtn');

        function openDrawer() {
            if (drawerWrap) {
                drawerWrap.classList.add('is-open');
                drawerWrap.style.display = 'block';
                document.body.classList.add('cscart-mobile-drawer-open');
            }
        }

        function closeDrawer() {
            if (drawerWrap) {
                drawerWrap.classList.remove('is-open');
                drawerWrap.style.display = 'none';
                document.body.classList.remove('cscart-mobile-drawer-open');
            }
        }

        if (trigger) trigger.addEventListener('click', openDrawer);
        var triggerMain = document.getElementById('mobileCatTriggerMain');
        if (triggerMain) triggerMain.addEventListener('click', openDrawer);
        if (backdrop) backdrop.addEventListener('click', closeDrawer);
        if (closeBtn) closeBtn.addEventListener('click', closeDrawer);

        // 2. 页面内商品关键词实时过滤
        var searchInput = document.getElementById('categorySidebarSearch') || document.getElementById('cartProductSearch');
        var productCards = document.querySelectorAll('.nq-product-card, .server-product-card, .shuidc-product-card');
        var emptyState = document.getElementById('searchEmptyState');

        if (searchInput && productCards.length) {
            function filterCards() {
                var keyword = searchInput.value.trim().toLowerCase();
                var matchCount = 0;

                productCards.forEach(function(card) {
                    var title = (card.getAttribute('data-name') || '').toLowerCase();
                    var desc = (card.querySelector('.nq-product-desc, .config-row, .server-product-description') || {}).textContent || '';
                    if (!keyword || title.indexOf(keyword) > -1 || desc.toLowerCase().indexOf(keyword) > -1) {
                        card.style.display = '';
                        matchCount++;
                    } else {
                        card.style.display = 'none';
                    }
                });

                if (emptyState) {
                    if (keyword && matchCount === 0) {
                        emptyState.classList.add('is-visible');
                        emptyState.style.setProperty('display', 'flex', 'important');
                    } else {
                        emptyState.classList.remove('is-visible');
                        emptyState.style.setProperty('display', 'none', 'important');
                    }
                }
            }

            searchInput.addEventListener('input', filterCards);
        }

        // 3. 侧边栏全局商品搜索跳转
        var sidebarSearch = document.getElementById('categorySidebarSearch');
        if (sidebarSearch) {
            sidebarSearch.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    var q = this.value.trim();
                    window.location.href = '/cart?keywords=' + encodeURIComponent(q);
                }
            });
        }

        // 4. 左侧分类菜单：彻底清理旧记忆，刷新或刚进来默认只开最上面那一栏
        try {
            localStorage.removeItem('cart_open_groups');
            sessionStorage.removeItem('cart_open_groups');
        } catch(e) {}

        // 5. 购物车页面加载进度条与交互加载动效
        var progressBar = document.getElementById('cartPageProgressBar');
        if (progressBar) {
            progressBar.classList.add('is-loading');
            progressBar.style.width = '70%';
            setTimeout(function() {
                progressBar.style.width = '100%';
                setTimeout(function() {
                    progressBar.style.opacity = '0';
                    setTimeout(function() {
                        progressBar.classList.remove('is-loading');
                        progressBar.style.width = '0%';
                    }, 350);
                }, 200);
            }, 100);
        }

        // 点击二级子分类跳转时：进度条启动、侧栏项显式加载、屏幕中心雾透悬浮 loading-42、商品区原位锁定
        document.addEventListener('click', function(e) {
            var subLink = e.target.closest('.nq-cart-nav-sub-link');
            if (subLink && !subLink.classList.contains('active')) {
                subLink.classList.add('is-navigating');
                if (progressBar) {
                    progressBar.style.opacity = '1';
                    progressBar.classList.add('is-loading');
                    progressBar.style.width = '80%';
                }
                var floatingLoading = document.getElementById('nqFloatingLoading');
                if (floatingLoading) {
                    floatingLoading.classList.add('is-active');
                }
                var productList = document.getElementById('nq-product-list');
                if (productList) {
                    productList.classList.add('is-loading-state');
                }
            }

            // 点击“立即购买”按钮时：按钮进入 loading 旋转状态
            var buyBtn = e.target.closest('.nq-buy-btn');
            if (buyBtn && !buyBtn.classList.contains('is-loading')) {
                buyBtn.classList.add('is-loading');
                if (progressBar) {
                    progressBar.style.opacity = '1';
                    progressBar.classList.add('is-loading');
                    progressBar.style.width = '85%';
                }
            }
        });
    });
})();
