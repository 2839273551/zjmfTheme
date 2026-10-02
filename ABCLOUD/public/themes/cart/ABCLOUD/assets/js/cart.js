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
        var searchInput = document.getElementById('cartProductSearch');
        var productCards = document.querySelectorAll('.server-product-card');
        var emptyState = document.getElementById('searchEmptyState');

        if (searchInput && productCards.length) {
            searchInput.addEventListener('input', function() {
                var keyword = this.value.trim().toLowerCase();
                var matchCount = 0;

                productCards.forEach(function(card) {
                    var title = (card.getAttribute('data-name') || '').toLowerCase();
                    var desc = (card.querySelector('.server-product-description') || {}).textContent || '';
                    if (!keyword || title.indexOf(keyword) > -1 || desc.toLowerCase().indexOf(keyword) > -1) {
                        card.style.display = '';
                        matchCount++;
                    } else {
                        card.style.display = 'none';
                    }
                });

                if (emptyState) {
                    emptyState.style.display = matchCount === 0 ? 'block' : 'none';
                }
            });
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
    });
})();
