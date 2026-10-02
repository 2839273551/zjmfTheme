const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

function decryptAes(ciphertext) {
  const key = Buffer.from('idcsmart.finance', 'utf8');
  const iv = Buffer.from('9311019310287172', 'utf8');
  const decipher = crypto.createDecipheriv('aes-128-cbc', key, iv);
  let decrypted = decipher.update(ciphertext, 'base64', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}

(async () => {
  const browser = await chromium.launch({ channel: 'msedge', headless: true });
  const page = await browser.newPage();

  // Create an in-memory HTML page with crypto-js and our auth.js
  const authJsContent = fs.readFileSync(path.join(__dirname, '../public/themes/clientarea/ABCLOUD/assets/js/auth.js'), 'utf8');
  const cryptoJsPath = path.join(__dirname, 'results/crypto-js.min.js');

  // If crypto-js not in results, fetch or load from remote
  let html = `<!DOCTYPE html>
<html>
<head>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
  <script>${authJsContent}</script>
</head>
<body>
  <form id="phoneForm" action="/login?action=phone" onsubmit="return encryptPass('phonePwdInp', 'phonePwdEnc');">
    <input type="password" id="phonePwdInp" value="MySecretPassword123!">
    <input type="hidden" name="password" id="phonePwdEnc">
    <button type="submit" id="phoneSubmit">Login</button>
  </form>

  <form id="emailForm" onsubmit="return encryptPass('emailPwdInp', 'emailPwdEnc');">
    <input type="password" id="emailPwdInp" value="EmailSecret456!">
    <input type="hidden" name="password" id="emailPwdEnc">
    <button type="submit" id="emailSubmit">Login</button>
  </form>
</body>
</html>`;

  await page.setContent(html);

  // Test 1: encryptPass on phone form
  const initialPhonePwd = await page.$eval('#phonePwdInp', el => el.value);
  console.log('Initial phone visible password:', initialPhonePwd);
  if (initialPhonePwd !== 'MySecretPassword123!') throw new Error('Initial value mismatch');

  // Trigger encryptPass
  await page.evaluate(() => encryptPass('phonePwdInp', 'phonePwdEnc'));

  const visibleAfter = await page.$eval('#phonePwdInp', el => el.value);
  const hiddenAfter = await page.$eval('#phonePwdEnc', el => el.value);

  console.log('Visible password after 1st encryptPass:', visibleAfter);
  console.log('Hidden password after 1st encryptPass:', hiddenAfter);

  if (visibleAfter !== 'MySecretPassword123!') throw new Error('Visible password was corrupted!');
  if (!hiddenAfter || hiddenAfter === 'MySecretPassword123!') throw new Error('Hidden password was not encrypted!');

  const decrypted1 = decryptAes(hiddenAfter);
  console.log('Decrypted 1:', decrypted1);
  if (decrypted1 !== 'MySecretPassword123!') throw new Error('Decryption mismatch!');

  // Test 2: Trigger encryptPass 5 more times (simulating Geetest or multi-click intercepts)
  for (let i = 0; i < 5; i++) {
    await page.evaluate(() => encryptPass('phonePwdInp', 'phonePwdEnc'));
  }

  const visibleAfterMulti = await page.$eval('#phonePwdInp', el => el.value);
  const hiddenAfterMulti = await page.$eval('#phonePwdEnc', el => el.value);

  console.log('Visible password after 5 more calls:', visibleAfterMulti);
  console.log('Hidden password after 5 more calls:', hiddenAfterMulti);

  if (visibleAfterMulti !== 'MySecretPassword123!') throw new Error('Visible password corrupted after multi-calls!');
  const decryptedMulti = decryptAes(hiddenAfterMulti);
  console.log('Decrypted multi:', decryptedMulti);
  if (decryptedMulti !== 'MySecretPassword123!') throw new Error('Double encryption detected!');

  // Test 3: User edits password
  await page.fill('#phonePwdInp', 'NewPassword999#');
  await page.evaluate(() => encryptPass('phonePwdInp', 'phonePwdEnc'));

  const visibleNew = await page.$eval('#phonePwdInp', el => el.value);
  const hiddenNew = await page.$eval('#phonePwdEnc', el => el.value);
  const decryptedNew = decryptAes(hiddenNew);

  console.log('Visible password after edit:', visibleNew);
  console.log('Decrypted new:', decryptedNew);
  if (visibleNew !== 'NewPassword999#' || decryptedNew !== 'NewPassword999#') throw new Error('Edited password encryption failed!');

  // Test 4: Deduplication of Geetest slots
  const slotCountBefore = await page.evaluate(() => {
    const f = document.getElementById('phoneForm');
    const s1 = document.createElement('div');
    s1.className = 'form-group geetest-captcha-slot';
    s1.textContent = 'Slot 1';
    const s2 = document.createElement('div');
    s2.className = 'form-group geetest-captcha-slot';
    s2.textContent = 'Slot 2';
    f.appendChild(s1);
    f.appendChild(s2);
    return f.querySelectorAll('.geetest-captcha-slot').length;
  });
  console.log('Slots appended:', slotCountBefore);

  await page.waitForTimeout(100);

  const slotCountAfter = await page.evaluate(() => {
    return document.getElementById('phoneForm').querySelectorAll('.geetest-captcha-slot').length;
  });
  console.log('Slots after deduplication observer:', slotCountAfter);
  if (slotCountAfter !== 1) throw new Error('Deduplication observer failed!');

  console.log('ALL SHADOW ENCRYPTION & DEDUPLICATION TESTS PASSED 100%!');
  await browser.close();
})();
