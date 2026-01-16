# 📝 Notey - 你的 iOS 智能笔记助手

> **Current Status**: v2.0 In Development (Native App) | v1.0 Stable (Shortcuts)
>
> 从“自动化脚本”进化为“本地优先的 AI 笔记容器”。利用碎片时间，将稍后阅读变为结构化知识。

---

## 🚀 项目简介 (Introduction)

在日常娱乐过程中，我们经常在抖音/B站看到有价值的视频（科普、教学、代码分享）。这一类视频知识量巨大，但：
* **手动整理耗时**：打断了原本的“刷视频”心流。
* **收藏即吃灰**：缺乏结构化整理，最终淹没在收藏夹中。

**Notey 解决了这个问题**：它通过系统级分享菜单唤起，静默提取视频文案，利用 AI 总结为 Markdown 笔记，并提供完整的分类归档管理。

---

## 🌟 Next Generation: Notey v2.0 (SwiftUI)

> **v2.0 正在重构中！** 我们致力于解决 v1.0 无法修改、无法分类管理痛点，打造完全独立的 iOS 客户端。

### 💎 v2.0 核心特性
* **📱 独立 App 体验**：不再依赖系统备忘录，基于 SwiftUI 打造的 **"Deep Ocean" (深海毛玻璃)** 沉浸式界面。
* **🔒 数据主权 (Local-First)**：引入 SwiftData 本地数据库。笔记完全本地存储，支持离线查看，无需注册账号。
* **✍️ 读写分离 & 闭环管理**：
    * **View Mode**: 精美的 Markdown 渲染。
    * **Edit Mode**: 源码级编辑，修正 AI 幻觉。
    * **Manage**: 支持**自定义文件夹**归档与**收藏**标记。
* **🔋 零配置开箱即用**：
    * 摒弃繁琐的 API Key 填写。
    * 引入 **Service Quota (服务额度)** 机制，官方托管 API，每日自动刷新免费额度。
* **🛡️ 容错与草稿箱**：网络失败不再丢数据，自动存入 Drafts 草稿箱，支持一键重试。

### 🎨 v2.0 设计预览
<img width="289" height="570" alt="image" src="https://github.com/user-attachments/assets/7ca88bb7-b545-4ed8-bb6b-7f23dd25f1c1" />
👉 **[查看V2.0前端设计代码](./Notey)**
### 🎨 v2.0 设计亮点展示
*[点击查看 V2.0 产品交互亮点展示文档](./V2.0%20关键交互与功能设计说明.md)*

---

## 📺 Legacy: Notey v1.0 (Stable MVP)

> 如果你想立即体验 Notey 的核心流程，可以使用 v1.0 稳定版快捷指令。

### 📸 v1.0 工作流演示
[[点击图片观看视频演示]<img width="289" height="570" alt="image" src="https://github.com/user-attachments/assets/7e0e2b16-599d-4b72-964d-f5c9e4e3eb47" />
](https://www.bilibili.com/video/BV1ZPimBQEJg/)

### 🛠 v1.0 技术架构
* **前端交互**：iOS Shortcuts (原生快捷指令)
* **后端逻辑**：Coze (字节跳动扣子) Workflow
* **核心能力**：URL Scheme 正则清洗 -> 阿里云 ASR -> 豆包 LLM 总结 -> 写入 Apple Notes

### 📥 v1.0 立即试用
点击下方链接获取快捷指令 (需安装 iOS Shortcuts 应用)：
[👉 **点击安装 Notey v1.0 (iCloud Link)**](https://www.icloud.com/shortcuts/bde57319deb644a38b5b5462c97243f5)

---

## 🔄 演进对比 (Evolution)

| 维度 | v1.0 (Shortcuts 脚本) | v2.0 (Native App) |
| :--- | :--- | :--- |
| **交互形态** | 单向流 (生成即结束) | **双向流 (生成-查看-修改)** |
| **数据存储** | Apple 备忘录 (混杂) | **本地数据库 (独立/有序)** |
| **视觉体验** | 系统原生 UI | **Deep Ocean Glassmorphism** |
| **配置门槛** | 需手动填 API Key | **零配置 (每日免费额度)** |
| **稳定性** | 失败即丢失 | **草稿箱 + 重试机制** |

---

## 📚 开发路线图 (Roadmap)

本项目遵循敏捷开发原则，当前处于 v2.0 核心重构阶段。

👉 **[查看V2.0完整产品需求文档 (PRD)](Notey%20V2.0%20PRD.md)**
👉 **[查看V2.0前端设计代码](./Notey)**

- [x] **v1.0 (MVP)**: 验证“视频转笔记”核心价值，跑通 Coze 工作流。
- [x] **v2.0 设计定义**: 确立深色毛玻璃风格，完成“额度控制”与“读写分离”交互设计。
- [x]**v2.0 基础架构**: 搭建 SwiftUI + SwiftData 框架。
- [ ] **v2.0 核心功能**: 实现 Share Extension 捕获与 Markdown 渲染器。
- [ ] **v2.0 Release**: TestFlight 内测发布。

---

*Created by YJJ121388*
