(function () {
    'use strict';
    var finance = window.apeFinance;
    function empty(message) {
        return '<div class="mega-product-empty"><img src="/themes/web/ABCLOUD/static/ape/img/mynr.png" alt="" class="mega-empty-img"><p class="mega-empty-text">' + finance.esc(message) + '</p></div>';
    }
    function productMenu(groups) {
        var menu = document.querySelector('[data-product-menu="1"]');
        if (!menu) return;
        var cats = menu.querySelector('.mega-cat-list');
        var content = menu.querySelector('.mega-product-content');
        if (!groups.length) { content.innerHTML = empty('暂无产品分类'); return; }
        cats.innerHTML = groups.map(function (group, i) {
            return '<button type="button" class="mega-cat-item' + (i ? '' : ' active') + '" data-group="' + finance.id(group.id) + '">' + finance.esc(group.name.replace(/^[a-z]+\|/i, '')) + '</button>';
        }).join('');
        function select(group) {
            cats.querySelectorAll('[data-group]').forEach(function (cat) {
                var active = cat.dataset.group === String(group.id);
                cat.classList.toggle('active', active);
                cat.setAttribute('aria-pressed', String(active));
            });
            var seconds = group.group || [];
            content.innerHTML = seconds.length ? '<div class="mega-product-grid">' + seconds.map(function (second) {
                var rawName = String(second.name || '').replace(/^[a-z]+\|/i, '');
                var desc = finance.text(second.headline || second.tagline || '');
                if (!desc) {
                    desc = second.products && second.products.length ?
                        ('精选 ' + second.products.length + ' 款产品配置，支持弹性升配与快速交付') :
                        '提供高性能、高安全云计算服务，保障业务稳定上云';
                }
                var isSoldOut = !/售罄/.test(rawName) && second.products && second.products.length > 0 && second.products.every(function (p) {
                    return finance.soldOut(p);
                });
                var url = '/cart?fid=' + finance.id(group.id) + '&gid=' + finance.id(second.id);
                return '<a href="' + url + '" class="mega-product-card">' +
                    '<div class="mega-product-name">' + finance.esc(rawName) + (isSoldOut ? ' · 售罄' : '') + '</div>' +
                    '<div class="mega-product-desc">' + finance.esc(desc) + '</div>' +
                    '</a>';
            }).join('') + '</div>' : empty('该分类暂无商品分组');
        }
        cats.addEventListener('click', function (event) {
            var cat = event.target.closest('[data-group]');
            if (!cat) return;
            var group = groups.find(function (item) { return String(item.id) === cat.dataset.group; });
            if (group) select(group);
        });
        select(groups[0]);
    }
    function menus() {
        document.querySelectorAll('#publicNav li.has-mega').forEach(function (menu) {
            var anchor = menu.querySelector('.nav-parent');
            anchor.addEventListener('click', function (event) {
                event.preventDefault();
                var opened = menu.getAttribute('data-click-lock') === '1';
                document.querySelectorAll('#publicNav li.has-mega').forEach(function (other) {
                    other.classList.remove('active');
                    other.removeAttribute('data-click-lock');
                });
                menu.classList.toggle('active', !opened);
                if (!opened) menu.setAttribute('data-click-lock', '1');
                anchor.setAttribute('aria-expanded', String(!opened));
            });
        });
        document.addEventListener('click', function (event) {
            if (event.target.closest('#publicNav li.has-mega')) return;
            document.querySelectorAll('#publicNav li.has-mega').forEach(function (menu) {
                menu.classList.remove('active');
                menu.removeAttribute('data-click-lock');
                menu.querySelector('.nav-parent').setAttribute('aria-expanded', 'false');
            });
        });
    }
    function documents() {
        var source = document.getElementById('apeHelpSource');
        var links = source ? Array.prototype.slice.call(source.content.querySelectorAll('a[href]')) : [];
        var support = Array.prototype.find.call(document.querySelectorAll('#publicNav .has-dropdown'), function (menu) {
            return menu.querySelector('.nav-parent').textContent.indexOf('支持与服务') !== -1;
        });
        if (support) {
            var list = support.querySelector('.nav-dropdown');
            if (!list) return;
            list.querySelectorAll('[data-ape-help-link]').forEach(function (item) { item.remove(); });
            var existing = Array.prototype.map.call(list.querySelectorAll('a[href]'), function (link) { return link.href; });
            links.slice(0, 5).forEach(function (link) {
                if (existing.indexOf(link.href) !== -1) return;
                var item = document.createElement('li');
                item.setAttribute('data-ape-help-link', '1');
                item.appendChild(link.cloneNode(true));
                list.appendChild(item);
                existing.push(link.href);
            });
        }
    }
    function mobileProducts(groups) {
        var right = document.querySelector('.mobile-menu-right');
        if (!right) return;
        var html = '<div class="mobile-menu-content"><h2 class="mobile-menu-title">产品与服务</h2><div class="mobile-menu-divider"></div>';
        groups.forEach(function (group) {
            html += '<h3 class="mobile-menu-subtitle">' + finance.esc(group.name.replace(/^[a-z]+\|/i, '')) + '</h3>';
            (group.group || []).forEach(function (second) {
                html += '<a class="mobile-menu-link" href="/cart?fid=' + finance.id(group.id) + '&gid=' + finance.id(second.id) + '">' + finance.esc(second.name.replace(/^[a-z]+\|/i, '')) + '</a>';
            });
        });
        right.innerHTML = html + '</div>';
        right.addEventListener('click', function (event) {
            if (event.target.closest('a[href]')) document.body.classList.remove('menu-open');
        });
    }
    function notices() {
        finance.updates('announce').then(function (list) {
            var notice = document.querySelector('#apeTopNotice .public-notice-text');
            var popup = document.querySelector('#popupOverlay .popup-content');
            if (notice) {
                notice.replaceChildren();
                var link = document.createElement('a');
                link.href = '/news';
                link.textContent = list.length ? list[0].title : '暂无公告';
                if (list.length) link.href = '/newsview?id=' + finance.id(list[0].id);
                notice.appendChild(link);
            }
            if (popup && !window.apePluginPopupManaged) {
                popup.replaceChildren();
                if (!list.length) popup.textContent = '暂无公告';
                list.forEach(function (item) {
                    var paragraph = document.createElement('p');
                    var link = document.createElement('a');
                    link.href = '/newsview?id=' + finance.id(item.id);
                    link.textContent = item.title;
                    paragraph.appendChild(link);
                    popup.appendChild(paragraph);
                });
            }
        }).catch(function () {
            var notice = document.querySelector('#apeTopNotice .public-notice-text');
            if (notice) notice.innerHTML = '<a href="/news">公告中心</a>';
        });
    }
    document.addEventListener('ape:navigation-ready', documents);
    document.addEventListener('DOMContentLoaded', function () {
        menus();
        documents();
        notices();
        finance.catalog().then(function (groups) { productMenu(groups); mobileProducts(groups); }).catch(function () {
            var content = document.querySelector('[data-product-menu] .mega-product-content');
            if (content) content.innerHTML = empty('产品暂时无法加载') + '<a href="/cart">前往产品中心</a>';
        });
    });
})();
