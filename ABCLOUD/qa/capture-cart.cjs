const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

(async () => {
    const outDir = path.join(__dirname, 'results');
    if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

    const browser = await chromium.launch({ channel: 'msedge', headless: true });
    
    for (const vp of [
        { name: '1440', width: 1440, height: 900 },
        { name: '1280', width: 1280, height: 900 },
        { name: '390', width: 390, height: 844 }
    ]) {
        const context = await browser.newContext({ viewport: { width: vp.width, height: vp.height }, ignoreHTTPSErrors: true });
        const page = await context.newPage();
        
        const errors = [];
        page.on('pageerror', err => errors.push(err.message));
        page.on('console', msg => {
            if (msg.type() === 'error') errors.push(msg.text());
        });

        console.log(`Loading /cart on ${vp.name}...`);
        const resp = await page.goto('https://66.yunxnet.cn/cart?fid=1&gid=42', { waitUntil: 'networkidle', timeout: 30000 });
        console.log(`Status: ${resp.status()}`);

        const shotPath = path.join(outDir, `cart-${vp.name}.png`);
        await page.screenshot({ path: shotPath, fullPage: false });
        console.log(`Screenshot saved: ${shotPath}, errors: ${errors.length}`);

        if (errors.length) {
            console.log('Console errors:', errors);
        }

        await context.close();
    }

    await browser.close();
    console.log('Cart visual QA complete.');
})();
