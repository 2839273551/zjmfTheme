(function () {
  'use strict';
  var C = window.PLUGIN_CONTEXT || {};
  var state = { editId: 0, resources: [], resourceParent: 0 };

  var configLabels = {
    switch_effect: '切换特效',
    carousel_speed: '轮播播放间隔',
    carousel_height: '轮播图高度',
    progress_height: '进度条高度',
    progress_bar: '进度条粗细',
    video_zoom: '视频放大尺寸',
    error_image: '异常占位图',
    site_name: '网站名称',
    site_keywords: '网站关键词',
    site_description: '网站描述',
    service_phone: '客服电话',
    service_email: '客服邮箱',
    company_intro: '公司简介',
    official_website_logo: '官网标志图片'
  };
  var configHints = {
    switch_effect: '轮播图切换过渡动效（支持默认淡入淡出、翻页平移滑动、3D翻转）',
    carousel_speed: '自动轮换间隔时间，单位毫秒（建议 5000）',
    carousel_height: '轮播巨幕在电脑端的显示高度，例如 600px',
    progress_height: '底部进度指示条所处高度，例如 42px',
    progress_bar: '底部指示进度条线条粗细，例如 4px',
    video_zoom: '视频播放时的放大尺寸，例如 35px',
    error_image: '图片或封面加载失败时展示的异常占位图地址',
    site_name: '网站前台展示的主标题名称',
    site_keywords: 'SEO 关键词，多个关键词以逗号隔开',
    site_description: '网站 SEO 摘要描述信息',
    service_phone: '客服咨询联系电话',
    service_email: '客服服务与支持电子邮箱',
    company_intro: '公司或团队背景简介信息',
    official_website_logo: '网站顶部导航及公共区域的 Logo 图片地址'
  };

  var actionNames = { add: '新增', update: '修改', delete: '删除', sort: '排序' };
  var moduleNames = {
    carousel: '轮播图', feature: '快捷入口', topnav: '顶部导航', footernav: '底部导航',
    web_module: '通用模块', popup: '弹窗通知', config: '网站配置', carousel_global: '轮播图全局设置',
    resources: '资源库', upload: '资源上传', operation_log: '操作日志'
  };
  var showNames = { always: '每次显示', once: '仅显示一次' };

  function esc(v) {
    return (v == null ? '' : String(v)).replace(/[&<>"']/g, function (character) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[character];
    });
  }

  function api(module, action, data, method) {
    var u = new URL(C.apiUrl, window.location.origin);
    u.searchParams.set('module', module);
    u.searchParams.set('action', action || 'list');
    var opts = { method: method || 'POST', headers: { 'X-CSRF-Token': C.csrf, 'X-Requested-With': 'XMLHttpRequest' } };
    if (opts.method !== 'GET') {
      opts.headers['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8';
      var params = new URLSearchParams();
      params.append('__csrf', C.csrf);
      Object.keys(data || {}).forEach(function (k) {
        if (k === 'configs' && data[k] && typeof data[k] === 'object') {
          Object.keys(data[k]).forEach(function (sub) { params.append('configs[' + sub + ']', data[k][sub]); });
        } else if (Array.isArray(data[k])) {
          data[k].forEach(function (sub) { params.append(k + '[]', sub); });
        } else {
          params.append(k, data[k]);
        }
      });
      opts.body = params;
    }
    return fetch(u.toString(), opts).then(function (r) {
      return r.json().catch(function () { return { code: r.status, msg: '响应格式错误' }; }).then(function (x) {
        if (!r.ok || x.code !== 0) throw new Error(x.msg || '操作失败');
        return x;
      });
    });
  }

  function post(module, action, data) { return api(module, action, data, 'POST'); }

  function toast(msg, type) {
    var node = document.createElement('div');
    node.className = 'plugin-toast';
    node.setAttribute('role', 'status');
    node.textContent = msg;
    node.style.cssText = 'position:fixed;right:20px;top:20px;z-index:30000;padding:12px 18px;background:' + (type === false ? '#f56c6c' : '#303133') + ';color:#fff;border-radius:4px;box-shadow:0 3px 12px rgba(0,0,0,.16)';
    document.body.appendChild(node);
    setTimeout(function () { node.remove(); }, 3500);
  }

  function openModal(title, body) {
    document.getElementById('pluginModalTitle').textContent = title;
    document.getElementById('pluginModalBody').innerHTML = body;
    document.getElementById('pluginModal').classList.add('open');
  }

  function closeModal() {
    document.getElementById('pluginModal').classList.remove('open');
    state.editId = 0;
  }

  function field(label, name, value, type, extra, hint) {
    value = value == null ? '' : value;
    var picker = /(^|_)(url|image|icon|poster|logo)(_|$)/.test(name)
      ? '<button type="button" class="layui-btn layui-btn-sm" data-picker-field="' + esc(name) + '" title="从资源库选择" style="margin-left:8px;height:36px;line-height:36px;flex-shrink:0">选择资源</button>'
      : '';
    var control = (type === 'textarea')
      ? '<textarea class="plugin-textarea" name="' + esc(name) + '">' + esc(value) + '</textarea>'
      : '<div style="display:flex;align-items:center;max-width:520px"><input class="plugin-input" style="flex:1" name="' + esc(name) + '" value="' + esc(value) + '" ' + (extra || '') + '>' + picker + '</div>';
    var hintHtml = hint ? '<div class="plugin-field-hint">' + esc(hint) + '</div>' : '';
    return '<div class="plugin-field"><label>' + esc(label) + '</label><div>' + control + hintHtml + '</div></div>';
  }

  function choiceField(label, name, value, options, hint) {
    var selectHtml = '<div style="max-width:520px"><select class="plugin-select" style="width:100%" name="' + esc(name) + '">'
      + options.map(function (opt) {
          return '<option value="' + esc(opt[0]) + '"' + (String(opt[0]) === String(value) ? ' selected' : '') + '>' + esc(opt[1]) + '</option>';
        }).join('')
      + '</select></div>';
    var hintHtml = hint ? '<div class="plugin-field-hint">' + esc(hint) + '</div>' : '';
    return '<div class="plugin-field"><label>' + esc(label) + '</label><div>' + selectHtml + hintHtml + '</div></div>';
  }

  function switchField(label, name, value) {
    return '<div class="plugin-field"><label>' + esc(label) + '</label><div class="plugin-switch"><input type="checkbox" name="' + esc(name) + '" ' + (value ? 'checked' : '') + '><span>启用显示</span></div></div>';
  }

  function formFor(item) {
    item = item || {};
    var p = C.page;
    if (p === 'carousel') return field('标题', 'title', item.title)
      + field('描述', 'description', item.description, 'textarea')
      + choiceField('媒体类型', 'media_type', item.media_type || 'image', [['image', '图片'], ['video', '视频']])
      + field('主图地址', 'media_url', item.media_url)
      + field('电脑端图片', 'desktop_image_url', item.desktop_image_url)
      + field('手机端图片', 'mobile_image_url', item.mobile_image_url)
      + field('视频封面', 'poster_url', item.poster_url)
      + choiceField('跳转类型', 'jump_type', item.jump_type || 'custom', [['custom', '自定义链接'], ['none', '不跳转']])
      + field('跳转地址', 'jump_url', item.jump_url || item.link_url)
      + field('标签文字', 'label_text', item.label_text)
      + field('标签徽标', 'label_badge', item.label_badge)
      + field('按钮文字', 'button_text', item.button_text)
      + choiceField('电脑端文字主题', 'pc_theme', item.pc_theme || 'black', [['black', '深色文字'], ['white', '白色文字']])
      + choiceField('移动端文字主题', 'mobile_theme', item.mobile_theme || 'black', [['black', '深色文字'], ['white', '白色文字']])
      + switchField('显示文字', 'text_visible', Number(item.text_visible) !== 0)
      + switchField('新窗口打开', 'new_tab', Number(item.new_tab) === 1)
      + switchField('限时标记', 'time_limit', Number(item.time_limit) === 1)
      + field('排序', 'sort_order', item.sort_order || 0, 'text', 'type="number"')
      + switchField('状态', 'status', Number(item.status) !== 0);
    if (p === 'feature') return field('标题', 'title', item.title)
      + field('描述', 'description', item.description)
      + field('图标地址', 'icon_url', item.icon_url)
      + field('链接地址', 'link_url', item.link_url)
      + field('排序', 'sort_order', item.sort_order || 0, 'text', 'type="number"')
      + switchField('状态', 'status', Number(item.status) !== 0);
    if (p === 'topnav') return field('标题', 'title', item.title)
      + field('链接地址', 'link_url', item.link_url)
      + field('父级编号（0为顶级）', 'parent_id', item.parent_id || 0, 'text', 'type="number"')
      + choiceField('菜单类型', 'menu_type', item.menu_type || 'route', [['route', '普通链接'], ['product', '原生产品菜单'], ['mega', '三级大菜单'], ['solution', '解决方案菜单']])
      + field('推荐标签', 'recommended_tags', item.recommended_tags)
      + field('菜单描述', 'menu_desc', item.menu_desc, 'textarea')
      + field('排序', 'sort_order', item.sort_order || 0, 'text', 'type="number"')
      + switchField('状态', 'status', Number(item.status) !== 0);
    if (p === 'footernav') return field('分类', 'category', item.category)
      + field('标题', 'title', item.title)
      + field('描述', 'description', item.description)
      + field('链接地址', 'link_url', item.link_url)
      + field('图标地址', 'icon_url', item.icon_url)
      + field('排序', 'sort_order', item.sort_order || 0, 'text', 'type="number"')
      + switchField('状态', 'status', Number(item.status) !== 0);
    if (p === 'web_module') return field('分类', 'category', item.category)
      + field('标题', 'title', item.title)
      + field('内容', 'description', item.description, 'textarea')
      + field('链接地址', 'link_url', item.link_url)
      + field('图标地址', 'icon_url', item.icon_url)
      + field('图片地址', 'image_url', item.image_url)
      + field('排序', 'sort_order', item.sort_order || 0, 'text', 'type="number"')
      + switchField('状态', 'status', Number(item.status) !== 0);
    return field('标题', 'title', item.title)
      + field('内容（支持 HTML）', 'content', item.content, 'textarea')
      + field('链接地址', 'link_url', item.link_url)
      + field('按钮文字', 'button_text', item.button_text)
      + choiceField('显示方式', 'show_type', item.show_type || 'always', [['always', '每次显示'], ['once', '仅显示一次']])
      + switchField('状态', 'status', Number(item.status) !== 0);
  }

  var draggedRow = null;

  function renderItems() {
    var root = document.getElementById('itemsRoot');
    if (!root) return;
    var q = ((document.getElementById('itemSearch') || {}).value || '').toLowerCase();
    var rows = (C.items || []).filter(function (x) {
      return !q || [x.title, x.category, x.description, x.link_url].join(' ').toLowerCase().indexOf(q) > -1;
    });
    if (!rows.length) {
      root.innerHTML = '<div class="plugin-empty">暂无数据</div>';
      return;
    }
    var p = C.page;
    var head = p === 'carousel' ? '<th>图片</th><th>标题</th><th>类型</th>'
      : p === 'feature' ? '<th>图标</th><th>标题</th><th>描述</th>'
      : p === 'topnav' ? '<th>标题</th><th>链接</th><th>父级</th>'
      : p === 'footernav' ? '<th>分类</th><th>标题</th><th>链接</th>'
      : p === 'web_module' ? '<th>分类</th><th>标题</th><th>内容</th>'
      : '<th>标题</th><th>内容</th><th>显示方式</th>';
    var html = '<table class="plugin-table"><thead><tr>' + head + '<th class="col-sort-th" style="min-width:140px" title="按住拖拽或点击上下箭头快速调整显示顺序">快速排序</th><th>状态</th><th>操作</th></tr></thead><tbody>';
    rows.forEach(function (x, idx) {
      var mid = '';
      if (p === 'carousel') mid = '<td><img src="' + esc(x.mobile_image_url || x.desktop_image_url || x.media_url || '') + '"></td><td>' + esc(x.title) + '</td><td>' + ((x.media_type === 'video' || /\.(mp4|webm)(\?|#|$)/i.test(x.media_url || '')) ? '视频' : '图片') + '</td>';
      else if (p === 'feature') mid = '<td><img src="' + esc(x.icon_url || '') + '"></td><td>' + esc(x.title) + '</td><td>' + esc(x.description) + '</td>';
      else if (p === 'topnav') mid = '<td>' + esc(x.title) + '</td><td>' + esc(x.link_url) + '</td><td>' + (Number(x.parent_id) === 0 ? '0（顶级）' : esc(x.parent_id)) + '</td>';
      else if (p === 'footernav') mid = '<td>' + esc(x.category) + '</td><td>' + esc(x.title) + '</td><td>' + esc(x.link_url) + '</td>';
      else if (p === 'web_module') mid = '<td>' + esc(x.category) + '</td><td>' + esc(x.title) + '</td><td>' + esc((x.description || '').replace(/<[^>]+>/g, '').slice(0, 80)) + '</td>';
      else mid = '<td>' + esc(x.title) + '</td><td>' + esc((x.content || '').replace(/<[^>]+>/g, '').slice(0, 80)) + '</td><td>' + esc(showNames[x.show_type] || x.show_type || '每次显示') + '</td>';

      var sortCell = '<td class="col-sort">'
        + '<div class="quick-sort-cell">'
        + '<span class="drag-handle" title="按住拖拽排序">'
        + '<svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><circle cx="9" cy="6" r="1.8"/><circle cx="15" cy="6" r="1.8"/><circle cx="9" cy="12" r="1.8"/><circle cx="15" cy="12" r="1.8"/><circle cx="9" cy="18" r="1.8"/><circle cx="15" cy="18" r="1.8"/></svg>'
        + '</span>'
        + '<span class="sort-badge" title="当前显示顺序">' + (idx + 1) + '</span>'
        + '<div class="quick-sort-actions">'
        + '<button type="button" class="sort-move-btn" title="上移" onclick="PluginAdmin.moveItem(' + Number(x.id) + ', -1)"' + (idx === 0 ? ' disabled' : '') + '>▲</button>'
        + '<button type="button" class="sort-move-btn" title="下移" onclick="PluginAdmin.moveItem(' + Number(x.id) + ', 1)"' + (idx === rows.length - 1 ? ' disabled' : '') + '>▼</button>'
        + '</div>'
        + '</div>'
        + '</td>';

      html += '<tr class="sortable-row" data-id="' + Number(x.id) + '" draggable="true">'
        + mid
        + sortCell
        + '<td><span class="plugin-chip ' + (x.status ? '' : 'off') + '">' + (x.status ? '显示' : '隐藏') + '</span></td>'
        + '<td><div class="plugin-actions"><button onclick="PluginAdmin.openEditor(' + Number(x.id) + ')">编辑</button><button class="danger" onclick="PluginAdmin.remove(' + Number(x.id) + ')">删除</button></div></td>'
        + '</tr>';
    });
    root.innerHTML = html + '</tbody></table>';
    bindDragSort(root);
  }

  function bindDragSort(root) {
    var rows = root.querySelectorAll('tbody tr.sortable-row');
    rows.forEach(function (tr) {
      tr.addEventListener('dragstart', handleDragStart);
      tr.addEventListener('dragover', handleDragOver);
      tr.addEventListener('dragleave', handleDragLeave);
      tr.addEventListener('drop', handleDrop);
      tr.addEventListener('dragend', handleDragEnd);
    });
  }

  function handleDragStart(e) {
    if (e.target.closest('button, a, input, select, textarea, .plugin-chip')) {
      e.preventDefault();
      return;
    }
    draggedRow = this;
    this.classList.add('is-dragging');
    if (e.dataTransfer) {
      e.dataTransfer.effectAllowed = 'move';
      e.dataTransfer.setData('text/plain', this.dataset.id || '');
    }
  }

  function handleDragOver(e) {
    e.preventDefault();
    if (!draggedRow || draggedRow === this) return;
    if (e.dataTransfer) e.dataTransfer.dropEffect = 'move';

    var rect = this.getBoundingClientRect();
    var midY = rect.top + rect.height / 2;
    var isBelow = e.clientY > midY;

    var tbody = this.closest('tbody');
    if (tbody) {
      tbody.querySelectorAll('.drag-over-top, .drag-over-bottom').forEach(function (el) {
        if (el !== this) el.classList.remove('drag-over-top', 'drag-over-bottom');
      }, this);
    }

    if (isBelow) {
      this.classList.remove('drag-over-top');
      this.classList.add('drag-over-bottom');
    } else {
      this.classList.remove('drag-over-bottom');
      this.classList.add('drag-over-top');
    }
  }

  function handleDragLeave(e) {
    if (e.relatedTarget && this.contains(e.relatedTarget)) return;
    this.classList.remove('drag-over-top', 'drag-over-bottom');
  }

  function handleDrop(e) {
    e.preventDefault();
    e.stopPropagation();
    if (!draggedRow || draggedRow === this) return;

    var isBelow = this.classList.contains('drag-over-bottom');
    this.classList.remove('drag-over-top', 'drag-over-bottom');

    if (isBelow) {
      this.parentNode.insertBefore(draggedRow, this.nextSibling);
    } else {
      this.parentNode.insertBefore(draggedRow, this);
    }

    applyNewOrder();
  }

  function handleDragEnd() {
    if (draggedRow) {
      draggedRow.classList.remove('is-dragging');
      draggedRow = null;
    }
    var root = document.getElementById('itemsRoot');
    if (root) {
      root.querySelectorAll('.drag-over-top, .drag-over-bottom, .is-dragging').forEach(function (el) {
        el.classList.remove('drag-over-top', 'drag-over-bottom', 'is-dragging');
      });
    }
  }

  function applyNewOrder() {
    var root = document.getElementById('itemsRoot');
    if (!root) return;
    var rowEls = Array.from(root.querySelectorAll('tbody tr.sortable-row'));
    if (!rowEls.length) return;
    var newIds = rowEls.map(function (el) { return Number(el.dataset.id); });

    rowEls.forEach(function (el, idx) {
      var badge = el.querySelector('.sort-badge');
      if (badge) badge.textContent = idx + 1;
      var upBtn = el.querySelector('.sort-move-btn[title="上移"]');
      var downBtn = el.querySelector('.sort-move-btn[title="下移"]');
      if (upBtn) upBtn.disabled = (idx === 0);
      if (downBtn) downBtn.disabled = (idx === rowEls.length - 1);
    });

    var itemMap = {};
    (C.items || []).forEach(function (it) { itemMap[Number(it.id)] = it; });
    var reordered = [];
    newIds.forEach(function (id, idx) {
      if (itemMap[id]) {
        itemMap[id].sort_order = idx + 1;
        reordered.push(itemMap[id]);
      }
    });
    (C.items || []).forEach(function (it) {
      if (newIds.indexOf(Number(it.id)) < 0) {
        reordered.push(it);
      }
    });
    C.items = reordered;

    var payload = { orders: newIds };
    if (C.page === 'topnav' && itemMap[newIds[0]] && itemMap[newIds[0]].parent_id != null) {
      payload.parent_id = itemMap[newIds[0]].parent_id;
    }
    post(C.page, 'sort', payload).then(function () {
      toast('排序已保存');
    }).catch(function (e) {
      toast('保存排序失败: ' + (e.message || e), false);
      renderItems();
    });
  }

  function moveItem(id, offset) {
    var root = document.getElementById('itemsRoot');
    if (!root) return;
    var rowEls = Array.from(root.querySelectorAll('tbody tr.sortable-row'));
    var currentIndex = -1;
    for (var i = 0; i < rowEls.length; i++) {
      if (Number(rowEls[i].dataset.id) === Number(id)) {
        currentIndex = i;
        break;
      }
    }
    if (currentIndex < 0) return;
    var targetIndex = currentIndex + offset;
    if (targetIndex < 0 || targetIndex >= rowEls.length) return;

    var parent = rowEls[0].parentNode;
    var currentRow = rowEls[currentIndex];
    var targetRow = rowEls[targetIndex];

    if (offset > 0) {
      parent.insertBefore(currentRow, targetRow.nextSibling);
    } else {
      parent.insertBefore(currentRow, targetRow);
    }
    applyNewOrder();
  }

  function renderLogs() {
    var root = document.getElementById('logRoot');
    if (!root) return;
    var q = ((document.getElementById('logSearch') || {}).value || '').toLowerCase();
    var rows = (C.logs || []).filter(function (x) {
      var fullText = (esc(x.admin_name) + ' ' + (actionNames[x.action] || x.action) + ' ' + (moduleNames[x.module] || x.module) + ' ' + formatDetail(x) + ' ' + (x.ip || '')).toLowerCase();
      return !q || fullText.indexOf(q) > -1;
    });
    if (!rows.length) {
      root.innerHTML = '<div class="plugin-empty">暂无操作记录</div>';
      return;
    }
    var html = '<table class="plugin-table"><thead><tr><th>编号</th><th>时间</th><th>操作人</th><th>动作</th><th>模块</th><th>详情</th><th>IP</th></tr></thead><tbody>';
    rows.forEach(function (x) {
      html += '<tr><td>' + esc(x.id) + '</td><td>' + esc(x.created_at) + '</td><td>' + esc(x.admin_name || '系统') + '</td><td>' + esc(actionNames[x.action] || x.action) + '</td><td>' + esc(moduleNames[x.module] || x.module) + '</td><td style="max-width:360px;word-break:break-all">' + esc(formatDetail(x)) + '</td><td>' + esc(x.ip) + '</td></tr>';
    });
    root.innerHTML = html + '</tbody></table>';
  }

  function formatDetail(x) {
    if (!x) return '';
    var detail = x.detail;
    if (detail == null) return '';
    var action = x.action || '';
    var module = x.module || '';
    var modName = moduleNames[module] || module;
    var actName = actionNames[action] || action;

    var data = null;
    if (typeof detail === 'object' && detail !== null) {
      data = detail;
    } else if (typeof detail === 'string') {
      var trimmed = detail.trim();
      if ((trimmed.charAt(0) === '{' && trimmed.slice(-1) === '}') || (trimmed.charAt(0) === '[' && trimmed.slice(-1) === ']')) {
        try { data = JSON.parse(trimmed); } catch (e) { data = null; }
      }
      if (!data) return detail;
    }
    if (!data) return String(detail);

    if (data.keys && Array.isArray(data.keys)) {
      var keys = data.keys.filter(function (k) { return !/^managed_|^__/.test(k); });
      var mapped = keys.map(function (k) { return configLabels[k] || k; });
      if (!mapped.length) return '保存配置项';
      var isGlobal = keys.every(function (k) {
        return ['switch_effect','carousel_speed','carousel_height','progress_height','progress_bar','video_zoom','error_image'].indexOf(k) > -1;
      });
      if (isGlobal) return '保存轮播全局设置（' + mapped.join('、') + '）';
      var isSite = keys.every(function (k) {
        return ['site_name','site_keywords','site_description','service_phone','service_email','company_intro','official_website_logo'].indexOf(k) > -1;
      });
      if (isSite) return '保存网站基本配置（' + mapped.join('、') + '）';
      return '保存配置项（' + mapped.join('、') + '）';
    }

    if (action === 'upload' || module === 'upload' || (data.name && action === 'add' && !data.kind)) {
      return '上传文件：' + (data.name || ('编号 ' + data.id));
    }
    if (data.kind === 'dir' && action === 'add') {
      return '新建文件夹：' + (data.name || ('编号 ' + data.id));
    }
    if (action === 'update' && module === 'resources' && data.name) {
      return '重命名资源为：' + data.name + (data.id ? '（编号: ' + data.id + '）' : '');
    }
    if (data.ids && Array.isArray(data.ids)) {
      return '批量删除' + modName + '（编号: ' + data.ids.join(', ') + '）';
    }
    if (data.id != null) {
      var titlePart = data.title ? '“' + data.title + '”' : '';
      if (action === 'add') return '新增' + modName + (titlePart ? '：' + titlePart : '') + '（编号: ' + data.id + '）';
      if (action === 'update') return '修改' + modName + (titlePart ? '：' + titlePart : '') + '（编号: ' + data.id + '）';
      if (action === 'delete') return '删除' + modName + (titlePart ? '：' + titlePart : '') + '（编号: ' + data.id + '）';
      return actName + modName + '（编号: ' + data.id + '）';
    }
    if (data.parent_id != null && module === 'topnav') {
      return Number(data.parent_id) === 0 ? '调整顶级导航显示顺序' : ('调整子导航显示顺序（父级编号: ' + data.parent_id + '）');
    }
    if (action === 'sort') {
      return '调整' + modName + '显示顺序';
    }
    return JSON.stringify(data);
  }

  function configForm() {
    var root = document.getElementById('configForm');
    if (!root) return;
    var global = ['switch_effect', 'carousel_speed', 'carousel_height', 'progress_height', 'progress_bar', 'video_zoom', 'error_image'];
    var site = ['site_name', 'site_keywords', 'site_description', 'service_phone', 'service_email', 'company_intro', 'official_website_logo'];
    var keys = C.page === 'carousel_global' ? global : site;
    Object.keys(C.configs || {}).forEach(function (k) {
      if (keys.indexOf(k) < 0 && !/^managed_|^__/.test(k) && C.page !== 'carousel_global') {
        keys.push(k);
      }
    });
    var html = '';
    keys.forEach(function (k) {
      var val = C.configs ? C.configs[k] : '';
      var hint = configHints[k] || '';
      if (k === 'switch_effect') {
        html += choiceField('切换特效', 'switch_effect', val || 'default', [
          ['default', '默认（淡入淡出）'],
          ['flip', '翻页滑动'],
          ['3dflip', '3D翻转']
        ], hint);
      } else if (k === 'site_description' || k === 'company_intro' || String(val || '').length > 100) {
        html += field(configLabels[k] || k, k, val, 'textarea', '', hint);
      } else {
        var extra = '';
        if (k === 'carousel_speed') extra = 'type="number" step="500" min="1000" placeholder="如 5000"';
        else if (k === 'carousel_height') extra = 'placeholder="如 600px"';
        else if (k === 'progress_height') extra = 'placeholder="如 42px"';
        else if (k === 'progress_bar') extra = 'placeholder="如 4px"';
        else if (k === 'video_zoom') extra = 'placeholder="如 35px"';
        else if (k === 'error_image') extra = 'placeholder="请输入图片路径或点击右侧选择资源"';
        else if (k === 'official_website_logo') extra = 'placeholder="请输入标志图片路径或点击右侧选择资源"';
        html += field(configLabels[k] || k, k, val, 'text', extra, hint);
      }
    });
    root.innerHTML = html;
  }

  function saveConfig() {
    var root = document.getElementById('configForm');
    var data = {};
    root.querySelectorAll('[name]').forEach(function (el) { data[el.name] = el.value; });
    post('config', 'save', { configs: data }).then(function () {
      toast('保存成功');
      Object.keys(data).forEach(function (k) { if (C.configs) C.configs[k] = data[k]; });
    }).catch(function (e) { toast(e.message, false); });
  }

  function openEditor(id) {
    state.editId = id || 0;
    var item = (C.items || []).find(function (x) { return Number(x.id) === Number(state.editId); }) || {};
    openModal((id ? '编辑' : '新增') + ((document.querySelector('.page-title') || {}).textContent || ''), formFor(item));
  }

  function submitModal() {
    var body = document.getElementById('pluginModalBody'), data = {};
    body.querySelectorAll('[name]').forEach(function (el) {
      data[el.name] = el.type === 'checkbox' ? (el.checked ? 1 : 0) : el.value;
    });
    if (state.editId) data.id = state.editId;
    post(C.page, state.editId ? 'update' : 'add', data).then(function () {
      toast('保存成功');
      closeModal();
      location.reload();
    }).catch(function (e) { toast(e.message, false); });
  }

  function remove(id) {
    if (!confirm('确定删除这条记录吗？')) return;
    post(C.page, 'delete', { id: id }).then(function () {
      toast('删除成功');
      location.reload();
    }).catch(function (e) { toast(e.message, false); });
  }

  function renderResources() {
    var root = document.getElementById(C.picker ? 'resourcePickerRoot' : 'resourceRoot');
    if (!root) return;
    var current = (state.resources || []).find(function (x) { return Number(x.id) === state.resourceParent; });
    var q = ((document.getElementById('resourceSearch') || {}).value || '').toLowerCase();
    var rows = (state.resources || []).filter(function (x) {
      return Number(x.parent_id) === state.resourceParent && (!q || String(x.name || '').toLowerCase().indexOf(q) > -1);
    });
    rows.sort(function (a, b) {
      return a.kind === b.kind ? String(a.name).localeCompare(String(b.name)) : (a.kind === 'dir' ? -1 : 1);
    });
    var html = '<div class="plugin-toolbar"><div class="left">' + (current ? '<button data-resource-action="up">返回上级</button>' : '') + '<span>' + esc(current ? current.name : '全部资源') + '</span></div></div>';
    html += '<table class="plugin-table"><thead><tr><th>编号</th><th>名称</th><th>类型</th><th>路径</th><th>操作</th></tr></thead><tbody>';
    if (!rows.length) html += '<tr><td colspan="5" class="plugin-empty">暂无资源</td></tr>';
    rows.forEach(function (x) {
      html += '<tr><td>' + esc(x.id) + '</td><td>' + esc(x.name) + '</td><td>' + (x.kind === 'dir' ? '文件夹' : '文件') + '</td><td>' + esc(x.path) + '</td><td><div class="plugin-actions">' + (x.kind === 'dir' ? '<button data-resource-action="open" data-id="' + Number(x.id) + '">打开</button>' : '<button data-resource-action="pick" data-id="' + Number(x.id) + '">选择</button>') + '<button data-resource-action="rename" data-id="' + Number(x.id) + '">重命名</button><button class="danger" data-resource-action="remove" data-id="' + Number(x.id) + '">删除</button></div></td></tr>';
    });
    root.innerHTML = html + '</tbody></table>';
  }

  function loadResources() {
    api('resources', 'list', {}, 'GET').then(function (r) {
      state.resources = r.data.items || [];
      renderResources();
    }).catch(function (e) { toast(e.message, false); });
  }

  function openPicker(name) {
    var url = new URL(C.pageUrl, window.location.origin);
    url.searchParams.set('page', 'resources');
    url.searchParams.set('picker', '1');
    url.searchParams.set('field', name);
    window.open(url.toString(), 'abcloud-resource-picker', 'width=1000,height=720,resizable=yes,scrollbars=yes');
  }

  function pick(path) {
    if (window.opener && !window.opener.closed) {
      var f = C.pickerField || 'media';
      var el = window.opener.document.getElementsByName(f)[0] || window.opener.document.getElementById(f + 'Url') || window.opener.document.getElementById(f + 'Display');
      if (el) {
        el.value = path;
        el.dispatchEvent(new Event('input', { bubbles: true }));
      }
      window.close();
    } else {
      navigator.clipboard && navigator.clipboard.writeText(path);
      toast('路径已复制');
    }
  }

  function createDir() {
    var n = prompt('文件夹名称');
    if (n) post('resources', 'mkdir', { name: n, parent_id: state.resourceParent }).then(loadResources).catch(function (e) { toast(e.message, false); });
  }

  function renameResource(id) {
    var row = state.resources.find(function (x) { return Number(x.id) === Number(id); });
    if (!row) return;
    var name = prompt('新名称', row.name);
    if (name && name !== row.name) post('resources', 'rename', { id: id, name: name }).then(loadResources).catch(function (e) { toast(e.message, false); });
  }

  function removeResource(id) {
    if (!confirm('确定删除资源吗？')) return;
    post('resources', 'delete', { id: id }).then(loadResources).catch(function (e) { toast(e.message, false); });
  }

  function openUpload() {
    var input = document.createElement('input');
    input.type = 'file';
    input.onchange = function () {
      var fd = new FormData();
      fd.append('file', input.files[0]);
      fd.append('parent_id', state.resourceParent);
      fd.append('__csrf', C.csrf);
      var u = new URL(C.apiUrl, location.origin);
      u.searchParams.set('module', 'upload');
      u.searchParams.set('action', 'upload');
      fetch(u, { method: 'POST', headers: { 'X-CSRF-Token': C.csrf }, body: fd }).then(function (r) {
        return r.json();
      }).then(function (x) {
        if (x.code !== 0) throw new Error(x.msg);
        toast('上传成功');
        loadResources();
      }).catch(function (e) { toast(e.message, false); });
    };
    input.click();
  }

  function openRemote() {
    var url = prompt('请输入 HTTPS 资源地址');
    if (url) post('upload', 'remote_upload', { url: url, parent_id: state.resourceParent }).then(function () {
      toast('远程上传成功');
      loadResources();
    }).catch(function (e) { toast(e.message, false); });
  }

  function exitToFinance() {
    var fallback = C.adminUrl || '';
    if (!fallback) {
      var path = window.location.pathname || '';
      var match = path.match(/^(\/[^\/]+)\/addons/);
      fallback = match && match[1] ? (match[1] + '/') : '/admin/';
    }
    if (window.opener && !window.opener.closed) {
      try {
        window.opener.focus();
        window.close();
        return;
      } catch (e) {}
    }
    var targetWindow = window.top || window;
    targetWindow.location.href = fallback;
  }

  function updateThemeUI(isLight) {
    var btn = document.getElementById('themeToggleBtn');
    if (btn) {
      btn.setAttribute('title', isLight ? '切换为黑色页面' : '切换为白色页面');
      var sun = btn.querySelector('.theme-icon-sun');
      var moon = btn.querySelector('.theme-icon-moon');
      if (sun) sun.style.display = isLight ? 'none' : 'inline-flex';
      if (moon) moon.style.display = isLight ? 'inline-flex' : 'none';
    }
    var sideText = document.getElementById('sidebarThemeText');
    if (sideText) sideText.textContent = isLight ? '切换黑色页面' : '切换白色页面';
    var sideIcon = document.getElementById('sidebarThemeIcon');
    if (sideIcon) {
      sideIcon.innerHTML = isLight
        ? '<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>'
        : '<circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>';
    }
  }

  function toggleTheme() {
    var isLight = !document.documentElement.classList.contains('theme-light');
    document.documentElement.classList.toggle('theme-light', isLight);
    if (document.body) document.body.classList.toggle('theme-light', isLight);
    try {
      localStorage.setItem('abcloud_theme_mode', isLight ? 'light' : 'dark');
    } catch (e) {}
    updateThemeUI(isLight);
    toast(isLight ? '已切换为白色页面' : '已切换为黑色页面');
  }

  function initTheme() {
    var saved = null;
    try { saved = localStorage.getItem('abcloud_theme_mode'); } catch (e) {}
    var isLight = saved === 'light';
    document.documentElement.classList.toggle('theme-light', isLight);
    if (document.body) document.body.classList.toggle('theme-light', isLight);
    updateThemeUI(isLight);
  }

  window.PluginAdmin = {
    renderItems: renderItems,
    renderLogs: renderLogs,
    configForm: configForm,
    openEditor: openEditor,
    submitModal: submitModal,
    closeModal: closeModal,
    remove: remove,
    saveConfig: saveConfig,
    renderResources: renderResources,
    createDir: createDir,
    removeResource: removeResource,
    openUpload: openUpload,
    openRemote: openRemote,
    openPicker: openPicker,
    pick: pick,
    moveItem: moveItem,
    applyNewOrder: applyNewOrder,
    exitToFinance: exitToFinance,
    toggleTheme: toggleTheme,
    initTheme: initTheme
  };

  document.addEventListener('click', function (event) {
    var picker = event.target.closest('[data-picker-field]');
    if (picker) {
      openPicker(picker.dataset.pickerField);
      return;
    }
    var button = event.target.closest('[data-resource-action]');
    if (!button) return;
    var action = button.dataset.resourceAction, id = Number(button.dataset.id || 0);
    if (action === 'up') {
      var current = state.resources.find(function (x) { return Number(x.id) === state.resourceParent; });
      state.resourceParent = current ? Number(current.parent_id) : 0;
      renderResources();
    } else if (action === 'open') {
      state.resourceParent = id;
      renderResources();
    } else if (action === 'pick') {
      var file = state.resources.find(function (x) { return Number(x.id) === id; });
      if (file) pick(file.path);
    } else if (action === 'rename') renameResource(id);
    else if (action === 'remove') removeResource(id);
  });

  document.addEventListener('DOMContentLoaded', function () {
    var toggle = document.getElementById('pluginMenuToggle'), backdrop = document.getElementById('pluginMenuBackdrop');
    function closeMenu() {
      document.body.classList.remove('plugin-menu-open');
      if (toggle) toggle.setAttribute('aria-expanded', 'false');
    }
    if (toggle) toggle.addEventListener('click', function () {
      var open = document.body.classList.toggle('plugin-menu-open');
      toggle.setAttribute('aria-expanded', String(open));
    });
    if (backdrop) backdrop.addEventListener('click', closeMenu);
    initTheme();
    if (C.page === 'resources' || C.picker) loadResources();
    if (C.page === 'operation_log') renderLogs();
    if (C.page === 'config' || C.page === 'carousel_global') configForm();
    if (['carousel', 'feature', 'topnav', 'footernav', 'web_module', 'popup'].indexOf(C.page) > -1) renderItems();
  });

  if (document.readyState === 'interactive' || document.readyState === 'complete') {
    initTheme();
    if (C.page === 'resources' || C.picker) loadResources();
    if (C.page === 'operation_log') renderLogs();
    if (C.page === 'config' || C.page === 'carousel_global') configForm();
    if (['carousel', 'feature', 'topnav', 'footernav', 'web_module', 'popup'].indexOf(C.page) > -1) renderItems();
  }
})();
