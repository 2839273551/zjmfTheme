const path = require('path');
const fs = require('fs');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ channel: 'msedge', headless: true });
  const page = await browser.newPage();
  const errors = [];
  page.on('pageerror', err => errors.push(err.message));
  page.on('console', msg => { if (msg.type() === 'error') errors.push(msg.text()); });

  const jsPath = path.resolve(__dirname, '../public/plugins/addons/abcloud_theme/assets/js/plugin-admin.js').replace(/\\/g, '/');
  const adminCss = fs.readFileSync(path.resolve(__dirname, '../public/plugins/addons/abcloud_theme/assets/css/admin.css'), 'utf8');

  await page.setContent(`
    <!doctype html>
    <html>
    <head>
      <meta charset="utf-8">
      <style>${adminCss}</style>
      <style>
        .top-header-right{display:flex;align-items:center;gap:12px}
        .header-tools{display:flex;align-items:center;gap:6px}
        .tool-btn{background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.16);color:rgba(255,255,255,.9);cursor:pointer;width:32px;height:32px;padding:0;display:inline-flex;align-items:center;justify-content:center;border-radius:4px;transition:all .2s ease}
        .tool-btn svg{width:16px;height:16px;color:rgba(255,255,255,.9);stroke:rgba(255,255,255,.9)}
        .tool-btn:hover{background:rgba(255,255,255,.22);border-color:rgba(255,255,255,.35);color:#fff}
        .tool-btn:hover svg{color:#fff;stroke:#fff}
        .user-dropdown{display:flex;align-items:center;gap:8px;padding:4px 10px;border-radius:16px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.14)}
        .user-avatar{width:24px;height:24px;border-radius:50%;background:#409eff;color:#fff;display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0}
        .user-avatar svg{width:14px;height:14px;fill:#ffffff}
        .user-name{color:#ffffff;font-size:13px;font-weight:500}
        .header-version{color:rgba(255,255,255,.7);font-size:12px}
        .sidebar{width:200px;background:#001529;position:fixed;top:48px;bottom:0;left:0;overflow-y:auto;z-index:100;box-shadow:2px 0 8px rgba(0,0,0,.12)}
        .sidebar-menu{list-style:none;padding:8px 0;margin:0}
        .sidebar-menu li{margin:3px 8px}
        .sidebar-menu a{display:flex;align-items:center;gap:10px;padding:10px 12px;color:rgba(255,255,255,.7);text-decoration:none;font-size:14px;border-radius:6px;white-space:nowrap;transition:all .2s ease}
        .sidebar-menu a .menu-icon{width:18px;height:18px;display:inline-flex;align-items:center;justify-content:center;flex-shrink:0}
        .sidebar-menu a .menu-icon svg{width:16px;height:16px;color:rgba(255,255,255,.7);stroke:currentColor;fill:none;transition:color .2s}
        .sidebar-menu a:hover{color:#fff;background:rgba(255,255,255,.08)}
        .sidebar-menu a:hover .menu-icon svg{color:#fff}
        .sidebar-menu a.submenu-toggle.has-active-child{color:#fff;background:rgba(255,255,255,.06);font-weight:500}
        .sidebar-menu a.submenu-toggle.has-active-child .menu-icon svg{color:#409eff}
        .sidebar-menu a.active:not(.submenu-toggle){color:#fff!important;background:#1890ff!important;font-weight:500;box-shadow:0 2px 8px rgba(24,144,255,.4)}
        .sidebar-menu a.active:not(.submenu-toggle) .menu-icon svg{color:#fff!important}
        .sidebar-menu .submenu{list-style:none;padding:4px 0 4px 6px;margin:2px 0;background:rgba(0,0,0,.18);border-radius:6px;display:none}
        .sidebar-menu .submenu.show{display:block}
        .sidebar-menu .submenu li{margin:2px 0}
        .sidebar-menu .submenu a{padding:8px 12px 8px 30px;font-size:13px;color:rgba(255,255,255,.65);border-radius:4px}
        .sidebar-menu .submenu a:hover{color:#fff;background:rgba(255,255,255,.08)}
        .sidebar-menu .submenu a.active{color:#fff!important;background:#1890ff!important;box-shadow:0 2px 6px rgba(24,144,255,.35)}
        .sidebar-menu .submenu-arrow{margin-left:auto;display:inline-flex;align-items:center;transition:transform .25s ease;color:rgba(255,255,255,.5)}
        .sidebar-menu .has-submenu.open .submenu-arrow{transform:rotate(180deg)}
        .layout{display:flex;min-height:calc(100vh - 48px);margin-top:48px}
        .main{flex:1;margin-left:200px;padding:20px;background:#f0f2f5}
        .tab-bar{background:#fff;padding:14px 20px;border-bottom:1px solid #ebeef5;margin-bottom:20px;border-radius:6px;box-shadow:0 1px 3px rgba(0,0,0,.02)}
        .page-title{font-size:16px;font-weight:600;color:#1f2d3d;display:flex;align-items:center;gap:8px}
        .page-title::before{content:'';display:inline-block;width:4px;height:16px;background:#409eff;border-radius:2px}
        .plugin-card{background:#fff;border:1px solid #e4e7ed;border-radius:8px;padding:24px 28px;box-shadow:0 2px 12px 0 rgba(0,0,0,.04)}
        .plugin-field{display:grid;grid-template-columns:140px minmax(0,1fr);gap:16px;align-items:start;margin-bottom:18px;padding-bottom:16px;border-bottom:1px solid #f2f3f5}
        .plugin-field:last-child{border-bottom:none;padding-bottom:0}
        .plugin-field>label{color:#4e5969;font-size:14px;font-weight:500;text-align:right;padding-top:8px;white-space:nowrap}
        .plugin-field-hint{color:#909399;font-size:12px;margin-top:6px;line-height:1.5}
        .plugin-actions{display:flex;gap:12px;align-items:center;margin-top:24px;padding-top:20px;border-top:1px solid #f0f2f5;padding-left:156px}
        .plugin-actions button{height:38px;padding:0 24px;font-size:14px;font-weight:500;border-radius:4px;border:none;cursor:pointer;background:#409eff;color:#fff;box-shadow:0 2px 6px rgba(64,158,255,.25);transition:all .2s ease}
        .plugin-actions button:hover{background:#66b1ff;box-shadow:0 4px 12px rgba(64,158,255,.35)}
        .plugin-actions button.muted{background:#f4f4f5;color:#909399;border:1px solid #dcdfe6;box-shadow:none}
      </style>
    </head>
    <body>
      <div class="top-header">
        <div class="top-header-left">
          <div class="header-logo"><span class="logo-text">ABCLOUD 主题管理</span></div>
          <div class="header-version">2026年9月26日</div>
        </div>
        <div class="top-header-right">
          <div class="header-tools">
            <button class="tool-btn" type="button" title="刷新页面"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M23 4v6h-6"></path><path d="M1 20v-6h6"></path><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg></button>
            <button class="tool-btn" type="button" title="切换全屏"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"></path></svg></button>
          </div>
          <div class="user-dropdown">
            <div class="user-avatar" title="当前登录管理员"><svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg></div>
            <span class="user-name">2839273551</span>
          </div>
        </div>
      </div>
      <div class="layout">
        <div class="sidebar"><ul class="sidebar-menu">
          <li><a href="#"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><rect x="3" y="3" width="7" height="7" rx="1"></rect><rect x="14" y="3" width="7" height="7" rx="1"></rect><rect x="14" y="14" width="7" height="7" rx="1"></rect><rect x="3" y="14" width="7" height="7" rx="1"></rect></svg></span><span class="menu-title">控制台</span></a></li>
          <li class="has-submenu open"><a href="#" class="submenu-toggle has-active-child"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><rect x="2" y="3" width="20" height="14" rx="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg></span><span class="menu-title">轮播图管理</span><span class="submenu-arrow"><svg viewBox="0 0 24 24" width="12" height="12" stroke="currentColor" stroke-width="2.5" fill="none"><polyline points="6 9 12 15 18 9"></polyline></svg></span></a><ul class="submenu show"><li><a href="#">轮播图列表</a></li><li><a class="active" href="#">全局设置</a></li></ul></li>
          <li><a href="#"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg></span><span class="menu-title">快捷入口管理</span></a></li>
          <li><a href="#"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg></span><span class="menu-title">顶部导航管理</span></a></li>
          <li><a href="#"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><rect x="3" y="3" width="18" height="18" rx="2"></rect><line x1="3" y1="15" x2="21" y2="15"></line></svg></span><span class="menu-title">底部导航管理</span></a></li>
          <li><a href="#"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg></span><span class="menu-title">通用模块</span></a></li>
          <li><a href="#"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg></span><span class="menu-title">弹窗通知管理</span></a></li>
          <li><a href="#"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg></span><span class="menu-title">资源库管理</span></a></li>
          <li><a href="#"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg></span><span class="menu-title">网站配置</span></a></li>
          <li><a href="#"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg></span><span class="menu-title">操作日志</span></a></li>
        </ul></div>
        <div class="main">
          <div class="tab-bar"><span class="page-title">轮播图全局设置</span></div>
          <div class="plugin-card">
            <div id="configForm"></div>
            <div class="plugin-actions"><button type="button">保存修改</button><button type="button" class="muted">重置</button></div>
          </div>
          <div style="height:30px"></div>
          <div id="logRoot"></div>
          <div id="itemsRoot"></div>
        </div>
      </div>
      <script>
        window.PLUGIN_CONTEXT = {
          page: 'carousel_global',
          configs: {
            switch_effect: 'default',
            carousel_speed: '5000',
            carousel_height: '600px',
            progress_height: '42px',
            progress_bar: '4px',
            video_zoom: '35px',
            error_image: '/assets/img/404.png'
          },
          logs: [
            { id: 1, created_at: '2026-09-26 18:00:00', admin_name: 'admin', action: 'update', module: 'config', detail: '{"keys":["switch_effect","carousel_speed"]}', ip: '127.0.0.1' },
            { id: 2, created_at: '2026-09-26 18:01:00', admin_name: 'admin', action: 'add', module: 'carousel', detail: '{"id":1,"title":"测试轮播"}', ip: '127.0.0.1' },
            { id: 3, created_at: '2026-09-26 18:02:00', admin_name: 'admin', action: 'add', module: 'upload', detail: '{"id":2,"name":"pic.png"}', ip: '127.0.0.1' }
          ],
          items: [
            { id: 1, title: '云服务器', media_url: '/bg.png', media_type: 'image', sort_order: 1, status: 1 }
          ],
          apiUrl: 'https://66.yunxnet.cn/api',
          csrf: 'test'
        };
      </script>
    </body></html>
  `);

  await page.addScriptTag({ path: path.resolve(__dirname, '../public/plugins/addons/abcloud_theme/assets/js/plugin-admin.js') });

  await page.waitForTimeout(600);

  const labels = await page.$$eval('#configForm .plugin-field > label', els => els.map(e => e.textContent.trim()));
  console.log('carousel_global labels:', JSON.stringify(labels));

  const switchEffectControl = await page.$eval('#configForm [name="switch_effect"]', el => ({
    tagName: el.tagName,
    options: Array.from(el.options || []).map(o => ({ value: o.value, text: o.text, selected: o.selected }))
  }));
  console.log('switch_effect control:', JSON.stringify(switchEffectControl));

  // Test config page
  // Keep carousel_global as the rendered view for screenshot

  // Test operation logs
  await page.evaluate(() => {
    window.PLUGIN_CONTEXT.page = 'operation_log';
    PluginAdmin.renderLogs();
  });
  const logHeaders = await page.$$eval('#logRoot th', els => els.map(e => e.textContent.trim()));
  const logFirstRow = await page.$$eval('#logRoot tbody tr:first-child td', els => els.map(e => e.textContent.trim()));
  const allLogDetails = await page.$$eval('#logRoot tbody tr td:nth-child(6)', els => els.map(e => e.textContent.trim()));
  console.log('logHeaders:', JSON.stringify(logHeaders));
  console.log('logFirstRow:', JSON.stringify(logFirstRow));
  console.log('allLogDetails:', JSON.stringify(allLogDetails));

  // Test items
  await page.evaluate(() => {
    window.PLUGIN_CONTEXT.page = 'carousel';
    PluginAdmin.renderItems();
  });
  const itemHeaders = await page.$$eval('#itemsRoot th', els => els.map(e => e.textContent.trim()));
  console.log('itemHeaders:', JSON.stringify(itemHeaders));

  const topHeaderEl = await page.$('.top-header');
  if (topHeaderEl) {
    const outPath = path.resolve(__dirname, 'results/top-header-preview.png');
    await topHeaderEl.screenshot({ path: outPath });
    console.log('Captured top header preview to:', outPath);
  }

  const layoutPath = path.resolve(__dirname, 'results/admin-beautified-preview.png');
  await page.screenshot({ path: layoutPath, fullPage: false, clip: { x: 0, y: 0, width: 1000, height: 780 } });
  console.log('Captured full layout preview to:', layoutPath);

  console.log('Errors:', errors);
  await browser.close();
})();
