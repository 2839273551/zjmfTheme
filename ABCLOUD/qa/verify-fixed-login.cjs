const path = require('path');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true,
    args: ['--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120', '--ignore-certificate-errors']
  });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
  await page.goto('https://66.yunxnet.cn/login', { waitUntil: 'networkidle' });

  // 1. Check Geetest slots count
  const slotsCount = await page.evaluate(() => document.querySelectorAll('#phone .geetest-captcha-slot').length);
  console.log('Phone form Geetest slots count:', slotsCount);

  // 2. Check inputs in phone form
  const inputs = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('#phone form input')).map(i => ({
      name: i.name,
      id: i.id,
      type: i.type,
      value: i.value,
      disabled: i.disabled
    }));
  });
  console.log('Phone form inputs:', inputs);

  // 3. Test typing password
  await page.fill('#phoneInp', '13273184758');
  await page.fill('#phonePwdInp', '20040221c');

  const visiblePwdBefore = await page.$eval('#phonePwdInp', el => el.value);
  const hiddenPwdBefore = await page.$eval('#phonePwdEnc', el => el.value);
  console.log('Visible Pwd before submit:', visiblePwdBefore);
  console.log('Hidden Pwd before submit:', hiddenPwdBefore);

  // 4. Trigger submit
  await page.evaluate(() => {
    const form = document.querySelector('#phone form');
    // Run onsubmit directly
    form.onsubmit();
  });

  const visiblePwdAfter = await page.$eval('#phonePwdInp', el => el.value);
  const hiddenPwdAfter = await page.$eval('#phonePwdEnc', el => el.value);
  console.log('Visible Pwd after submit:', visiblePwdAfter);
  console.log('Hidden Pwd after submit:', hiddenPwdAfter);

  if (visiblePwdAfter !== '20040221c') {
    throw new Error('Visible password was corrupted!');
  }
  if (!hiddenPwdAfter || hiddenPwdAfter === '20040221c') {
    throw new Error('Hidden password was not encrypted!');
  }

  // Decrypt hidden password with AES-128-CBC
  const crypto = require('crypto');
  const key = Buffer.from('idcsmart.finance', 'utf8');
  const iv = Buffer.from('9311019310287172', 'utf8');
  const decipher = crypto.createDecipheriv('aes-128-cbc', key, iv);
  let decrypted = decipher.update(hiddenPwdAfter, 'base64', 'utf8');
  decrypted += decipher.final('utf8');
  console.log('Decrypted hidden password:', decrypted);
  if (decrypted !== '20040221c') {
    throw new Error('Decrypted password does not match!');
  }

  // 5. Test switching to code login (SMS verification code)
  console.log('Testing switch to code login...');
  await page.click('div[onclick*="allow_login_phone_captcha"]');
  await page.waitForTimeout(500);

  const phoneCodeVisible = await page.evaluate(() => {
    const codeInp = document.getElementById('phoneCodeInp');
    const captchaInp = document.getElementById('captcha_allow_login_code_captcha');
    const captchaImg = document.getElementById('allow_login_code_captcha');
    const pwdInp = document.getElementById('phonePwdInp');
    const pwdEnc = document.getElementById('phonePwdEnc');
    return {
      codeInpDisabled: codeInp ? codeInp.disabled : null,
      captchaInpExists: !!captchaInp,
      captchaInpDisabled: captchaInp ? captchaInp.disabled : null,
      captchaImgSrc: captchaImg ? captchaImg.src : null,
      pwdInpDisabled: pwdInp ? pwdInp.disabled : null,
      pwdEncDisabled: pwdEnc ? pwdEnc.disabled : null
    };
  });
  console.log('Code login state:', phoneCodeVisible);

  await page.screenshot({ path: path.join(__dirname, 'results', 'login-fixed-code-mode.png') });

  // Switch back to password login
  await page.click('div[onclick*="allow_login_code_captcha"]');
  await page.waitForTimeout(500);
  await page.screenshot({ path: path.join(__dirname, 'results', 'login-fixed-password-mode.png') });

  console.log('ALL VERIFICATIONS PASSED SUCCESSFULLY!');
  await browser.close();
})();
