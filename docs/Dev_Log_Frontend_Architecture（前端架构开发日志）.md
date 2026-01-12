# 🛠 Notey v2.0 开发实战笔记：从设计到 SwiftUI 原生架构

> **摘要**：记录 Notey v2.0 从 Figma 原型到 iOS 原生代码（SwiftUI）的重构过程，以及独立开发者的架构思考。

## 1. 工作流革新 (Workflow Evolution)

### 🔴 早期方案：Figma 演示
* **路径**：Figma Design -> Prototype Link -> GIF 录屏。
* **痛点**：Figma 演示链接常出现适配问题（手机壳消失），且仅为“图片式”交互，缺乏原生手感，无法直接复用为开发资产。

### 🟢 当前方案：AI 辅助原生开发 (AI-Assisted Native Dev)
* **路径**：`Figma (React Code/Screenshots)` -> `Cursor (Translation)` -> `Xcode (SwiftUI)`。
* **核心优势**：
    * **工程思维**：跳过“画图”阶段，直接产出可用的工程代码。
    * **真实交互**：利用 Xcode Simulator 录制演示，获得原生的点击反馈和转场动画。
    * **所见即所得**：直接验证字号、触控区域在真机上的表现。

---

## 2. 技术架构与工程规范 (Architecture)

为了避免“上帝类 (God Class)”导致的代码难以维护，本项目采用 **MV 模式 + 组件化** 设计。

### 📂 目录结构 (Directory Structure)
```text
Notey/
├── Models/          # 数据模型 (仅定义结构，暂无逻辑)
│   ├── Note.swift
│   └── Folder.swift
├── Views/           # 页面视图 (Screens)
│   ├── Main/        # 主 Tab 页面 (Home, Library, Settings)
│   ├── Detail/      # 详情页 (NoteDetail, QuotaDetail)
│   └── Sheets/      # 弹窗与模态页 (CategorySheet)
├── Components/      # 通用 UI 组件 (LEGO Bricks)
│   ├── NoteCard.swift   # 高频复用的毛玻璃卡片
│   └── ToastView.swift  # 全局提示
└── Extensions/      # 工具扩展 (Color+Hex)
```

### 🧩 组件化开发的意义
* **独立调试 (Isolation)**：通过 `#Preview` 宏，可以单独调试 `NoteCard` 的圆角和阴影，无需运行整个 App。
* **复用性 (Reusability)**：一次编写，处处调用（首页、搜索、收藏页共用同一卡片组件）。
* **解耦 (Decoupling)**：主页面 `ContentView` 仅负责 Tab 导航和容器布局，不包含具体业务逻辑。

---

## 3. 关键技术点 (Key Learnings)

### 🎨 从 React 到 SwiftUI 的“翻译”
利用 Cursor 读取 Figma 生成的 React/Tailwind 代码，转换为 SwiftUI：
* **视觉还原**：`bg-slate-900` -> `LinearGradient`；`backdrop-blur` -> `.ultraThinMaterial`。
* **图标迁移**：`Lucide Icons` -> `SF Symbols` (iOS 原生图标库)。

### 🛠 Mock Data 驱动开发
* **问题**：后端 API 和数据库尚未开发，如何预览 UI？
* **解决**：在 `Models` 中定义静态的 Mock Data（假数据）。
* **应用**：在 `#Preview` 中注入 Mock 对象，实现“无后端”状态下的完整交互体验。

---

## 4. 开发路线图 (Solo Dev Roadmap)

遵循 **"Frontend First" (UI 先行)** 的敏捷开发策略：

- [x] **Phase 1: 皮囊 (Shell)**
    - 完成高保真 UI 复刻。
    - 实现 Tab 切换、列表折叠、页面跳转等核心交互。
    - *当前状态：✅ 已完成 (Mock Data)*
- [ ] **Phase 2: 记忆 (Memory)**
    - 引入 **SwiftData** 本地数据库。
    - 实现 CRUD（增删改查），替换 Mock Data。
- [ ] **Phase 3: 灵魂 (Soul)**
    - 接入 Coze API 实现 AI 总结功能。
    - 开发 Share Extension (系统分享菜单插件)。
- [ ] **Phase 4: 发布 (Ship)**
    - TestFlight 内测与 App Store 上架。

---
*Last Updated: 2026-01-11*
