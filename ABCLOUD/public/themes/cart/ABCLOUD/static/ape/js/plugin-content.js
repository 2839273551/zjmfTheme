(function () {
    'use strict';

    function escapeHtml(value) {
        return String(value == null ? '' : value).replace(/[&<>"']/g, function (character) {
            return {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'}[character];
        });
    }

    function rows(value) { return Array.isArray(value) ? value : []; }
    function enabled(data, key) { return !!(data.managed && data.managed[key]); }
    function safeUrl(value) {
        value = String(value || '').trim();
        return /^(https?:\/\/|\/(?!\/)|#[A-Za-z0-9_-])/.test(value) ? value : '';
    }

    function renderCarousel(data) {
        if (!enabled(data, 'carousel')) return true;
        var banner = document.getElementById('banner');
        var inner = document.getElementById('bannerInner');
        var sidebar = document.getElementById('bannerSidebar');
        var dots = document.getElementById('bannerDots');
        if (!banner || !inner || !sidebar || !dots) return false;
        var items = rows(data.carousel);
        if (!items.length) { banner.hidden = true; return false; }
        var side = '', content = '', progress = '';
        items.forEach(function (item, index) {
            var title = escapeHtml(item.title);
            var image = escapeHtml(item.mobile_image_url || item.desktop_image_url || item.media_url || '');
            var video = item.media_type === 'video';
            var theme = function (value) { return value === 'white' ? 'white' : 'black'; };
            side += '<div class="banner-nav-item' + (index ? '' : ' active') + '" data-index="' + index + '">' + title + '</div>';
            content += '<div class="banner-item banner-item-' + (video ? 'video' : 'image') + ' pc-theme-' + theme(item.pc_theme) + ' mobile-theme-' + theme(item.mobile_theme) + (index ? '' : ' active') + '" data-index="' + index + '">';
            if (video) content += '<video class="banner-video" autoplay muted loop playsinline preload="metadata" poster="' + escapeHtml(item.poster_url || '') + '"><source src="' + escapeHtml(item.media_url || '') + '" type="video/mp4"></video>';
            content += '<img src="' + image + '" class="banner-mobile-img" alt="' + title + '">';
            if (Number(item.text_visible) !== 0) {
                content += '<div class="banner-text-wrapper"><div class="banner-text">';
                if (item.label_text || item.label_badge) content += '<div class="banner-label-row">' + (item.label_text ? '<span class="banner-label-text">' + escapeHtml(item.label_text) + '</span>' : '') + (item.label_badge ? '<span class="banner-label">' + escapeHtml(item.label_badge) + '</span>' : '') + '</div>';
                content += '<h1 class="banner-title">' + title + '</h1>' + (item.description ? '<p class="banner-desc">' + escapeHtml(item.description) + '</p>' : '');
                var link = item.jump_type === 'none' ? '' : (item.link_url || item.jump_url);
                if (link) content += '<a href="' + escapeHtml(link) + '" class="banner-btn"' + (Number(item.new_tab) ? ' target="_blank" rel="noopener noreferrer"' : '') + '>' + escapeHtml(item.button_text || '了解详情') + '</a>';
                content += '<div class="banner-dots-inline">' + items.map(function (_, dotIndex) { return '<button class="banner-dot inline-dot' + (dotIndex === index ? ' active' : '') + '" data-index="' + dotIndex + '"><span class="dot-progress"></span></button>'; }).join('') + '</div></div></div>';
            }
            content += '</div>';
            progress += '<button class="banner-dot' + (index ? '' : ' active') + '" data-index="' + index + '"><span class="dot-progress"></span></button>';
        });
        sidebar.innerHTML = side;
        inner.innerHTML = content;
        dots.innerHTML = progress;
        return true;
    }

    function renderFeatures(data) {
        if (!enabled(data, 'feature')) return;
        var list = document.getElementById('featureList');
        if (!list) return;
        list.innerHTML = rows(data.features).map(function (item) {
            return '<a href="' + escapeHtml(item.link_url || '#') + '" class="feature-entry-item"><div class="feature-icon"><img src="' + escapeHtml(item.icon_url || '') + '" alt="' + escapeHtml(item.title) + '"></div><div class="feature-info"><h3 class="feature-title">' + escapeHtml(item.title) + '</h3><p class="feature-desc">' + escapeHtml(item.description || '') + '</p></div><div class="feature-arrow"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="7" y1="17" x2="17" y2="7"></line><polyline points="7 7 17 7 17 17"></polyline></svg></div></a>';
        }).join('');
    }

    function renderNavigation(data) {
        if (!enabled(data, 'topnav')) return;
        var nav = document.getElementById('publicNav');
        var mobile = document.querySelector('.mobile-menu-left .mobile-menu-list');
        if (!nav) return;
        var base = Array.prototype.slice.call(nav.children, 0, 2);
        nav.replaceChildren.apply(nav, base);
        var items = rows(data.topNav);
        var roots = items.filter(function (item) { return Number(item.parent_id) === 0; });
        roots.forEach(function (root) {
            if (root.title === '首页' || (root.link_url === '/' && root.menu_type === 'route')) {
                if (base[0]) {
                    var homeLink = base[0].querySelector('a');
                    if (homeLink) {
                        homeLink.textContent = root.title || '首页';
                        homeLink.href = root.link_url || '/';
                    }
                }
                return;
            }
            if (root.menu_type === 'product') {
                var productTitle = base[1] && base[1].querySelector('.nav-parent');
                if (productTitle) Array.prototype.slice.call(productTitle.childNodes).forEach(function (node) {
                    if (node.nodeType === Node.TEXT_NODE && node.textContent.trim()) node.textContent = ' ' + root.title + ' ';
                });
                return;
            }
            var children = items.filter(function (item) { return Number(item.parent_id) === Number(root.id); });
            var li = document.createElement('li');
            var mega = children.length && (root.menu_type === 'mega' || root.menu_type === 'solution');
            li.className = mega ? 'has-mega' : (children.length ? 'has-dropdown' : '');
            var link = document.createElement('a');
            link.className = 'nav-parent';
            link.href = root.link_url || '#';
            link.textContent = root.title || '';
            li.appendChild(link);
            if (mega) {
                var panel = document.createElement('div');
                panel.className = 'mega-menu';
                var inner = document.createElement('div');
                inner.className = 'mega-menu-inner';
                var left = document.createElement('div');
                left.className = 'mega-menu-left mega-cat-list';
                var right = document.createElement('div');
                right.className = 'mega-menu-right';
                var content = document.createElement('div');
                content.className = 'mega-solution-content';
                children.forEach(function (child, index) {
                    var category = document.createElement('button');
                    category.type = 'button';
                    category.className = 'mega-cat-item' + (index ? '' : ' active');
                    category.textContent = child.title || '';
                    var group = document.createElement('div');
                    group.className = 'mega-solution-group';
                    group.style.display = index ? 'none' : 'grid';
                    items.filter(function (third) { return Number(third.parent_id) === Number(child.id); }).forEach(function (third) {
                        var card = document.createElement('a');
                        card.className = 'mega-solution-card';
                        card.href = third.link_url || '#';
                        var name = document.createElement('div');
                        name.className = 'mega-solution-name';
                        name.textContent = third.title || '';
                        card.appendChild(name);
                        if (third.menu_desc) {
                            var desc = document.createElement('div');
                            desc.className = 'mega-solution-desc';
                            desc.textContent = third.menu_desc;
                            card.appendChild(desc);
                        }
                        group.appendChild(card);
                    });
                    category.addEventListener('click', function () {
                        left.querySelectorAll('.mega-cat-item').forEach(function (item) { item.classList.remove('active'); });
                        content.querySelectorAll('.mega-solution-group').forEach(function (item) { item.style.display = 'none'; });
                        category.classList.add('active');
                        group.style.display = 'grid';
                    });
                    left.appendChild(category);
                    content.appendChild(group);
                });
                right.appendChild(content);
                inner.appendChild(left);
                inner.appendChild(right);
                panel.appendChild(inner);
                li.appendChild(panel);
                link.addEventListener('click', function (event) { if (!root.link_url) { event.preventDefault(); li.classList.toggle('active'); } });
                li.addEventListener('mouseenter', function () { li.classList.add('active'); });
                li.addEventListener('mouseleave', function () { li.classList.remove('active'); });
            } else if (children.length) {
                var dropdown = document.createElement('ul');
                dropdown.className = 'nav-dropdown';
                children.forEach(function (child) {
                    var sub = document.createElement('li');
                    var childLink = document.createElement('a');
                    childLink.href = child.link_url || '#';
                    childLink.textContent = child.title || '';
                    sub.appendChild(childLink);
                    dropdown.appendChild(sub);
                });
                li.appendChild(dropdown);
                li.addEventListener('mouseenter', function () { li.classList.add('active'); });
                li.addEventListener('mouseleave', function () { li.classList.remove('active'); });
            }
            nav.appendChild(li);
        });
        if (mobile) {
            Array.prototype.slice.call(mobile.children, 2).forEach(function (node) { node.remove(); });
            roots.forEach(function (root) {
                if (root.title === '首页' || (root.link_url === '/' && root.menu_type === 'route') || root.menu_type === 'product') return;
                function mobileLink(item, depth) {
                    var li = document.createElement('li');
                    li.className = 'mobile-menu-item';
                    var anchor = document.createElement('a');
                    anchor.className = 'mobile-menu-link';
                    anchor.href = item.link_url || '#';
                    anchor.textContent = item.title || '';
                    anchor.style.paddingLeft = (12 + depth * 16) + 'px';
                    li.appendChild(anchor);
                    mobile.appendChild(li);
                }
                mobileLink(root, 0);
                items.filter(function (item) { return Number(item.parent_id) === Number(root.id); }).forEach(function (child) {
                    mobileLink(child, 1);
                    items.filter(function (item) { return Number(item.parent_id) === Number(child.id); }).forEach(function (third) { mobileLink(third, 2); });
                });
            });
        }
        document.dispatchEvent(new CustomEvent('ape:navigation-ready'));
    }

    function renderModules(data) {
        if (!enabled(data, 'web_module')) return;
        var side = rows(data.modules).filter(function (item) { return item.category === '侧边导航'; });
        if (!enabled(data, 'footernav')) {
            var bottom = rows(data.modules).filter(function (item) { return item.category === '底部菜单'; });
            var footerNav = document.getElementById('footerNav');
            if (footerNav && bottom.length) footerNav.innerHTML = bottom.map(function (group) {
                var links;
                try { links = JSON.parse(group.description || '[]'); } catch (error) { links = []; }
                return '<div class="footer-nav-col"><h5 class="footer-title">' + escapeHtml(group.title) + '</h5><ul class="footer-links list-unstyled">' + rows(links).filter(function (item) { return Number(item.status) !== 0; }).map(function (item) {
                    return '<li><a href="' + escapeHtml(safeUrl(item.url) || '#') + '">' + escapeHtml(item.name || '') + '</a></li>';
                }).join('') + '</ul></div>';
            }).join('');
        }
        function config(name) {
            var item = side.find(function (row) { return row.title === name; });
            if (!item) return null;
            try { return JSON.parse(item.description || 'null'); } catch (error) { return null; }
        }
        var online = config('online_service');
        if (online && typeof online === 'object') {
            var avatar = document.querySelector('#apeFloats .side-toolbar-avatar img');
            var label = document.querySelector('#apeFloats .avatar-label');
            if (avatar && online.service_image) avatar.src = online.service_image;
            if (label && online.btn_text) label.textContent = online.btn_text;
            var avatarLink = safeUrl(online.jump_url);
            if (avatar && avatarLink) avatar.closest('.side-toolbar-avatar').addEventListener('click', function () { window.open(avatarLink, '_blank', 'noopener'); });
        }
        var qq = config('qq_service');
        var qqRows = rows(qq && qq.rows ? qq.rows : qq);
        if (qqRows.length) {
            var qqPopup = document.querySelector('#sideToolbar .side-toolbar-item:first-child .side-toolbar-popup');
            if (qqPopup) qqPopup.innerHTML = '<div class="popup-title">联系客服</div>' + qqRows.filter(function (row) { return Number(row.display) !== 0; }).map(function (row) {
                var number = String(row.name || '').replace(/\D/g, '');
                var href = number ? 'https://wpa.qq.com/msgrd?v=3&amp;uin=' + encodeURIComponent(number) + '&amp;site=qq&amp;menu=yes' : '#';
                return '<a class="popup-contact-row" href="' + href + '" target="_blank" rel="noopener noreferrer"><span class="popup-contact-name">' + escapeHtml(row.group || row.name || '') + '</span>' + (row.avatar ? '<span class="popup-contact-desc">' + escapeHtml(row.avatar) + '</span>' : '') + '</a>';
            }).join('');
        }
        var tickets = config('ticket_content');
        if (Array.isArray(tickets)) {
            var ticketPopup = document.querySelector('#sideToolbar .side-toolbar-item:nth-child(2) .side-toolbar-popup');
            if (ticketPopup) ticketPopup.innerHTML = '<div class="popup-title">工单服务</div>' + tickets.map(function (row) {
                return '<a class="popup-ticket-row" href="' + escapeHtml(safeUrl(row.url || row.link) || '/supporttickets') + '"><span class="popup-ticket-name">' + escapeHtml(row.name || row.title || '') + '</span>' + (row.desc ? '<span class="popup-ticket-desc">' + escapeHtml(row.desc) + '</span>' : '') + '</a>';
            }).join('');
        }
        var qrcodes = config('qrcode');
        if (Array.isArray(qrcodes)) {
            var qr = document.querySelector('#apeFloats .side-toolbar-wechat .side-toolbar-popup');
            var footer = document.querySelector('.footer-qr-codes');
            var html = qrcodes.filter(function (row) { return row.image; }).map(function (row) {
                return '<div class="popup-qrcode"><img src="' + escapeHtml(row.image) + '" alt="' + escapeHtml(row.desc || '') + '"><div class="popup-qrcode-desc">' + escapeHtml(row.desc || '') + '</div></div>';
            }).join('');
            if (qr) qr.innerHTML = '<div class="popup-title">扫码关注</div>' + html;
            if (footer) footer.innerHTML = qrcodes.filter(function (row) { return row.image; }).map(function (row) {
                return '<div class="qr-item"><img class="footer-qr-img" src="' + escapeHtml(row.image) + '" alt="' + escapeHtml(row.desc || '') + '"><span>' + escapeHtml(row.desc || '') + '</span></div>';
            }).join('');
        }
    }

    function renderFooter(data) {
        if (!enabled(data, 'footernav')) return;
        var nav = document.getElementById('footerNav');
        if (!nav) return;
        var groups = {};
        rows(data.footerNav).forEach(function (item) { (groups[item.category || '其他'] || (groups[item.category || '其他'] = [])).push(item); });
        nav.innerHTML = Object.keys(groups).map(function (category) {
            return '<div class="footer-nav-col"><h5 class="footer-title">' + escapeHtml(category) + '</h5><ul class="footer-links list-unstyled">' + groups[category].map(function (item) { return '<li><a href="' + escapeHtml(item.link_url || '#') + '">' + escapeHtml(item.title) + '</a></li>'; }).join('') + '</ul></div>';
        }).join('');
    }

    function renderPopup(data) {
        if (!enabled(data, 'popup')) return;
        window.apePluginPopupManaged = true;
        var item = rows(data.popup)[0];
        var trigger = document.getElementById('apeNoticeFloatBtn');
        var overlay = document.getElementById('popupOverlay');
        if (!item) { if (trigger) trigger.hidden = true; return; }
        if (!overlay) return;
        var title = overlay.querySelector('.popup-header h3');
        var body = overlay.querySelector('.popup-content');
        var footer = overlay.querySelector('.popup-footer');
        if (title) title.textContent = item.title || '网站通知';
        if (body) body.innerHTML = item.content || '';
        if (footer && item.link_url) {
            var link = document.createElement('a');
            link.className = 'popup-btn popup-btn-link';
            link.href = item.link_url;
            link.textContent = item.button_text || '查看详情';
            footer.appendChild(link);
        }
        var alreadyShown = false;
        if (item.show_type === 'once') {
            try {
                alreadyShown = !!localStorage.getItem('abcloud_popup_' + item.id);
                if (!alreadyShown) localStorage.setItem('abcloud_popup_' + item.id, '1');
            } catch (error) { alreadyShown = false; }
        }
        if (!alreadyShown) {
            overlay.style.display = 'flex';
            overlay.setAttribute('aria-hidden', 'false');
        }
    }

    function applyConfig(data) {
        var config = data.config || {};
        window.apeCarouselConfig = config;
        var banner = document.getElementById('banner');
        if (banner) {
            if (config.switch_effect) banner.dataset.effect = config.switch_effect;
            if (config.carousel_height) banner.style.setProperty('--banner-height', parseInt(config.carousel_height, 10) + 'px');
        }
        var logo = document.getElementById('apeSiteLogo');
        if (logo && config.official_website_logo) logo.src = config.official_website_logo;
    }

    document.addEventListener('DOMContentLoaded', function () {
        var controller = typeof AbortController === 'function' ? new AbortController() : null;
        var timer;
        var timeout = new Promise(function (resolve, reject) {
            timer = setTimeout(function () {
                reject(new Error('Plugin request timed out'));
                if (controller) controller.abort();
            }, 8000);
        });
        var request = Promise.resolve().then(function () {
            var options = {credentials: 'same-origin'};
            if (controller) options.signal = controller.signal;
            return fetch('/abcloud/content', options);
        }).then(function (response) {
            if (!response.ok) throw new Error('Plugin unavailable');
            return response.json();
        });
        Promise.race([request, timeout]).then(function (result) {
            clearTimeout(timer);
            if (!result || result.code !== 0 || !result.data) throw new Error('Plugin data invalid');
            var data = result.data;
            applyConfig(data);
            renderFeatures(data);
            renderNavigation(data);
            renderFooter(data);
            renderModules(data);
            renderPopup(data);
            var carouselReady = renderCarousel(data);
            if (window.apeCarouselDataReady) window.apeCarouselDataReady(carouselReady);
        }).catch(function () {
            clearTimeout(timer);
            if (window.apeCarouselDataReady) window.apeCarouselDataReady(true);
        });
    });
})();
