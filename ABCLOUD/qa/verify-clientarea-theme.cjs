const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });

  const results = {};

  // 1. Desktop Login (1440x900)
  {
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
    const errors = [];
    const missing = [];
    page.on('pageerror', err => errors.push(err.message));
    page.on('response', resp => {
      if (resp.status() >= 400) {
        missing.push({ url: resp.url(), status: resp.status() });
      }
    });

    const resp = await page.goto('https://66.yunxnet.cn/login', { waitUntil: 'domcontentloaded', timeout: 20000 });
    await page.waitForTimeout(1000);

    const title = await page.title();
    const hasBackWelcome = await page.evaluate(() => {
      const el = document.querySelector('.abcloud-text-welcome');
      return el && el.textContent.includes('WELCOME');
    });
    const hasForm = await page.evaluate(() => {
      return !!document.querySelector('#phone form') || !!document.querySelector('#email form');
    });
    const logoSrc = await page.evaluate(() => {
      const img = document.querySelector('.abcloud-auth-logo');
      return img ? img.getAttribute('src') : null;
    });

    await page.screenshot({ path: path.join(__dirname, 'results', 'login-desktop-1440.png'), fullPage: false });

    // Switch to Email tab
    await page.evaluate(() => {
      const btn = document.querySelector('#tab-email');
      if (btn) btn.click();
    });
    await page.waitForTimeout(500);
    await page.screenshot({ path: path.join(__dirname, 'results', 'login-desktop-email-1440.png'), fullPage: false });

    results.loginDesktop = {
      status: resp.status(),
      title,
      hasBackWelcome,
      hasForm,
      logoSrc,
      errors,
      missing
    };
    await page.close();
  }

  // 2. Mobile Login (390x844)
  {
    const page = await browser.newPage({ viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true });
    const errors = [];
    page.on('pageerror', err => errors.push(err.message));

    const resp = await page.goto('https://66.yunxnet.cn/login', { waitUntil: 'domcontentloaded', timeout: 20000 });
    await page.waitForTimeout(1000);

    const overflow = await page.evaluate(() => document.documentElement.scrollWidth > window.innerWidth);
    await page.screenshot({ path: path.join(__dirname, 'results', 'login-mobile-390.png'), fullPage: true });

    results.loginMobile = {
      status: resp.status(),
      overflow,
      errors
    };
    await page.close();
  }

  // 3. Desktop Register (1440x900)
  {
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
    const errors = [];
    page.on('pageerror', err => errors.push(err.message));
    const resp = await page.goto('https://66.yunxnet.cn/register', { waitUntil: 'domcontentloaded', timeout: 20000 });
    await page.waitForTimeout(1000);
    await page.screenshot({ path: path.join(__dirname, 'results', 'register-desktop-1440.png'), fullPage: false });
    results.registerDesktop = { status: resp.status(), errors };
    await page.close();
  }

  // 4. Mobile Register (390x844)
  {
    const page = await browser.newPage({ viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true });
    const errors = [];
    page.on('pageerror', err => errors.push(err.message));
    const resp = await page.goto('https://66.yunxnet.cn/register', { waitUntil: 'domcontentloaded', timeout: 20000 });
    await page.waitForTimeout(1000);
    const overflow = await page.evaluate(() => document.documentElement.scrollWidth > window.innerWidth);
    await page.screenshot({ path: path.join(__dirname, 'results', 'register-mobile-390.png'), fullPage: true });
    results.registerMobile = { status: resp.status(), overflow, errors };
    await page.close();
  }

  // 5. Desktop Password Reset (1440x900)
  {
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
    const errors = [];
    page.on('pageerror', err => errors.push(err.message));
    const resp = await page.goto('https://66.yunxnet.cn/pwreset', { waitUntil: 'domcontentloaded', timeout: 20000 });
    await page.waitForTimeout(1000);
    await page.screenshot({ path: path.join(__dirname, 'results', 'pwreset-desktop-1440.png'), fullPage: false });
    results.pwresetDesktop = { status: resp.status(), errors };
    await page.close();
  }

  // 6. Mobile Password Reset (390x844)
  {
    const page = await browser.newPage({ viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true });
    const errors = [];
    page.on('pageerror', err => errors.push(err.message));
    const resp = await page.goto('https://66.yunxnet.cn/pwreset', { waitUntil: 'domcontentloaded', timeout: 20000 });
    await page.waitForTimeout(1000);
    const overflow = await page.evaluate(() => document.documentElement.scrollWidth > window.innerWidth);
    await page.screenshot({ path: path.join(__dirname, 'results', 'pwreset-mobile-390.png'), fullPage: true });
    results.pwresetMobile = { status: resp.status(), overflow, errors };
    await page.close();
  }

  await browser.close();
  console.log(JSON.stringify(results, null, 2));
})();
