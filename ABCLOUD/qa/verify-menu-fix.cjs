const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120']
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
  const errors = [];
  page.on('pageerror', err => errors.push(err.message));
  const resp = await page.goto('https://66.yunxnet.cn/', { waitUntil: 'domcontentloaded', timeout: 20000 });
  await page.waitForFunction(() => document.querySelectorAll('.mega-product-card').length > 0, { timeout: 15000 });
  await page.waitForTimeout(500);

  // Check top navigation texts
  const navTexts = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('#publicNav > li')).map(el => {
      const a = el.querySelector('.nav-parent');
      return a ? a.textContent.trim().replace(/\s+/g, ' ') : '';
    });
  });
  console.log('Top navigation items:', JSON.stringify(navTexts));

  // Open '产品与服务'
  await page.evaluate(() => {
    const li = document.querySelector('li[data-product-menu="1"]');
    if (li) {
      li.classList.add('active');
      li.setAttribute('data-click-lock', '1');
    }
  });
  await page.waitForTimeout(500);

  // Check mega menu visibility & cards
  const megaStats = await page.evaluate(() => {
    const menu = document.querySelector('li[data-product-menu="1"] .mega-menu');
    const cards = Array.from(document.querySelectorAll('.mega-product-card')).map(card => {
      const rect = card.getBoundingClientRect();
      const name = (card.querySelector('.mega-product-name') || {}).textContent || '';
      return { name: name.trim(), x: Math.round(rect.x), y: Math.round(rect.y), width: Math.round(rect.width), height: Math.round(rect.height) };
    });
    return {
      menuVisible: menu ? window.getComputedStyle(menu).display !== 'none' : false,
      cardCount: cards.length,
      sampleCards: cards.slice(0, 4)
    };
  });
  console.log('Mega menu stats:', JSON.stringify(megaStats, null, 2));

  // Take screenshot
  const shotPath = path.resolve(__dirname, 'results/product-mega-menu-fixed.png');
  await page.screenshot({ path: shotPath, clip: { x: 0, y: 0, width: 1440, height: 600 } });
  console.log('Saved screenshot to:', shotPath);

  console.log('Errors:', errors);
  await browser.close();
})();
