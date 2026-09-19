<div align="center">
  <h1>zjmfTheme · 企业级云计算与财务运营三端主题套件</h1>
  <p>专为 IDCsmart (智简魔方) 打造的高端商业化门户、动态订购配置中心与用户管理体系</p>

  <p>
    <a href="https://developer.mozilla.org/zh-CN/docs/Web/JavaScript"><img src="https://img.shields.io/badge/Language-JavaScript%20ES6+-f7df1e?style=flat-square&logo=javascript&logoColor=black" alt="JavaScript"/></a>
    <a href="https://developer.mozilla.org/zh-CN/docs/Web/CSS"><img src="https://img.shields.io/badge/Style-CSS3%20%2F%20Modern%20Responsive-1572b6?style=flat-square&logo=css3&logoColor=white" alt="CSS3"/></a>
    <a href="https://www.smarty.net/"><img src="https://img.shields.io/badge/Template-Smarty%20Engine-f0ad4e?style=flat-square" alt="Smarty"/></a>
    <a href="https://www.geetest.com/"><img src="https://img.shields.io/badge/Security-Geetest%20GT4%20Plugin-007acc?style=flat-square" alt="Geetest"/></a>
    <a href="https://www.idcsmart.com/"><img src="https://img.shields.io/badge/Platform-IDCsmart%203.7+-ff5722?style=flat-square" alt="IDCsmart"/></a>
    <a href="./LICENSE"><img src="https://img.shields.io/badge/License-Commercial%20MIT-blue?style=flat-square" alt="License"/></a>
  </p>
</div>

---

## 📖 项目定位与业务背景

**zjmfTheme** 是一套面向企业级 IDC 云计算供应商、云服务器租用平台与 SaaS 商业运营的**全栈三端前端交互主题解决方案**。

项目针对传统主机财务系统（IDCsmart / 魔方系统）模板老旧、移动端体验差、多维规格计算卡顿、缺少企业级安全验证等痛点，进行了**端到端的前端现代化重构**。涵盖 **门户官网 (Web)**、**智能购物车与多维资源计费器 (Cart)**、**客户管理中心 (ClientArea)** 以及**自研极验 GT4 安全防御插件**，提供媲美阿里云、腾讯云等头部公有云的极简深色商务质感与交互体验。

---

## 🏛️ 三端协同交互架构

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                            zjmfTheme 整体系统架构                            │
├──────────────────────┬───────────────────────────┬──────────────────────────┤
│    Web 门户展示端     │   Cart 订购与规格计算端    │   ClientArea 客户控制台  │
│  - 深空极简科技设计  │  - 云主机多维配置联动器   │  - 资产与服务全生命周期  │
│  - 动态产品展台矩阵  │  - 阶梯周期与优惠折算法   │  - 财务账单与在线充值流水│
│  - 全端响应式自适应  │  - 毫秒级原生价格响应     │  - 售后工单流式时间轴对话│
└──────────┬───────────┴─────────────┬─────────────┴────────────┬─────────────┘
           │                         │                          │
           └─────────────────────────┼──────────────────────────┘
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          底层安全与防护扩展层                               │
│       自研极验 Geetest GT4 行为式无感人机验证插件 (plugins/geetest_captcha)   │
│       - 防撞库与刷接口攻击机制  │  - 提交去抖防重放保护状态机                 │
└────────────────────────────────────┬────────────────────────────────────────┘
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         宿主程序与数据契约映射                              │
│         IDCsmart 核心引擎 (Smarty 渲染层 + RESTful 后端业务逻辑)             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## ⚡ 核心工程亮点与技术实践

### 1. 动态云资源多维联动价格计算引擎
- **业务痛点**：云服务器订购涉及 CPU 核数、内存大小、系统盘容量、弹性数据盘、公网带宽（按量/按固定）、DDoS 防御峰值、线路类型等多达 10+ 维度的联动，传统实现频繁请求后端接口，容易出现计算阻塞和白屏。
- **纯前端自研算法**：在 `cart/assets/js/configure.js` 中构建了高效的纯前端响应式计算状态机。参数滑动或切换时，本地毫秒级实时演算阶梯折扣（年付/季付/月付比例折算与优惠码叠加），首屏与配置切换**0 延迟响应**，操作体验丝滑流畅。

