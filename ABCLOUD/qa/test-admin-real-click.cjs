const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });

  page.on('console', msg => console.log('BROWSER LOG:', msg.type(), msg.text()));
  page.on('pageerror', err => console.log('PAGE ERROR:', err.message));
  page.on('request', req => {
    if (!req.url().endsWith('.js') && !req.url().endsWith('.css') && !req.url().endsWith('.png')) {
      console.log('REQ:', req.method(), req.url());
      if (req.postData()) console.log('POST DATA:', req.postData());
    }
  });
  page.on('response', async resp => {
    if (!resp.url().endsWith('.js') && !resp.url().endsWith('.css') && !resp.url().endsWith('.png')) {
      console.log('RESP:', resp.status(), resp.url());
      try {
        const text = await resp.text();
        console.log('RESP TEXT:', text.slice(0, 200));
      } catch (e) {}
    }
  });

  await page.goto('https://66.yunxnet.cn/X6A3wQo9/#/login', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1000);

  // Vue element-ui inputs need real typing
  const usernameInput = await page.$('input[placeholder="账号"]');
  const passwordInput = await page.$('input[placeholder="密码"]');

  await usernameInput.click();
  await usernameInput.fill('2839273551@qq.com');

  await passwordInput.click();
  await passwordInput.fill('20040221c');

  console.log('Filled inputs, now clicking login...');
  const loginBtn = await page.$('button.el-button--primary');
  await loginBtn.click();

  await page.waitForTimeout(4000);

  console.log('Final page URL:', page.url());
  await page.screenshot({ path: path.join(__dirname, 'results', 'admin-after-real-click.png') });

  await browser.close();
})();
