const { chromium } = require("playwright");
(async () => {
    const browser = await chromium.launch({ channel: "msedge", headless: true });
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 }, ignoreHTTPSErrors: true });
    
    // Add product to cart
    await page.goto("https://66.yunxnet.cn/cart?action=configureproduct&pid=148", { waitUntil: "networkidle" });
    await Promise.all([
        page.waitForNavigation({ waitUntil: "networkidle" }),
        page.click("#addToCartBtn")
    ]);
    console.log("1. Landed on viewcart:", page.url());

    // Inspect action buttons
    const btnInfo = await page.evaluate(() => {
        const delBtn = document.querySelector("a[onclick*=\"removeItem\"]");
        const editBtn = document.querySelector("a[href*=\"action=configureproduct\"]");
        const delIcon = delBtn ? delBtn.querySelector("i") : null;
        
        function b(el) {
            if (!el) return null;
            const r = el.getBoundingClientRect();
            const cs = window.getComputedStyle(el);
            return {
                visible: r.width > 0 && r.height > 0,
                rect: { width: r.width, height: r.height, top: r.top, left: r.left },
                display: cs.display,
                color: cs.color,
                background: cs.backgroundColor
            };
        }
        return {
            delBtn: b(delBtn),
            editBtn: b(editBtn),
            delIcon: delIcon ? {
                fontFamily: window.getComputedStyle(delIcon).fontFamily,
                content: window.getComputedStyle(delIcon, "::before").content
            } : null
        };
    });
    console.log("Button info:", JSON.stringify(btnInfo, null, 2));

    await page.screenshot({ path: "C:/Users/28392/Desktop/Codex项目/开源模板/ABCLOUD/qa/results/viewcart-with-delete-btn.png", fullPage: false });

    // Test clicking delete button to verify modal opens
    console.log("2. Clicking delete button...");
    await page.click("a[onclick*=\"removeItem\"]");
    await page.waitForTimeout(500);

    const modalVisible = await page.evaluate(() => {
        const modal = document.querySelector("#customModal");
        return {
            modalExists: !!modal,
            isShown: modal ? modal.classList.contains("show") : false,
            bodyText: modal ? modal.querySelector("#customBody").innerText : null
        };
    });
    console.log("Modal state:", modalVisible);

    await page.screenshot({ path: "C:/Users/28392/Desktop/Codex项目/开源模板/ABCLOUD/qa/results/viewcart-delete-modal.png", fullPage: false });

    await browser.close();
    console.log("Delete test completed successfully!");
})();
