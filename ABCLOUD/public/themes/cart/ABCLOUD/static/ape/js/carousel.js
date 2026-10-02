// 轮播图功能（数据渲染完成后由 ape-data.js 调用 apeCarouselDataReady 触发初始化）
(function () {
    var domReady = false;
    var dataReady = false;
    var inited = false;

    document.addEventListener('DOMContentLoaded', function () {
        domReady = true;
        initScrollEffects();
        tryInit();
    });

    // 由 ape-data.js 在轮播数据渲染完成后调用；ok=false 表示无轮播数据
    window.apeCarouselDataReady = function (ok) {
        dataReady = !!ok;
        tryInit();
    };

    function tryInit() {
        if (domReady && dataReady && !inited) {
            inited = true;
            initCarousel();
        }
    }

    function initCarousel() {
    // 轮播速度：读取后台「轮播图全局设置」，未设置时默认 5000ms
    var cfg = window.apeCarouselConfig || {};
    var INTERVAL = parseInt(cfg.carousel_speed, 10) || 5000;
    const banner = document.getElementById('banner');
    if (!banner) return;
    banner.setAttribute('data-direction', 'next');

    const items = banner.querySelectorAll('.banner-item');
    const videos = banner.querySelectorAll('.banner-video');
    const mobileImgs = banner.querySelectorAll('.banner-mobile-img');
    const total = items.length;
    if (total === 0) return;
    const prevBtn = document.getElementById('bannerPrev');
    const nextBtn = document.getElementById('bannerNext');

    // 顶层侧边栏和进度条
    const sidebar = document.getElementById('bannerSidebar');
    const navItems = sidebar ? sidebar.querySelectorAll('.banner-nav-item') : [];
    const dotsContainer = document.getElementById('bannerDots');
    const dots = dotsContainer ? dotsContainer.querySelectorAll('.banner-dot') : [];
    // 内嵌进度条（按钮下方）
    const inlineDots = banner.querySelectorAll('.inline-dot');

    let current = 0;
    let timer = null;
    let touchStartX = 0;

    // 更新侧边栏和进度条状态
    function updateControls(activeIndex) {
        // 更新侧边栏导航
        navItems.forEach(function (nav) {
            var navIdx = parseInt(nav.getAttribute('data-index'));
            if (navIdx === activeIndex) {
                nav.classList.add('active');
            } else {
                nav.classList.remove('active');
            }
        });

        // 同步所有进度条（底部 + 内嵌）
        var allDots = banner.querySelectorAll('.banner-dot');
        allDots.forEach(function (dot) {
            var dotIdx = parseInt(dot.getAttribute('data-index'));
            var prog = dot.querySelector('.dot-progress');
            if (dotIdx === activeIndex) {
                dot.classList.add('active');
                if (prog) {
                    void prog.offsetWidth;
                    prog.style.animation = 'dot-progress-anim ' + (INTERVAL / 1000) + 's linear';
                }
            } else {
                dot.classList.remove('active');
                if (prog) prog.style.animation = 'none';
            }
        });
    }

    // 显示指定索引的轮播项
    function show(index) {
        // 暂停所有视频
        videos.forEach(function (v) { v.pause(); });

        // 重置入场动画
        videos.forEach(function (v) {
            v.classList.remove('banner-entrance-anim');
        });
        mobileImgs.forEach(function (img) {
            img.classList.remove('banner-entrance-anim');
        });

        var effect = (window.apeCarouselConfig || {}).switch_effect || 'default';

        // 深度优化：方向感知 + 出/入场同时过渡（默认=淡入淡出交叉，翻页/3D=方向滑动/翻转）
        var prevItem = items[current];
        if (prevItem && current !== index) {
            // 判断切换方向：next=向后翻，prev=向前翻
            var goingNext = ((index - current + total) % total) === 1;
            banner.setAttribute('data-direction', goingNext ? 'next' : 'prev');

            var incoming = items[index];
            // 上一张标记为"离开"，滑出/翻转/淡出同时进行
            prevItem.classList.add('leaving');
            // 上一张时，下一张从左侧/反向入场
            if (!goingNext) {
                incoming.classList.add('from-prev');
            }
            setTimeout(function () {
                prevItem.classList.remove('leaving');
                incoming.classList.remove('from-prev');
            }, 1000);
        }

        // 移除所有banner-item的active状态
        items.forEach(function (item) {
            item.classList.remove('active');
        });

        // 设置当前项active
        current = index;
        items[current].classList.add('active');

        // 更新侧边栏和进度条
        updateControls(current);

        if (effect === 'default') {
            // 默认淡入淡出：播放当前视频并触发入场动画
            if (videos[current]) {
                videos[current].currentTime = 0;
                void videos[current].offsetWidth;
                videos[current].classList.add('banner-entrance-anim');
                videos[current].play().catch(function () {});
            }
            // 移动端图片入场动画
            if (mobileImgs[current]) {
                void mobileImgs[current].offsetWidth;
                mobileImgs[current].classList.add('banner-entrance-anim');
            }
        } else {
            // 翻页/3D翻转：过渡由位移/旋转完成，仅播放当前视频
            if (videos[current]) {
                videos[current].currentTime = 0;
                videos[current].play().catch(function () {});
            }
        }
    }

    function next() {
        show((current + 1) % total);
    }

    function prev() {
        show((current - 1 + total) % total);
    }

    function startAuto() {
        stopAuto();
        if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
        timer = setInterval(next, INTERVAL);
    }

    function stopAuto() {
        if (timer) { clearInterval(timer); timer = null; }
    }

    // 点击进度条（底部 + 内嵌）
    banner.addEventListener('click', function (e) {
        var dot = e.target.closest('.banner-dot');
        if (dot) {
            var idx = parseInt(dot.getAttribute('data-index'));
            if (idx !== current) {
                show(idx);
                startAuto();
            }
        }
    });

    // 点击侧边栏导航项
    navItems.forEach(function (nav) {
        nav.addEventListener('click', function () {
            var idx = parseInt(this.getAttribute('data-index'));
            if (idx !== current) {
                show(idx);
                startAuto();
            }
        });
    });

    // 左右切换按钮
    if (prevBtn) {
        prevBtn.addEventListener('click', function () {
            prev();
            startAuto();
        });
    }
    if (nextBtn) {
        nextBtn.addEventListener('click', function () {
            next();
            startAuto();
        });
    }

    // 鼠标拖拽滑动
    banner.addEventListener('mousedown', function (e) {
        touchStartX = e.clientX;
        stopAuto();
    });
    banner.addEventListener('mouseup', function (e) {
        var diff = e.clientX - touchStartX;
        if (Math.abs(diff) > 50) {
            if (diff < 0) show((current + 1) % total);
            else show((current - 1 + total) % total);
        }
        startAuto();
    });

    // 触摸滑动（移动端）
    banner.addEventListener('touchstart', function (e) {
        touchStartX = e.touches[0].clientX;
        stopAuto();
    }, { passive: true });
    banner.addEventListener('touchend', function (e) {
        var diff = e.changedTouches[0].clientX - touchStartX;
        if (Math.abs(diff) > 50) {
            if (diff < 0) show((current + 1) % total);
            else show((current - 1 + total) % total);
        }
        startAuto();
    });

    // 响应式：移动端显示图片、隐藏视频；桌面端视频项显示视频、图片项显示图片
    function checkMobile() {
        var isMobile = window.innerWidth <= 768;
        videos.forEach(function (v) { v.style.display = isMobile ? 'none' : 'block'; });
        mobileImgs.forEach(function (img) {
            // 视频项的移动端备用图在桌面端隐藏；图片项在所有端都显示
            var item = img.closest('.banner-item');
            var isVideoItem = item && item.classList.contains('banner-item-video');
            img.style.display = (isMobile || !isVideoItem) ? 'block' : 'none';
        });
    }
    checkMobile();
    window.addEventListener('resize', checkMobile);

    // 启动：首屏已有 active，初始化控制元素状态
    updateControls(0);
    if (videos[0]) {
        videos[0].currentTime = 0;
        videos[0].play().catch(function () {});
    }
    startAuto();

    }

    function initScrollEffects() {
    // 快捷入口区域滚动入场动画
    var featureSection = document.querySelector('.feature-buttons-section');
    if (featureSection && 'IntersectionObserver' in window) {
        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    featureSection.classList.add('animate-in');
                    observer.unobserve(featureSection);
                }
            });
        }, { threshold: 0.15 });
        observer.observe(featureSection);
    }

    // 合作伙伴区域滚动入场动画（简单淡入）
    var partnerSection = document.querySelector('.partner-section');
    if (partnerSection && 'IntersectionObserver' in window) {
        var partnerObserver = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    partnerObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });
        partnerObserver.observe(partnerSection);
    }

    // 通用滚动入场动画 - 为各section/div添加滑动过渡
    if ('IntersectionObserver' in window) {
        var scrollTargets = document.querySelectorAll(
            '.cloud-market-section, .cloud-market-header, .cloud-market-left, .cloud-market-right, .cloud-market-item, ' +
            '.industry-solutions-section, .is-header, .is-tabs, .is-panel, ' +
            '.global-infra-section, .global-infra-header, .global-infra-body, .global-infra-certs, .stat-item, ' +
            '.container_bg1, .sk-title-container, .chooseUs-itme, ' +
            '.news-section, .news-section-header, .news-layout, .news-featured, .news-list-wrap'
        );
        scrollTargets.forEach(function (el) {
            el.classList.add('scroll-animate');
        });
        var scrollObserver = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    scrollObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1, rootMargin: '0px 0px -40px 0px' });
        scrollTargets.forEach(function (el) {
            scrollObserver.observe(el);
        });
    }
    }
})();
