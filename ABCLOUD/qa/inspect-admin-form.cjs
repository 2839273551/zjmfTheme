const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
  await page.goto('https://66.yunxnet.cn/X6A3wQo9/#/login', { waitUntil: 'networkidle' });

  const formItems = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('.el-form-item')).map(item => {
      const label = item.querySelector('label') ? item.querySelector('label').textContent : '';
      const input = item.querySelector('input') ? {
        type: item.querySelector('input').type,
        placeholder: item.querySelector('input').placeholder,
        class: item.querySelector('input').className
      } : null;
      const text = item.textContent.trim();
      return { label, input, text };
    });
  });
  console.log('Admin Form Items:', JSON.stringify(formItems, null, 2));
  await browser.close();
})();
