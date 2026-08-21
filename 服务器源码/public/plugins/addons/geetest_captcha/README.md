# GeeTest CAPTCHA for IDCsmart

IDCsmart 财务系统的极验行为验证第四代插件。插件通过客户端 GT4 组件取得验证参数，并在受保护业务控制器运行前调用极验 `/validate` 完成二次校验。

当系统原有页面验证码开关已开启时，插件会通过 `template_custom_clientarea_captcha_html` 替换图形验证码，并通过 `custom_captcha_check` 复用本请求已经完成的 GT4 二次校验，不会要求用户完成两套验证码。

## 安装与配置

1. 将 `geetest_captcha` 目录放入 `public/plugins/addons/`。
2. 在后台插件管理中安装并启用“极验验证码”。
3. 打开插件设置，填写极验后台的 `Captcha ID` 和 `Captcha Key`。
4. 选择展现方式、验证方式，并按需开启注册页和密码页。

后台左侧“极验验证码”菜单中的“功能设置”页面负责读取和保存上述配置。配置保存在系统现有的插件配置记录中，不会额外创建数据表。

登录页始终强制启用。未填写认证信息时，登录请求会失败关闭，不会绕过验证码。

## 当前保护范围

- `POST /login`：邮箱、手机密码和手机验证码登录。
- `POST /register`：邮箱和手机注册。
- `POST /pwreset`：未登录用户重置密码。
- `POST /modify_password`：已登录用户设置或修改密码。

短信和邮件验证码发送接口不消耗极验验证结果；最终业务提交会执行二次校验。

## 扩展

新增页面时，需要同时扩展 `GeetestCaptchaPlugin.php` 中的前后端路由映射，以及 `assets/geetest-captcha.js` 中的页面表单策略。后端默认采用失败关闭策略：极验请求超时、返回非成功结果或参数缺失时均拒绝受保护业务。
