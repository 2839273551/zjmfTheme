# IDC 三端主题交付包工作指令

## 权威来源与启动检查

- 唯一权威仓库为 `https://github.com/2839273551/zjmfTheme.git`，基准分支为 `main`。
- 每个新任务先执行有超时限制的 `git fetch origin main`，比较本地 `HEAD`、`origin/main` 和工作区状态。
- 工作区干净且当前分支仅落后时，只使用 `git merge --ff-only origin/main`；存在本地修改、领先或分叉时不得重置或覆盖。
- 实质工作前读取根目录 `README.md` 和目标目录当前代码。网络不可用时必须说明只依据最后一次获取的 `origin/main`。
- GitHub 直连失败时，可仅对当前 Git 命令使用 `http://127.0.0.1:7897`，不得持久写入代理、凭据或令牌。

## 仓库边界

- `web/`、`cart/`、`clientarea/` 分别对应三端 `codex_framework` 覆盖文件。
- `plugins/` 只保存本项目新开发的插件，每个插件使用独立子目录。
- 不把完整 IDCsmart 程序、`default` 父主题、ionCube 核心、`vendor/`、生产配置、运行数据、缓存、备份或用户上传资料重新加入仓库。
- 运行时 `/themes/...` URL 和 `themes/.../default` include 指向服务器现有平台文件，不因仓库精简而改写。

## 开发规则

- 默认修改范围仅限用户点名的端或插件；跨端共用文件变化时核对全部受影响端。
- 保留模板字段、Hook、表单 action、隐藏字段、`id`、`class`、`name`、`data-*` 和 AJAX 参数。
- Cart 与 Client Area 继续依赖兼容的 `default` 父主题，金额、库存、订单摘要、服务状态、权限和验证码结果以服务端为准。
- 保留现有干净灰蓝视觉基线。
- 某一端有模板、样式、脚本或资源变更时，在同一提交更新该端 `VERSION` 和主题自有静态资源缓存参数；未变更端不提升版本。

## 发布边界

- 仓库目录与服务器目标路径的映射以 `README.md` 为准。
- 只发布本任务实际变更：先清单、只读检查和备份，再暂存、校验 SHA-256、逐文件安装并清缓存。
- 禁止整站覆盖、远端递归删除、`rsync --delete` 或递归权限修改。
- 推送后核对本地 `HEAD`、`origin/main` 与 GitHub 提交一致，并确认 README 和目标文件可从 GitHub 打开。
