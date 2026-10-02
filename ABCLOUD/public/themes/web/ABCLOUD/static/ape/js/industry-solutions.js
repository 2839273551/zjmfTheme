// 行业解决方案标签切换
document.addEventListener('DOMContentLoaded', function() {
    var tabs = document.querySelectorAll('.is-tab');
    var panels = document.querySelectorAll('.is-panel');
    var bgLayer = document.getElementById('isBgLayer');
    var overlayImgs = document.querySelectorAll('.is-overlay-img');

    tabs.forEach(function(tab) {
        tab.addEventListener('click', function() {
            var target = this.dataset.target;
            var bg = this.dataset.bg;

            // 切换标签
            tabs.forEach(function(t) { t.classList.remove('active'); });
            this.classList.add('active');

            // 切换面板
            panels.forEach(function(p) { p.classList.remove('active'); });
            var panel = document.getElementById(target);
            if (panel) panel.classList.add('active');

            // 切换背景图
            if (bgLayer && bg) {
                bgLayer.style.backgroundImage = "url('" + bg + "')";
            }

            // 切换 overlay 图片
            overlayImgs.forEach(function(img) { img.classList.remove('active'); });
            var overlayImg = document.querySelector('.is-overlay-img[data-target="' + target + '"]');
            if (overlayImg) overlayImg.classList.add('active');
        });
    });
});