### 2. 深度暗黑科技质感与移动端全量自适应
- **设计风格**：采用现代化深空黑灰（Dark Modern Space）配色，搭配精准的微金属边框发光、半透明毛玻璃微卡片与高对比度文字排印，塑造专业严谨的数字化企业形象。
- **弹性自适应**：全套采用弹性 CSS Grid 与 Flexbox 布局，针对超宽带桌面大屏、iPad 等平板设备以及各种移动端屏幕，全面重构适配表单与操作按钮，在移动端自动折叠为单列手风琴卡片，杜绝页面横向滚动与文字截断。

### 3. 自研极验 GT4 行为式人机验证防御插件
- **安全保障**：为彻底防止恶意脚本恶意扫描、刷单占用云主机库存以及密码撞库风险，针对 IDCsmart 平台自主研发了 `plugins/geetest_captcha/` 插件。
- **无感风控验证**：接入最新一代极验 GT4 验证引擎，支持行为特征分析。在登录、注册与关键付款场景下嵌入防抖与状态机锁（`isSubmitting`），彻底杜绝重复提交与高并发重放攻击。

### 4. 架构解耦与非侵入式热覆盖规范
- **低耦合工程化**：严格遵循模块化与依赖隔离规范，将所有自定义样式与脚本收敛至 `assets/` 与 `assets_custom/`，不污染宿主程序核心逻辑。
- **升级免维护**：当 IDCsmart 官方内核执行日常版本升级热更时，本主题套件可作为标准模板资产直接独立存在，完全不产生代码冲突。

---

## 📂 仓库模块结构

```text
zjmfTheme/
├── web/                       # 官网门户主题包
│   ├── assets/                # 门户样式、交互脚本与品牌视觉切图
│   └── templates/             # 首页、产品页、关于我们等 Smarty 模板
├── cart/                      # 购物车与云资源订购中心
│   ├── assets/
│   │   ├── css/               # 订购专属样式集
│   │   └── js/configure.js    # 核心：多维规格联动与动态价格演算器
│   ├── configureproduct.tpl   # 产品详细规格自定义选配器
│   ├── ordersummary.tpl       # 订单结算汇总与优惠明细
│   └── product.tpl            # 云产品分类货架展示列表
├── clientarea/                # 用户控制台与资产管理中心
│   ├── assets_custom/         # 控制台专属定制 CSS/JS
│   ├── clientarea.tpl         # 用户总览大盘与仪表盘
│   └── service.css            # 实例开通、监控与生命周期操作样式
├── plugins/
│   └── geetest_captcha/       # 自研极验 GT4 行为式验证码核心扩展插件
├── scripts/
│   └── validate-theme.ps1     # 模板完整性与工程语法自动化静态校验脚本
└── README.md                  # 工程架构与部署文档
```

---

## 🛠️ 安装与部署映射

本主题作为针对 IDCsmart 系统的专业覆盖增强套件，部署时只需将对应目录映射或软链接至系统对应路径：

| 本仓库源码目录 | IDCsmart 宿主系统标准目标路径 | 说明 |
| :--- | :--- | :--- |
| `web/` | `public/themes/web/codex_framework/` | 门户官网前端主题 |
| `cart/` | `public/themes/cart/codex_framework/` | 购物车与云产品配置选购页 |
| `clientarea/` | `public/themes/clientarea/codex_framework/` | 客户控制台中心主题 |
| `plugins/geetest_captcha/` | `public/plugins/addons/geetest_captcha/` | 极验 GT4 行为式验证安全插件 |

### 快速启用步骤：
1. 将对应目录上传至服务器对应的 `themes/` 与 `plugins/` 目录。
2. 登录魔方财务系统管理后台 -> **系统设置** -> **主题模板**。
3. 在 Web、Cart、ClientArea 分别下拉选中 `codex_framework` 主题并保存生效。
4. 进入 **插件管理** 启用 `极验验证码插件`，填入商户密钥即可完成全站防护闭环。

---

## 📄 许可证
本项目遵循 [MIT License](./LICENSE) 协议发布与维护。
