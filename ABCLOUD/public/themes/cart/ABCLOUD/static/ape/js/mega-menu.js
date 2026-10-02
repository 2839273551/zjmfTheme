// Mega Menu 功能 - 已改为数据库驱动，由 ape-data.js 统一渲染
// 此文件保留移动端菜单开关逻辑（所有页面共用，故统一放在此文件）

(function () {
    'use strict';

    // 移动端菜单开关
    function initMobileMenu() {
        var hamburger = document.querySelector('.public-header-right-m-nav-btn.hamburger');
        var overlay = document.querySelector('.mobile-menu-overlay');
        var body = document.body;

        if (!hamburger || !overlay) {
            return;
        }

        function closeMenu() {
            body.classList.remove('menu-open');
            hamburger.classList.remove('active');
        }

        function openMenu() {
            body.classList.add('menu-open');
            hamburger.classList.add('active');
        }

        function toggleMenu() {
            var isOpen = body.classList.contains('menu-open');
            if (isOpen) {
                closeMenu();
            } else {
                openMenu();
            }
        }

        hamburger.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            toggleMenu();
        });

        // 点击遮罩空白区域关闭
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) {
                closeMenu();
            }
        });

        // 点击菜单链接后关闭
        overlay.addEventListener('click', function (e) {
            if (e.target.closest('.mobile-menu-link')) {
                closeMenu();
            }
        });

        // ESC 键关闭
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' || e.keyCode === 27) {
                closeMenu();
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initMobileMenu);
    } else {
        initMobileMenu();
    }
})();
