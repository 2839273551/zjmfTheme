import asyncio
import os
from playwright.async_api import async_playwright

async def run_test():
    async with async_playwright() as p:
        browser = await p.chromium.launch(
            channel="msedge",
            headless=True,
            args=["--ignore-certificate-errors"]
        )

        fixture_url = "file://" + os.path.abspath("ABCLOUD/qa/fixture-clientarea.html").replace("\\", "/")
        print("Loading clientarea fixture from:", fixture_url)

        # 1. 2560x1440 宽屏测试 (与用户屏幕等比例)
        print("\n--- TEST 1: Wide Desktop (2560x1440) ---")
        page_wide = await browser.new_page(viewport={"width": 2560, "height": 1440})
        await page_wide.goto(fixture_url, wait_until="networkidle")
        await page_wide.wait_for_timeout(1000)

        # 检查右上角财务卡片是否饱满可见
        has_credit = await page_wide.is_visible(".abcloud-balance-amount")
        has_flow_link = await page_wide.is_visible(".abcloud-finance-footer-link")
        print("Finance Amount Visible:", has_credit)
        print("Flow Link Visible:", has_flow_link)
        assert has_credit and has_flow_link, "Finance card content must be fully visible"

        # 检查底部通栏横幅宽度
        banner_box = await page_wide.locator(".abcloud-promo-full-banner").bounding_box()
        container_box = await page_wide.locator(".container-fluid").bounding_box()
        print(f"Banner width: {banner_box['width']}, Container width: {container_box['width']}")
        # 宽度应接近一致 (差值在 padding 范围内)
        assert abs(banner_box['width'] - container_box['width']) < 40, "Banner must be full width"

        await page_wide.screenshot(path="ABCLOUD/qa/results/clientarea-wide-2560.png", full_page=False)
        print("Wide screenshot saved: clientarea-wide-2560.png")
        await page_wide.close()

        # 2. 1440x900 标准桌面测试
        print("\n--- TEST 2: Standard Desktop (1440x900) ---")
        page_desk = await browser.new_page(viewport={"width": 1440, "height": 900})
        await page_desk.goto(fixture_url, wait_until="networkidle")
        await page_desk.wait_for_timeout(800)

        await page_desk.screenshot(path="ABCLOUD/qa/results/clientarea-desktop-1440.png", full_page=False)
        print("Desktop screenshot saved: clientarea-desktop-1440.png")
        await page_desk.close()

        # 3. 390x844 移动端测试
        print("\n--- TEST 3: Mobile (390x844) ---")
        page_mob = await browser.new_page(viewport={"width": 390, "height": 844})
        await page_mob.goto(fixture_url, wait_until="networkidle")
        await page_mob.wait_for_timeout(800)

        scroll_width, client_width = await page_mob.evaluate("() => [document.documentElement.scrollWidth, document.documentElement.clientWidth]")
        print(f"Mobile Scroll Width: {scroll_width}, Client Width: {client_width}")
        assert scroll_width <= client_width, "Mobile must not have horizontal overflow"

        await page_mob.screenshot(path="ABCLOUD/qa/results/clientarea-mobile-390.png", full_page=False)
        print("Mobile screenshot saved: clientarea-mobile-390.png")
        await page_mob.close()

        await browser.close()
        print("\nALL CLIENTAREA LAYOUT FIXES VERIFIED 100% PASSED!")

if __name__ == "__main__":
    asyncio.run(run_test())
