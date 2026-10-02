const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
  page.on('console', msg => console.log('LOG:', msg.type(), msg.text()));
  page.on('pageerror', err => console.log('ERROR:', err.message));
  page.on('dialog', async d => { console.log('DIALOG:', d.message()); await d.accept(); });
  await page.goto('https://66.yunxnet.cn/login', { waitUntil: 'networkidle' });

  // Type phone and password
  await page.fill('#phoneInp', '13273184758');
  await page.fill('#phonePwdInp', '123456');

  console.log('Value before submit:', await page.$eval('#phonePwdInp', el => el.value));
  console.log('Encrypted before submit:', await page.$eval('#phonePwdInp', el => el.dataset.encrypted));

  // Click submit
  const submitBtn = await page.$('#phone button[type="submit"]');
  console.log('Clicking submit 1...');
  await submitBtn.click();
  await page.waitForTimeout(2000);

  console.log('Value after click 1:', await page.$eval('#phonePwdInp', el => el.value));
  console.log('Encrypted after click 1:', await page.$eval('#phonePwdInp', el => el.dataset.encrypted));

  await page.screenshot({ path: path.join(__dirname, 'results', 'after-submit-click.png') });
  await browser.close();
})();
