const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
  await page.goto('https://66.yunxnet.cn/login', { waitUntil: 'networkidle' });
  const phoneFormHtml = await page.evaluate(() => document.querySelector('#phone form').outerHTML);
  console.log('PHONE FORM HTML:\n', phoneFormHtml);
  await browser.close();
})();
