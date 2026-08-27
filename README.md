# zjmfTheme：IDC 三端主题交付包

本仓库维护 IDCsmart `3.7.6` 使用的 `codex_framework` 三端主题和本项目自研插件。它是安装到现有 IDCsmart 程序的自定义覆盖包，不是可独立运行的网站，也不包含完整程序、父主题、`vendor/`、运行数据或服务器配置。

## 本地项目记忆

从 2026-08-25 起，Codex 使用的长期规则、关键决策、发布约定和历史经验迁移到本地 Obsidian 记忆库。仓库根 `AGENTS.md` 只负责引导本地 Agent 读取总索引和 IDC 项目页；GitHub `main` 继续作为当前源码、版本和公开项目说明的事实来源。

本地 Vault 不属于主题运行依赖，也不提交到本仓库。缺少本地记忆库时，应先配置项目记忆入口，不从已删除文档或旧聊天恢复规则。

## 仓库目录

```text
web/                         Web 官网主题
cart/                        Cart 购物车主题
clientarea/                  Client Area 用户中心主题
plugins/
└─ geetest_captcha/          本项目开发的极验 GT4 插件
scripts/
└─ validate-theme.ps1        本地静态校验脚本
```

## 安装映射

| 仓库目录 | IDCsmart 目标目录 |
| --- | --- |
| `web/` | `public/themes/web/codex_framework/` |
| `cart/` | `public/themes/cart/codex_framework/` |
| `clientarea/` | `public/themes/clientarea/codex_framework/` |
| `plugins/geetest_captcha/` | `public/plugins/addons/geetest_captcha/` |

Cart 与 Client Area 继承兼容的 `default` 父主题；Web 的 Cart 公共头也使用 Client Area `default` 提供的平台资源。仓库精简不代表可以复制或改写这些运行时依赖。

后台主题配置键：

```text
themes_templates = codex_framework
order_page_style = codex_framework
clientarea_default_themes = codex_framework
```

## 当前版本

| 界面 | 版本 |
| --- | --- |
| Web | `1.1.2` |
| Cart | `1.0.1` |
| Client Area | `1.0.2` |
| GeeTest GT4 插件 | `1.0.3` |

版本事实以各目录当前 `VERSION` 和插件声明为准；版本变化时同步更新本表。

## 本地校验

```powershell
pwsh -NoProfile -File scripts/validate-theme.ps1
git diff --check
git status --short
```

## 仓库边界

- 不提交完整 IDCsmart 程序、`default` 父主题、ionCube 核心、`vendor/`、数据库配置、`.env`、凭据、证书、服务器地址、运行缓存、备份或用户上传资料。
- `web/`、`cart/`、`clientarea/` 和插件目录是覆盖包，不能把仓库根目录直接作为网站根目录运行。
- 主题业务数据与验证码结果由服务端决定；仓库只维护自定义模板、样式、脚本、资源和插件代码。
