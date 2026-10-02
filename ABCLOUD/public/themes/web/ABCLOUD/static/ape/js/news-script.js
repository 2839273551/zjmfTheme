// 新闻加载脚本
(function() {
  if (document.body.getAttribute('data-news-loading') === 'true') return;
  document.body.setAttribute('data-news-loading', 'true');

  function initNews() {
    const newsTabs = document.querySelectorAll('.news-tab');
    const newsFeatured = document.getElementById('newsFeatured');
    const newsListItems = document.getElementById('newsListItems');
    if (!newsFeatured || !newsListItems) {
      document.body.removeAttribute('data-news-loading');
      return;
    }

    var emptyHtml = '<div class="news-list-empty"><img src="/themes/web/ABCLOUD/static/ape/img/mynr.png" alt="暂无数据"><p>未发布任何内容</p></div>';

    let currentType = 'announce';

    function loadNews(type) {
      currentType = type;
      // 先设置加载状态
      newsListItems.innerHTML = '<div class="news-list-loading">加载中...</div>';
      // 左侧精选文章:从右到左滑动
      newsFeatured.classList.remove('news-slide-in-right');
      void newsFeatured.offsetWidth;
      newsFeatured.classList.add('news-slide-in-right');
      // 右侧列表:从左到右滑动
      newsListItems.classList.remove('news-slide-in-left');
      void newsListItems.offsetWidth;
      newsListItems.classList.add('news-slide-in-left');

      window.apeFinance.updates(type).then(function (items) {
        if (type !== currentType) return;
        renderNews(items, type);
      }).catch(function () {
        if (type !== currentType) return;
        newsFeatured.querySelector('.news-featured-title').textContent = '内容暂时无法加载';
        newsListItems.innerHTML = '<div class="news-list-empty"><p>内容暂时无法加载，<a href="/news">前往新闻中心</a></p></div>';
      }).finally(function () {
        document.body.removeAttribute('data-news-loading');
      });
    }

    function getThumb(item) {
      var image = item.head_img || item.img || '';
      try {
        var url = new URL(image, location.origin);
        if (image && /^https?:$/.test(url.protocol)) return url.href;
      } catch (error) {}
      return '/themes/web/ABCLOUD/static/ape/img/zx.png';
    }

    function renderNews(list, type) {
      // 精选文章（第一条）
      if (list.length > 0) {
        const first = list[0];
        const date = formatDate(first.push_time || first.create_time || first.created_at);
        const title = first.title || '暂无标题';
        const thumb = getThumb(first);
        const detailLink = '/newsview?id=' + window.apeFinance.id(first.id);
        const categoryLink = '/news';

        newsFeatured.querySelector('.news-featured-img img').src = thumb;
        newsFeatured.querySelector('.news-featured-date').textContent = '发布日期：' + date;
        newsFeatured.querySelector('.news-featured-title').textContent = title;

        // 图片和标题跳转到详情页面
        const detailLinks = newsFeatured.querySelectorAll('.news-featured-detail-link');
        detailLinks.forEach(function(link) {
          link.href = detailLink;
        });

        // 按钮跳转到分类页面
        newsFeatured.querySelector('.news-featured-btn').href = categoryLink;
      }

      if (!list.length) {
        newsFeatured.querySelector('.news-featured-date').textContent = '';
        newsFeatured.querySelector('.news-featured-title').textContent = '未发布任何内容';
        newsFeatured.querySelectorAll('a').forEach(function (link) { link.href = '/news'; });
        newsFeatured.querySelector('.news-featured-img img').src = '/themes/web/ABCLOUD/static/ape/img/zx.png';
      }
      // 列表（除第一条外）
      let html = '';
      for (let i = 1; i < list.length; i++) {
        const item = list[i];
        const date = formatDate(item.push_time || item.create_time || item.created_at);
        const title = item.title || '暂无标题';
        const thumb = getThumb(item);
        const link = '/newsview?id=' + window.apeFinance.id(item.id);

        html += '<a href="' + link + '" class="news-list-item">'
          + '<div class="news-list-item-img"><img src="' + escapeHtml(thumb) + '" alt="' + escapeHtml(title) + '"></div>'
          + '<div class="news-list-item-info">'
          + '<div class="news-list-item-title">' + escapeHtml(title) + '</div>'
          + '<div class="news-list-item-date">' + date + '</div>'
          + '</div></a>';
      }

      newsListItems.innerHTML = html || emptyHtml;
    }

    function formatDate(timestamp) {
      if (!timestamp || isNaN(timestamp)) return '--';
      const time = String(timestamp).length < 13 ? timestamp * 1000 : timestamp;
      const date = new Date(time);
      if (date.toString() === 'Invalid Date') return '--';
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      return year + '-' + month + '-' + day;
    }

    function escapeHtml(str) {
      if (!str) return '';
      const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
      return String(str).replace(/[&<>"']/g, function(m) { return map[m]; });
    }

    // 标签切换
    newsTabs.forEach(function(tab) {
      tab.addEventListener('click', function() {
        newsTabs.forEach(function(t) { t.classList.remove('active'); });
        this.classList.add('active');
        loadNews(this.getAttribute('data-type'));
      });
    });

    // 初始加载
    loadNews('announce');
  }

  // 直接执行，因为脚本已在页面底部加载
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initNews);
  } else {
    initNews();
  }
})();
