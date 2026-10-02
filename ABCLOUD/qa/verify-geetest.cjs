const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });

  const report = {};

  // 1. Check Login Page
  {
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
    const errors = [];
    page.on('pageerror', err => errors.push(err.message));
    await page.goto('https://66.yunxnet.cn/login', { waitUntil: 'domcontentloaded', timeout: 20000 });
    await page.waitForTimeout(1500);

    const loginStats = await page.evaluate(() => {
      const phoneSlot = document.querySelector('#phone .geetest-captcha-slot');
      const emailSlot = document.querySelector('#email .geetest-captcha-slot');
      const allSlots = document.querySelectorAll('.geetest-captcha-slot');
      return {
        totalSlots: allSlots.length,
        hasPhoneSlot: !!phoneSlot,
        phoneSlotText: phoneSlot ? phoneSlot.textContent.trim().replace(/\s+/g, ' ') : null,
        hasEmailSlot: !!emailSlot,
        emailSlotText: emailSlot ? emailSlot.textContent.trim().replace(/\s+/g, ' ') : null
      };
    });

    await page.screenshot({ path: path.join(__dirname, 'results', 'geetest-login-phone-1440.png'), fullPage: false });

    // Switch to email tab
    await page.evaluate(() => {
      const btn = document.querySelector('#tab-email');
      if (btn) btn.click();
    });
    await page.waitForTimeout(500);
    await page.screenshot({ path: path.join(__dirname, 'results', 'geetest-login-email-1440.png'), fullPage: false });

    report.login = { stats: loginStats, errors };
    await page.close();
  }

  // 2. Check Register Page
  {
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
    const errors = [];
    page.on('pageerror', err => errors.push(err.message));
    await page.goto('https://66.yunxnet.cn/register', { waitUntil: 'domcontentloaded', timeout: 20000 });
    await page.waitForTimeout(1500);

    const registerStats = await page.evaluate(() => {
      const phoneSlot = document.querySelector('#phone .geetest-captcha-slot');
      const emailSlot = document.querySelector('#email .geetest-captcha-slot');
      const allSlots = document.querySelectorAll('.geetest-captcha-slot');
      return {
        totalSlots: allSlots.length,
        hasPhoneSlot: !!phoneSlot,
        phoneSlotText: phoneSlot ? phoneSlot.textContent.trim().replace(/\s+/g, ' ') : null,
        hasEmailSlot: !!emailSlot,
        emailSlotText: emailSlot ? emailSlot.textContent.trim().replace(/\s+/g, ' ') : null
      };
    });

    await page.screenshot({ path: path.join(__dirname, 'results', 'geetest-register-phone-1440.png'), fullPage: false });

    // Switch to email tab
    await page.evaluate(() => {
      const btn = document.querySelector('#tab-email');
      if (btn) btn.click();
    });
    await page.waitForTimeout(500);
    await page.screenshot({ path: path.join(__dirname, 'results', 'geetest-register-email-1440.png'), fullPage: false });

    report.register = { stats: registerStats, errors };
    await page.close();
  }

  // 3. Mobile Register Check
  {
    const page = await browser.newPage({ viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true });
    const errors = [];
    page.on('pageerror', err => errors.push(err.message));
    await page.goto('https://66.yunxnet.cn/register', { waitUntil: 'domcontentloaded', timeout: 20000 });
    await page.waitForTimeout(1500);

    const overflow = await page.evaluate(() => document.documentElement.scrollWidth > window.innerWidth);
    await page.screenshot({ path: path.join(__dirname, 'results', 'geetest-register-mobile-390.png'), fullPage: true });

    report.registerMobile = { overflow, errors };
    await page.close();
  }

  await browser.close();
  console.log(JSON.stringify(report, null, 2));
})();
