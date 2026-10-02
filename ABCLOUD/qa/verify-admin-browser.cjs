const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });

  console.log('Loading admin login...');
  await page.goto('https://66.yunxnet.cn/X6A3wQo9/#/login', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1000);

  // Fill credentials
  await page.fill('input[type="text"]', '2839273551@qq.com');
  await page.fill('input[type="password"]', '20040221c');

  // Click login
  console.log('Clicking login...');
  await page.click('button');
  await page.waitForTimeout(3000);

  console.log('Current URL after login:', page.url());

  await page.screenshot({ path: path.join(__dirname, 'results', 'admin-logged-in.png') });
  await browser.close();
})();
