import asyncio
import os
from playwright.async_api import async_playwright

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch(
            channel="msedge",
            headless=True,
            args=["--host-resolver-rules=MAP 66.yunxnet.cn 121.41.65.120", "--ignore-certificate-errors"]
        )
        context = await browser.new_context(viewport={"width": 1440, "height": 900})
        page = await context.new_page()

        print("1. Visiting login...")
        await page.goto("https://66.yunxnet.cn/login", wait_until="networkidle")

        # 填入手机号与密码
        await page.fill("#phoneInp", "13273184758")
        await page.fill("#phonePwdInp", "20040221c")

        print("2. Clicking login submit...")
        try:
            async with page.expect_navigation(wait_until="networkidle", timeout=15000):
                await page.click('#phone button[type="submit"]')
        except Exception as e:
            print("Navigation wait:", e)

        print("Current URL:", page.url)

        # 访问 /details
        print("3. Visiting /details...")
        resp = await page.goto("https://66.yunxnet.cn/details", wait_until="networkidle")
        print("/details status:", resp.status if resp else "none", "URL:", page.url)
        content = await page.content()
        with open("ABCLOUD/qa/results/details-native.html", "w", encoding="utf-8") as f:
            f.write(content)
        await page.screenshot(path="ABCLOUD/qa/results/details-native.png")

        # 访问 /security
        print("4. Visiting /security...")
        resp_sec = await page.goto("https://66.yunxnet.cn/security", wait_until="networkidle")
        print("/security status:", resp_sec.status if resp_sec else "none", "URL:", page.url)
        content_sec = await page.content()
        with open("ABCLOUD/qa/results/security-native.html", "w", encoding="utf-8") as f:
            f.write(content_sec)
        await page.screenshot(path="ABCLOUD/qa/results/security-native.png")

        await browser.close()
        print("Finished successfully!")

if __name__ == "__main__":
    asyncio.run(main())
