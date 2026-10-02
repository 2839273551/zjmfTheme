const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright');

(async () => {
  const project = path.resolve(__dirname, '../..');
  const original = path.join(project, 'APE云模板系统-整合包/ape');
  const theme = path.join(project, 'ABCLOUD/public/themes/web/ABCLOUD');
  const html = fs.readFileSync(path.join(theme, 'index.html'), 'utf8');
  const browser = await chromium.launch({ channel: 'msedge', headless: true });
  const context = await browser.newContext({ javaScriptEnabled: false });
  const page = await context.newPage();
  await page.route('**/*', route => route.abort());
  await page.setContent(html);
  const urls = await page.locator('[src],[href]').evaluateAll(nodes => nodes.flatMap(n => ['src','href'].map(a => n.getAttribute(a)).filter(Boolean)));
  const missing = [];
  for (const url of urls) {
    const prefix = '/themes/web/ABCLOUD/';
    if (url.startsWith(prefix)) {
      const relative = url.slice(prefix.length).split(/[?#]/)[0];
      if (!fs.existsSync(path.join(theme, relative))) missing.push(relative);
    }
  }
  const duplicateIds = await page.evaluate(() => {
    const ids = [...document.querySelectorAll('[id]')].map(n => n.id);
    return [...new Set(ids.filter((id,i) => ids.indexOf(id) !== i))];
  });
  const modules = {
    'cloud-market': '.cloud-market-section',
    'industry-solutions': '.industry-solutions-section',
    'global-infrastructure': '.global-infra-section',
    'why-choose-us': '.container_bg1',
    partners: '.partner-section',
    'join-banner': '.join-banner',
    'product-service': '.product-service-section',
    news: '.news-section'
  };
  const signatures = {};
  const signature = element => {
    const normalize = s => (s || '').replace(/\s+/g, ' ').trim();
    return [...element.querySelectorAll('*')].map(n => ({
      tag: n.tagName, class: n.className.baseVal === undefined ? n.className : n.className.baseVal,
      text: n.children.length ? '' : normalize(n.textContent),
      image: (n.getAttribute('src') || '').replace('/themes/web/ABCLOUD/static/ape/', '/web/ape/')
    }));
  };
  for (const [name, selector] of Object.entries(modules)) {
    const target = await page.locator(selector).evaluate(signature);
    const reference = await context.newPage();
    await reference.route('**/*', route => route.abort());
    await reference.setContent(fs.readFileSync(path.join(original, 'include', name + '.html'), 'utf8'));
    const source = await reference.locator(selector).evaluate(signature);
    signatures[name] = { elements: source.length, targetElements: target.length, equal: JSON.stringify(source) === JSON.stringify(target) };
    await reference.close();
  }
  const report = { missingAssets: [...new Set(missing)], duplicateIds, modules: signatures };
  fs.writeFileSync(path.join(__dirname, 'source-audit.json'), JSON.stringify(report, null, 2));
  console.log(JSON.stringify(report, null, 2));
  await browser.close();
})().catch(error => { console.error(error); process.exitCode = 1; });
