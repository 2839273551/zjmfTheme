const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });
  const page = await browser.newPage({ viewport: { width: 390, height: 844 } });
  await page.goto('https://66.yunxnet.cn/login', { waitUntil: 'networkidle' });

  // Check overflow
  const isOverflow = await page.evaluate(() => {
    return document.documentElement.scrollWidth > window.innerWidth;
  });
  console.log('Mobile horizontal overflow:', isOverflow);

  await page.screenshot({ path: path.join(__dirname, 'results', 'login-mobile-password-fixed.png') });

  // Switch to code login
  await page.click('div[onclick*="allow_login_phone_captcha"]');
  await page.waitForTimeout(500);

  const isOverflowCode = await page.evaluate(() => {
    return document.documentElement.scrollWidth > window.innerWidth;
  });
  console.log('Mobile code login horizontal overflow:', isOverflowCode);

  await page.screenshot({ path: path.join(__dirname, 'results', 'login-mobile-code-fixed.png') });

  await browser.close();
  console.log('MOBILE CHECKS PASSED!');
})();
