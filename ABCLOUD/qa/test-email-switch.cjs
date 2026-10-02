const { chromium } = require("playwright");
(async () => {
    const browser = await chromium.launch({ channel: "msedge", headless: true });
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 }, ignoreHTTPSErrors: true });
    
    // Add product to cart first
    await page.goto("https://66.yunxnet.cn/cart?action=configureproduct&pid=148", { waitUntil: "networkidle" });
    await Promise.all([
        page.waitForNavigation({ waitUntil: "networkidle" }),
        page.click("#addToCartBtn")
    ]);
    console.log("1. On viewcart page:", page.url());
    await page.screenshot({ path: "C:/Users/28392/Desktop/Codex项目/开源模板/ABCLOUD/qa/results/viewcart-phone-mode.png", fullPage: false });
    
    console.log("2. Clicking 邮箱注册...");
    await page.click("#register label:nth-child(2)");
    await page.waitForTimeout(500);

    const emailModeState = await page.evaluate(() => {
        const phoneDivs = Array.from(document.querySelectorAll(".registerphone")).map(el => ({
            visible: el.offsetWidth > 0 && el.offsetHeight > 0,
            display: window.getComputedStyle(el).display
        }));
        const emailDivs = Array.from(document.querySelectorAll(".registeremail")).map(el => ({
            visible: el.offsetWidth > 0 && el.offsetHeight > 0,
            display: window.getComputedStyle(el).display
        }));
        return { phoneDivs, emailDivs };
    });
    console.log("Email mode result:", JSON.stringify(emailModeState, null, 2));
    await page.screenshot({ path: "C:/Users/28392/Desktop/Codex项目/开源模板/ABCLOUD/qa/results/viewcart-email-mode.png", fullPage: false });

    console.log("3. Clicking back to 手机注册...");
    await page.click("#register label:nth-child(1)");
    await page.waitForTimeout(500);
    await page.screenshot({ path: "C:/Users/28392/Desktop/Codex项目/开源模板/ABCLOUD/qa/results/viewcart-phone-mode-back.png", fullPage: false });

    await browser.close();
    console.log("All tests completed!");
})();
