const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });

  // 1. Verify Admin Login
  console.log('--- TEST 1: Admin Login ---');
  const adminPage = await browser.newPage({ viewport: { width: 1440, height: 900 } });
  await adminPage.goto('https://66.yunxnet.cn/X6A3wQo9/#/login', { waitUntil: 'networkidle' });
  await adminPage.waitForTimeout(500);

  const uInp = await adminPage.$('input[placeholder="账号"]');
  const pInp = await adminPage.$('input[placeholder="密码"]');
  await uInp.click();
  await uInp.fill('2839273551@qq.com');
  await pInp.click();
  await pInp.fill('20040221c');

  const btn = await adminPage.$('button.el-button--primary');
  await btn.click();
  await adminPage.waitForTimeout(4000);

  const adminUrl = adminPage.url();
  console.log('Admin URL after login:', adminUrl);
  if (!adminUrl.includes('/home-page')) {
    throw new Error('Admin login failed to navigate to /home-page');
  }
  console.log('Admin Login Test: PASSED!');
  await adminPage.close();

  // 2. Verify Client Area Login Page
  console.log('--- TEST 2: Client Area Login Page ---');
  const clientPage = await browser.newPage({ viewport: { width: 1440, height: 900 } });
  await clientPage.goto('https://66.yunxnet.cn/login', { waitUntil: 'networkidle' });

  const phoneSlots = await clientPage.evaluate(() => document.querySelectorAll('#phone .geetest-captcha-slot').length);
  const emailSlots = await clientPage.evaluate(() => document.querySelectorAll('#email .geetest-captcha-slot').length);
  console.log('Phone Geetest slots:', phoneSlots);
  console.log('Email Geetest slots:', emailSlots);

  if (phoneSlots !== 1 || emailSlots !== 1) {
    throw new Error('Geetest slots count incorrect');
  }
  console.log('Client Area Login Slots Test: PASSED!');
  await clientPage.close();

  console.log('ALL TESTS 100% PASSED!');
  await browser.close();
})();
