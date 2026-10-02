// 产品服务展示模块：从后台公开接口获取产品一级/二级分组并渲染（登录未登录均可显示）
document.addEventListener('DOMContentLoaded', function () {
    'use strict';

    var accordionHeader = document.getElementById('productAccordionHeader');
    var productContainer = document.querySelector('.product-service-container');
    var tabsNav = document.getElementById('productTabs');
    var tabsContent = document.getElementById('productTabsContent');


    // 没有该模块则直接返回
    if (!tabsNav || !tabsContent) {
        if (accordionHeader && productContainer) {
            accordionHeader.addEventListener('click', function () {
                productContainer.classList.toggle('expanded');
            });
        }
        return;
    }

    // accordion 交互
    if (accordionHeader && productContainer) {
        accordionHeader.addEventListener('click', function () {
            productContainer.classList.toggle('expanded');
        });
    }

    var finance = window.apeFinance;
    function getFirstGroups() { return finance.catalog(); }
    function getSecondGroups(firstId) {
        return finance.catalog().then(function (groups) {
            var group = groups.find(function (item) { return String(item.id) === String(firstId); });
            return group ? group.group || [] : [];
        });
    }
    function getProducts(secondId, limit) {
        return finance.catalog().then(function (groups) {
            var found = [];
            groups.forEach(function (group) {
                (group.group || []).forEach(function (second) {
                    if (String(second.id) === String(secondId)) found = second.products || [];
                });
            });
            return found.slice(0, limit || 8);
        });
    }

    // 商品卡片 HTML
    function esc(s) {
        return String(s == null ? '' : s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;')
            .replace(/>/g, '&gt;').replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function cardHtml(p) {
        var desc = p.description ? '<p class="card-text text-muted small">' + esc(finance.text(p.description)) + '</p>' : '';
        return '<div class="col">' +
            '<a href="' + finance.productUrl(p) + '"' + (finance.soldOut(p) ? ' aria-disabled="true" tabindex="-1"' : '') + '>' +
            '<div class="card h-100 shadow-sm"><div class="card-body product-card-body">' +
            '<h5 class="card-title fw-bold">' + esc(p.name) + (finance.soldOut(p) ? ' <span class="product-sold-out">售罄</span>' : '') + '</h5>' +
            desc +
            '</div></div></a></div>';
    }

    // 空状态：图片 + 文字
    function emptyHtml() {
        return '<div class="text-center py-5 product-empty">' +
            '<img src="/themes/cart/ABCLOUD/static/ape/img/mynr.png" alt="暂无商品" class="product-empty-img">' +
            '<p class="text-muted mt-3 mb-0">该分类暂无商品</p>' +
            '</div>';
    }

    // 渲染某个一级分组的商品内容到指定 pane
    function loadPane(firstId, pane) {
        pane.innerHTML = '<div class="text-center py-5 text-muted">加载中...</div>';
        getSecondGroups(firstId).then(function (seconds) {
            if (!seconds || !seconds.length) {
                pane.innerHTML = emptyHtml();
                return;
            }
            var tasks = seconds.map(function (s) { return getProducts(s.id, 8); });
            return Promise.all(tasks).then(function (results) {
                var cards = [];
                results.forEach(function (list) {
                    if (list && list.length) cards = cards.concat(list);
                });
                if (!cards.length) {
                    pane.innerHTML = emptyHtml();
                    return;
                }
                cards = cards.slice(0, 8);
                var paneHtml = '<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">' +
                    cards.map(cardHtml).join('') + '</div>';
                // 手机端：超过3个商品时，网格下方展示"查看全部"按钮（桌面端隐藏，由头部链接代替）
                if (cards.length > 3) {
                    paneHtml += '<a href="/cart" class="product-view-all-mobile">查看全部 ' +
                        '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>' +
                        '</a>';
                }
                pane.innerHTML = paneHtml;
                pane.querySelectorAll('a[aria-disabled="true"]').forEach(function (a) { a.addEventListener('click', function (event) { event.preventDefault(); }); });
                setTimeout(showCards, 60);
            });
        }).catch(function () {
            pane.removeAttribute('data-loaded');
            pane.innerHTML = '<div class="text-center py-5 text-muted">产品暂时无法加载，请重新选择分类或<a href="/cart">前往产品中心</a></div>';
        });
    }

    // 渲染一级分组 tab + 空 pane
    function renderTabs(groups) {
        if (!groups || !groups.length) {
            tabsNav.innerHTML = '';
            tabsContent.innerHTML = '<div class="text-center py-5 text-muted">暂无产品分类</div>';
            return;
        }
        var navHtml = '';
        var contentHtml = '';
        groups.forEach(function (g, i) {
            g.name = finance.text(g.name).replace(/^[a-z]+\|/i, '');
            var active = i === 0 ? ' active' : '';
            var selected = i === 0 ? 'true' : 'false';
            navHtml += '<li class="nav-item" role="presentation">' +
                '<button class="nav-link' + active + '" id="gptab-' + g.id + '" data-bs-toggle="tab" ' +
                'data-bs-target="#gppane-' + g.id + '" data-first-id="' + g.id + '" type="button" role="tab" ' +
                'aria-controls="gppane-' + g.id + '" aria-selected="' + selected + '">' + esc(g.name) + '</button></li>';
            contentHtml += '<div class="tab-pane fade' + (i === 0 ? ' show active' : '') + '" id="gppane-' + g.id +
                '" role="tabpanel" aria-labelledby="gptab-' + g.id + '"></div>';
        });
        tabsNav.innerHTML = navHtml;
        tabsContent.innerHTML = contentHtml;

        // 预加载第一个分组
        var first = groups[0];
        var viewAll = document.querySelector('.product-view-all');
        if (viewAll) viewAll.href = finance.groupUrl(first);
        document.getElementById('gppane-' + first.id).setAttribute('data-loaded', '1');
        loadPane(first.id, document.getElementById('gppane-' + first.id));
    }

    // 卡片逐个载入动画（沿用原有滚动效果）
    function showCards() {
        var cards = tabsContent.querySelectorAll('.tab-pane.show .card:not(.visible)');
        if (!cards.length) return;
        var card = cards[0];
        var pane = card.closest('.tab-pane');
        if (pane && pane.classList.contains('show')) {
            var rect = card.getBoundingClientRect();
            if (rect.top < window.innerHeight - 100 && rect.bottom >= 0) {
                card.classList.add('visible');
                setTimeout(showCards, 100);
            }
        }
    }

    // 切换 tab 时加载对应分组
    tabsNav.addEventListener('click', function (e) {
        var btn = e.target.closest('button[data-bs-toggle="tab"]');
        if (!btn) return;
        var firstId = btn.getAttribute('data-first-id');
        finance.catalog().then(function (groups) {
            var group = groups.find(function (g) { return String(g.id) === firstId; });
            var viewAll = document.querySelector('.product-view-all');
            if (viewAll && group) viewAll.href = finance.groupUrl(group);
        });
        setTimeout(showCards, 180);
        var pane = document.querySelector(btn.getAttribute('data-bs-target'));
        if (!pane || pane.getAttribute('data-loaded') === '1') return;
        pane.setAttribute('data-loaded', '1');
        loadPane(firstId, pane);
    });

    // 滚动时检查可见性
    var scrollTimer = null;
    window.addEventListener('scroll', function () {
        if (scrollTimer) clearTimeout(scrollTimer);
        scrollTimer = setTimeout(showCards, 120);
    });

    // 启动：拉取一级分组并渲染
    getFirstGroups().then(renderTabs).catch(function () {
        tabsContent.innerHTML = '<div class="text-center py-5 text-muted">产品暂时无法加载，<a href="/cart">前往产品中心</a></div>';
    });
});
