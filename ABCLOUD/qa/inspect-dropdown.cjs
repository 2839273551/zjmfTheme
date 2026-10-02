const { chromium } = require('playwright');
(async () => {
    const browser = await chromium.launch({ channel: 'msedge', headless: true });
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 }, ignoreHTTPSErrors: true });
    await page.goto('https://66.yunxnet.cn/cart?action=configureproduct&pid=148', { waitUntil: 'networkidle' });
    // No style tag injected - checking true live CSS from server

    const info = await page.evaluate(() => {
        const btn = document.querySelector('.bootstrap-select .btn.dropdown-toggle');
        if (!btn) return 'no btn found';
        const filterOpt = btn.querySelector('.filter-option');
        const inner = btn.querySelector('.filter-option-inner');
        const innerInner = btn.querySelector('.filter-option-inner-inner');
        const img = btn.querySelector('img');
        
        function getBox(el) {
            if (!el) return null;
            const r = el.getBoundingClientRect();
            const cs = window.getComputedStyle(el);
            return {
                tag: el.tagName,
                className: el.className,
                rect: { top: r.top, bottom: r.bottom, height: r.height },
                display: cs.display,
                alignItems: cs.alignItems,
                lineHeight: cs.lineHeight,
                padding: `${cs.paddingTop} ${cs.paddingRight} ${cs.paddingBottom} ${cs.paddingLeft}`,
                margin: `${cs.marginTop} ${cs.marginRight} ${cs.marginBottom} ${cs.marginLeft}`,
            };
        }
        return {
            btn: getBox(btn),
            filterOpt: getBox(filterOpt),
            inner: getBox(inner),
            innerInner: getBox(innerInner),
            img: getBox(img),
            html: btn.outerHTML
        };
    });
    console.log(JSON.stringify(info, null, 2));
    const path = require('path');
    const osRow = await page.$('.form-group.row:has(.bootstrap-select)');
    if (osRow) {
        await osRow.screenshot({ path: path.join(__dirname, 'results', 'os-dropdown-centered.png') });
    }
    await page.screenshot({ path: path.join(__dirname, 'results', 'configure-os-centered-1440.png'), fullPage: false });

    // Test mobile 390
    const mPage = await browser.newPage({ viewport: { width: 390, height: 844 }, ignoreHTTPSErrors: true });
    await mPage.goto('https://66.yunxnet.cn/cart?action=configureproduct&pid=148', { waitUntil: 'networkidle' });
    await mPage.screenshot({ path: path.join(__dirname, 'results', 'configure-os-centered-390.png'), fullPage: false });
    await mPage.close();

    await browser.close();
})();
