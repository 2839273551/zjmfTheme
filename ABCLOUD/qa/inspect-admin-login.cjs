const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });

  page.on('console', msg => console.log('ADMIN CONSOLE:', msg.type(), msg.text()));
  page.on('pageerror', err => console.log('ADMIN PAGE ERROR:', err.message));

  page.on('request', req => {
    if (req.url().includes('login') || req.url().includes('api') || req.url().includes('admin')) {
      console.log('REQ:', req.method(), req.url());
      const postData = req.postData();
      if (postData) console.log('POST DATA:', postData);
    }
  });

  page.on('response', async resp => {
    if (resp.url().includes('login') || resp.url().includes('api') || resp.url().includes('admin')) {
      console.log('RESP:', resp.status(), resp.url());
      try {
        const text = await resp.text();
        console.log('RESP BODY:', text.slice(0, 300));
      } catch (e) {}
    }
  });

  console.log('Loading admin login...');
  await page.goto('https://66.yunxnet.cn/X6A3wQo9/#/login', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1000);

  await page.screenshot({ path: path.join(__dirname, 'results', 'admin-login-init.png') });

  // Find username and password fields
  const inputs = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('input')).map(i => ({
      name: i.name,
      type: i.type,
      placeholder: i.placeholder,
      id: i.id
    }));
  });
  console.log('Admin inputs:', inputs);

  // Fill credentials
  await page.fill('input[type="text"]', '2839273551@qq.com');
  await page.fill('input[type="password"]', '20040221c');

  // Check if there is a captcha input or image in admin
  const captchaInfo = await page.evaluate(() => {
    const imgs = Array.from(document.querySelectorAll('img')).map(img => img.src);
    return { imgs };
  });
  console.log('Captcha info:', captchaInfo);

  // Click login button
  console.log('Clicking login button...');
  const btn = await page.$('button');
  if (btn) await btn.click();
  await page.waitForTimeout(3000);

  // Check UI messages or toasts
  const messages = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('.el-message, .el-notification, .el-alert, .toast-message, [role="alert"]')).map(el => el.textContent);
  });
  console.log('Admin messages on screen:', messages);

  await page.screenshot({ path: path.join(__dirname, 'results', 'admin-login-after.png') });
  await browser.close();
})();
