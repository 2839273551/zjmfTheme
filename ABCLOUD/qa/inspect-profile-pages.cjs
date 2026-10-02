const path = require('path');
const fs = require('fs');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });
  const context = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await context.newPage();

  console.log('1. Navigating to login...');
  await page.goto('https://66.yunxnet.cn/login', { waitUntil: 'networkidle' });

  // 手机登录
  await page.fill('#phoneInp', '13273184758');
  await page.fill('#phonePwdInp', '20040221c');
  
  // 提交登录
  console.log('2. Submitting login form...');
  const [response] = await Promise.all([
    page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(e => null),
    page.click('#phone button[type="submit"]')
  ]);

  console.log('Current URL after login attempt:', page.url());

  // 如果成功进入 clientarea，我们访问 /details
  console.log('3. Visiting /details...');
  const respDetails = await page.goto('https://66.yunxnet.cn/details', { waitUntil: 'networkidle' });
  console.log('/details status:', respDetails.status(), 'final URL:', page.url());
  const detailsHtml = await page.content();
  fs.writeFileSync(path.join(__dirname, 'results', 'details-source.html'), detailsHtml, 'utf8');
  await page.screenshot({ path: path.join(__dirname, 'results', 'details-native-1440.png') });

  // 访问 /security
  console.log('4. Visiting /security...');
  const respSecurity = await page.goto('https://66.yunxnet.cn/security', { waitUntil: 'networkidle' });
  console.log('/security status:', respSecurity.status(), 'final URL:', page.url());
  const securityHtml = await page.content();
  fs.writeFileSync(path.join(__dirname, 'results', 'security-source.html'), securityHtml, 'utf8');
  await page.screenshot({ path: path.join(__dirname, 'results', 'security-native-1440.png') });

  console.log('Inspection complete!');
  await browser.close();
})();
