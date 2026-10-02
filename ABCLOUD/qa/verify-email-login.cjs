const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });
  const context = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await context.newPage();

  console.log('Navigating to https://66.yunxnet.cn/login...');
  await page.goto('https://66.yunxnet.cn/login', { waitUntil: 'networkidle' });

  // Switch to Email tab
  console.log('Switching to email tab...');
  await page.click('#tab-email');
  await page.waitForTimeout(300);

  // Check form inputs
  const emailInp = await page.$('#emailInp');
  const emailPwdInp = await page.$('#emailPwdInp');
  console.log('Email input exists:', !!emailInp);
  console.log('Email pwd input exists:', !!emailPwdInp);

  await emailInp.fill('2839273551@qq.com');
  await emailPwdInp.fill('20040221c');

  // Verify visible password is NOT corrupted
  console.log('Visible password:', await emailPwdInp.inputValue());

  // Check geetest slot in email form
  const emailGateSlot = await page.$('#email .geetest-captcha-slot');
  console.log('Email form Geetest slot exists:', !!emailGateSlot);

  // Take screenshot of clean email login form
  await page.screenshot({ path: path.join(__dirname, 'results', 'email-login-clean.png') });

  console.log('Email login form verified cleanly!');
  await browser.close();
})();
