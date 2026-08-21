# zjmfTheme：IDC 三端主题与站点源码

本仓库保存从服务器同步并完成安全整理的 IDC 售卖系统源码，应用版本为 `3.7.6`。当前主要开发目标是统一维护 `codex_framework` 三端主题：官网、购物车和用户中心。

> GitHub 仓库是代码和文档的唯一权威来源。生产数据库配置、密钥、运行缓存、服务器备份和用户上传文件不会进入版本库。

## 核心目录

```text
服务器源码/
├─ app/                         应用代码与配置
├─ data/route/                  系统路由文件
├─ public/                      Web 入口、主题、插件和静态资源
│  ├─ themes/web/               官网主题
│  ├─ themes/cart/              购物车主题
│  ├─ themes/clientarea/        用户中心主题
│  └─ plugins/                  插件
├─ vendor/                      PHP 依赖
├─ think                        命令行入口
└─ version                      系统版本
文档/                           当前有效的项目文档
```

服务器专用内容由 `.gitignore` 排除，包括 `app/config/database.php`、`public/.user.ini`、`data/runtime/`、`.codex-backups/`、用户上传目录和本地归档资料。

## 文档入口

- [项目架构与模板开发](文档/项目架构与模板开发.md)
- [安装部署与配置](文档/安装部署与配置.md)
- [维护、发布与回滚](文档/维护发布与回滚.md)
- [安全与仓库管理](文档/安全与仓库管理.md)
- [当前状态与后续计划](文档/当前状态与后续计划.md)
- [开发路线图](文档/开发路线图.md)

## 快速开始

1. 克隆私有仓库。
2. 将 `服务器源码/app/config/database.example.php` 复制为 `database.php`，仅在部署环境填写真实值。
3. 配置 PHP、Web 服务器、ionCube Loader 和目录权限，站点根目录指向 `服务器源码/public/`。
4. 通过后台分别启用 Web、Cart 和 Client Area 的 `codex_framework` 主题。
5. 清理应用和模板缓存后，按三端完整流程验收。

详细步骤见[安装部署与配置](文档/安装部署与配置.md)。

## 开发边界

日常主题开发优先限制在：

```text
服务器源码/public/themes/web/codex_framework/
服务器源码/public/themes/cart/codex_framework/
服务器源码/public/themes/clientarea/codex_framework/
```

不得提交真实凭据，不得修改 ionCube 加密核心、生产业务数据或 `vendor/` 中的第三方实现。发布前必须备份远端目标文件，只发布本次修改，并完成缓存清理、真实数据验证和回滚检查。
