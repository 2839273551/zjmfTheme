const { chromium } = require('playwright');
(async () => {
    const browser = await chromium.launch({ channel: 'msedge', headless: true });
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 }, ignoreHTTPSErrors: true });
    
    page.on('console', msg => console.log('PAGE LOG:', msg.type(), msg.text()));
    page.on('pageerror', err => console.log('PAGE ERROR:', err.message));
    page.on('request', req => {
        if (req.method() === 'POST' || req.url().includes('cart')) {
            console.log('REQ:', req.method(), req.url());
        }
    });
    page.on('response', resp => {
        if (resp.request().method() === 'POST' || resp.url().includes('cart')) {
            console.log('RESP:', resp.status(), resp.url());
        }
    });

    console.log('1. Loading configureproduct page...');
    await page.goto('https://66.yunxnet.cn/cart?action=configureproduct&pid=148', { waitUntil: 'networkidle' });
    
    console.log('2. Page loaded. Checking #addToCartBtn and form...');
    const formInfo = await page.evaluate(() => {
        const form = document.querySelector('#addCartForm');
        const btn = document.querySelector('#addToCartBtn');
        const btnTwo = document.querySelector('#addToCartBtnTwo');
        return {
            hasForm: !!form,
            formAction: form ? form.action : null,
            formMethod: form ? form.method : null,
            hasBtn: !!btn,
            btnVisible: btn ? (btn.offsetWidth > 0 && btn.offsetHeight > 0) : false,
            hasBtnTwo: !!btnTwo,
            passwordVal: document.querySelector('.getPassword') ? document.querySelector('.getPassword').value : null,
            invalidCount: document.querySelectorAll('.is-invalid').length
        };
    });
    console.log('Form & button state:', formInfo);

    console.log('3. Clicking #addToCartBtn...');
    try {
        const [response] = await Promise.all([
            page.waitForNavigation({ timeout: 5000 }).catch(e => 'Navigation timeout: ' + e.message),
            page.click('#addToCartBtn')
        ]);
        console.log('Navigation result:', response);
    } catch (e) {
        console.log('Click error:', e.message);
    }

    console.log('4. Current URL:', page.url());
    
    // Check if any error alert or toastr message appeared
    const alerts = await page.evaluate(() => {
        const toastr = document.querySelector('.toast-message');
        const alert = document.querySelector('.alert');
        const invalid = Array.from(document.querySelectorAll('.is-invalid')).map(el => el.name || el.id || el.className);
        return {
            toastr: toastr ? toastr.innerText : null,
            alert: alert ? alert.innerText : null,
            invalid: invalid
        };
    });
    console.log('Alerts & Invalid fields:', alerts);

    await page.screenshot({ path: 'C:/Users/28392/Desktop/Codex项目/开源模板/ABCLOUD/qa/results/after-add-cart-click.png' });
    await browser.close();
})();
