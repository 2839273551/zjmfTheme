const { chromium } = require('playwright');
(async () => {
    const browser = await chromium.launch({ channel: 'msedge', headless: true });
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 }, ignoreHTTPSErrors: true });
    await page.goto('https://66.yunxnet.cn/cart?action=viewcart', { waitUntil: 'networkidle' });
    const info = await page.evaluate(() => {
        const phoneDiv = document.querySelector('.registerphone:has(#register_phone_code)');
        const captchaDiv = document.querySelector('.registerphone:has(input[name="captcha"])');
        const phoneInput = document.querySelector('#register_phone');
        const phoneCode = document.querySelector('#register_phone_code');
        const captchaInput = document.querySelector('input[name="captcha"]');
        const captchaImg = document.querySelector('.registerphone img');
        
        function b(el) {
            if (!el) return null;
            const r = el.getBoundingClientRect();
            const cs = window.getComputedStyle(el);
            return {
                tag: el.tagName,
                className: el.className,
                rect: { top: r.top, left: r.left, width: r.width, height: r.height },
                display: cs.display,
                margin: cs.marginTop + ' ' + cs.marginRight + ' ' + cs.marginBottom + ' ' + cs.marginLeft,
                padding: cs.paddingTop + ' ' + cs.paddingRight + ' ' + cs.paddingBottom + ' ' + cs.paddingLeft,
                height: cs.height
            };
        }
        return {
            phoneDiv: b(phoneDiv),
            captchaDiv: b(captchaDiv),
            phoneInput: b(phoneInput),
            phoneCode: b(phoneCode),
            captchaInput: b(captchaInput),
            captchaImg: b(captchaImg)
        };
    });
    console.log(JSON.stringify(info, null, 2));
    await browser.close();
})();
