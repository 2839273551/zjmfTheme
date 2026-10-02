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

        fixture_url = "file://" + os.path.abspath("ABCLOUD/qa/fixture-details.html").replace("\\", "/")
        print("Loading fixture from:", fixture_url)

        # -------------------------------------------------------------
        # 1. 桌面端 1440x900 测试
        # -------------------------------------------------------------
        print("\n--- TEST 1: Desktop 1440x900 ---")
        page_desk = await browser.new_page(viewport={"width": 1440, "height": 900})
        errors = []
        page_desk.on("pageerror", lambda err: errors.append(err))

        await page_desk.goto(fixture_url, wait_until="networkidle")
        await page_desk.wait_for_timeout(1000)

        # 检查关键 DOM 元素
        title = await page_desk.text_content(".abcloud-profile-header-title span")
        print("Page Header Title:", title.strip())
        username = await page_desk.text_content(".abcloud-side-name span")
        print("Side Username:", username.strip())
        has_avatar = await page_desk.is_visible("#abcloudSideAvatar img.qq-avatar")
        print("Has QQ Avatar:", has_avatar)
        has_cert = await page_desk.is_visible(".abcloud-cert-card")
        print("Has Cert Card:", has_cert)

        assert "个人资料" in title, "Title mismatch"
        assert "崔康毅" in username, "Username mismatch"
        assert len(errors) == 0, f"JS errors found: {errors}"

        # 截图
        os.makedirs("ABCLOUD/qa/results", exist_ok=True)
        await page_desk.screenshot(path="ABCLOUD/qa/results/details-desktop-1440.png", full_page=False)
        print("Desktop screenshot saved: details-desktop-1440.png")

        # -------------------------------------------------------------
        # 2. 交互测试：Tab 切换到“操作日志”
        # -------------------------------------------------------------
        print("\n--- TEST 2: Tab Switch to Logs ---")
        await page_desk.click("#tabBtnLogs")
        await page_desk.wait_for_timeout(500)
        logs_visible = await page_desk.is_visible("#paneLogs")
        print("Logs Pane Visible:", logs_visible)
        assert logs_visible, "Logs pane should be visible"
        await page_desk.screenshot(path="ABCLOUD/qa/results/details-tab-logs-1440.png", full_page=False)

        # 切换回账户资料
        await page_desk.click("#tabBtnAccount")
        await page_desk.wait_for_timeout(300)

        # -------------------------------------------------------------
        # 3. 模态框交互：修改密码弹窗
        # -------------------------------------------------------------
        print("\n--- TEST 3: Modal Password ---")
        await page_desk.click('.abcloud-clickable-input[title*="修改登录密码"]')
        await page_desk.wait_for_timeout(600)
        modal_pwd_visible = await page_desk.is_visible("#modalPassword .modal-content")
        print("Password Modal Visible:", modal_pwd_visible)
        assert modal_pwd_visible, "Password modal should be visible"
        await page_desk.screenshot(path="ABCLOUD/qa/results/details-modal-password.png", full_page=False)

        # 关闭模态框
        await page_desk.click("#modalPassword button[data-dismiss='modal']")
        await page_desk.wait_for_timeout(500)

        # -------------------------------------------------------------
        # 4. 模态框交互：更换手机弹窗
        # -------------------------------------------------------------
        print("\n--- TEST 4: Modal Phone ---")
        await page_desk.click('.abcloud-clickable-input[title*="更换安全手机"]')
        await page_desk.wait_for_timeout(600)
        modal_phone_visible = await page_desk.is_visible("#modalPhone .modal-content")
        print("Phone Modal Visible:", modal_phone_visible)
        assert modal_phone_visible, "Phone modal should be visible"
        await page_desk.screenshot(path="ABCLOUD/qa/results/details-modal-phone.png", full_page=False)

        await page_desk.click("#modalPhone button[data-dismiss='modal']")
        await page_desk.wait_for_timeout(500)
        await page_desk.close()

        # -------------------------------------------------------------
        # 5. 移动端 390x844 测试 (iPhone 13 规格)
        # -------------------------------------------------------------
        print("\n--- TEST 5: Mobile 390x844 ---")
        page_mob = await browser.new_page(viewport={"width": 390, "height": 844})
        await page_mob.goto(fixture_url, wait_until="networkidle")
        await page_mob.wait_for_timeout(1000)

        # 检查横向溢出
        scroll_width, client_width = await page_mob.evaluate("() => [document.documentElement.scrollWidth, document.documentElement.clientWidth]")
        print(f"Mobile Scroll Width: {scroll_width}, Client Width: {client_width}")
        overflow = scroll_width > client_width
        print("Mobile Overflow Detected:", overflow)
        assert not overflow, f"Horizontal overflow detected on mobile: {scroll_width} > {client_width}"

        await page_mob.screenshot(path="ABCLOUD/qa/results/details-mobile-390.png", full_page=False)
        print("Mobile screenshot saved: details-mobile-390.png")
        await page_mob.close()

        await browser.close()
        print("\nALL VERIFICATIONS 100% PASSED!")

if __name__ == "__main__":
    asyncio.run(run_test())
