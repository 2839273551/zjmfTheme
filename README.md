# zjmfTheme：IDC 三端主题交付包

本仓库只维护 IDCsmart `3.7.6` 使用的 `codex_framework` 三端主题和本项目新开发的插件，不再保存完整程序、父主题、`vendor/`、运行数据或服务器配置。

GitHub 是这些自定义文件和说明的唯一权威来源。完整 IDCsmart 程序必须由已安装且版本匹配的运行环境提供。

## 仓库目录

```text
web/                         Web 官网主题
cart/                        Cart 购物车主题
clientarea/                  Client Area 用户中心主题
plugins/
└─ geetest_captcha/          本项目开发的极验 GT4 插件
```

四个目录均为服务器覆盖包，不能把仓库根目录直接作为网站根目录运行。

## 安装映射

部署时将目录内容安装到现有 IDCsmart 程序的对应位置：

| 仓库目录 | 服务器目标目录 |
| --- | --- |
| `web/` | `public/themes/web/codex_framework/` |
| `cart/` | `public/themes/cart/codex_framework/` |
| `clientarea/` | `public/themes/clientarea/codex_framework/` |
| `plugins/geetest_captcha/` | `public/plugins/addons/geetest_captcha/` |

安装前必须确认目标程序版本及父主题兼容性。Cart 和 Client Area 继承 `default`，Web 的 Cart 公共头也使用 Client Area `default` 提供的 jQuery、Bootstrap 和 Toastr；本仓库不复制这些平台文件。

后台主题配置键：

```text
themes_templates = codex_framework
order_page_style = codex_framework
clientarea_default_themes = codex_framework
```

## 三端版本

三端分别在各自目录的 `VERSION` 文件中维护独立 SemVer：

| 界面 | 当前版本 |
| --- | --- |
| Web | `1.0.0` |
| Cart | `1.0.0` |
| Client Area | `1.0.0` |

版本维护规则：

- 某一端的模板、样式、脚本或主题资源有变化时，必须在同一提交中更新该端 `VERSION`；没有变化的端不提升版本。
- `MAJOR` 表示不兼容的模板契约或结构变化，`MINOR` 表示向后兼容的新页面或新能力，`PATCH` 表示兼容修复、样式、可访问性或性能调整。
- 该端主题自有静态资源 URL 的缓存参数必须与 `VERSION` 一致。Client Area 可保留平台 `{$Ver}` 前缀，例如 `?v={$Ver}-1.0.1`。
- 平台父主题和第三方资源继续使用系统的 `{$Ver}`，不得为了主题版本统一而修改 `default`。
- 被多端共同使用的文件发生变化时，应提升所有实际受影响端的版本。

## 当前功能

- Web：首页、Cart 共用头尾和首屏离场 skeleton。
- Cart：产品列表、商品配置外壳、服务端实时订单摘要及 AJAX skeleton。
- Client Area：公共头尾、认证页、仪表盘、服务列表和服务详情外壳。
- GeeTest：GT4 登录、注册、找回密码和修改密码保护，当前插件版本 `1.0.2`。

业务金额、库存、状态、权限和验证码结果始终以服务端返回为准。不得删除模板使用的字段、Hook、`id`、`class`、`data-*`、AJAX 参数或父主题 include。

## 发布流程

1. 获取并核对最新 `origin/main`，确认工作区没有未提交内容或分叉。
2. 列出本轮实际变更文件及受影响端版本。
3. 在服务器为每个目标文件建立带时间戳备份。
4. 上传到暂存目录，核对文件清单与 SHA-256。
5. 按上表逐文件安装，不覆盖完整程序，不递归删除目标目录。
6. 在服务器程序目录执行 `php think clear`。
7. 使用真实域名验证 `/`、`/cart`、实际商品配置页、`/clientarea` 及受影响业务链路。
8. 记录主题版本、GitHub 提交哈希、发布时间、文件清单和验收结论。

禁止整站覆盖、`rsync --delete`、远端递归删除或递归权限修改。出现模板错误、静态资源 404、金额异常、验证码失效或关键流程失败时，应立即从本轮备份回滚并再次清缓存。

## 安全边界

- 不向仓库加入完整 IDCsmart 程序、`default` 父主题、ionCube 加密核心或 `vendor/`。
- 不提交数据库配置、`.env`、密码、密钥、令牌、证书、服务器地址、运行缓存、备份或用户上传资料。
- 保留现有干净灰蓝视觉基线。
- 插件配置保存在系统插件配置中，不写入仓库。

## 生产发布记录

### 2026-08-21：Web / Cart skeleton 1.0.0

- GitHub 基线：`cbe67b3c51868b693c5a82d41faa029e68d51674`。
- 发布标识：`skeleton-1.0.0-20260821-164644`。
- 发布范围：Web 首页 5 个文件、Cart 商品配置 5 个文件；未覆盖完整程序或父主题。
- 服务器备份和暂存均按发布标识保留，原有 8 个文件已备份，原先缺失的 2 个 `VERSION` 已记录。
- 10 个暂存文件和线上文件均通过 SHA-256 校验，所有者及权限为 `www:www 0644`，`php think clear` 成功。
- 已使用真实首页、产品中心和可用商品配置页验收桌面与 390px 手机视口；AJAX skeleton、`aria-busy`、摘要恢复和加购按钮状态正常，无横向溢出或控制台错误。
