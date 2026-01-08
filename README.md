# 📝 Notey - 你的 iOS 智能笔记助手

> 一个基于 iOS Shortcuts + Coze Agent 的自动化工作流，旨在利用碎片时间高效整理笔记。

## 📺 项目演示
[![点击观看视频](https://github.com/user-attachments/assets/3c6f2c72-56b8-4a03-8b8b-f727e658b339)](https://www.bilibili.com/video/BV1ZPimBQEJg/)

## 🚀 项目简介
在日常娱乐过程中，我们经常在抖音看到有价值的视频。这一类视频知识量巨大但同时具有不容错过的高价值，但手动整理笔记非常耗时，同时也会打乱自己原本的计划。用户常常在打开笔记软件进行记录和继续刷视频之间纠结，最后这个视频通常会进入收藏夹吃灰。

**Notey** 解决了这个问题：
1. **一键触发**：通过 iOS 分享菜单唤起。
2. **多模态输入**：支持分享形式文本或直接分享视频URL。
3. **云端解析**：利用 Coze 后台解析真实视频地址，突破反爬限制。
4. **AI 智能整理**：自动提取语音逐字稿，并总结为 Markdown 结构化笔记。
5. **自动归档**：最终笔记自动存入 Apple 备忘录。

## 🛠 技术架构
* **前端交互**：iOS Shortcuts (原生快捷指令)
* **后端逻辑**：Coze (字节跳动扣子) Workflow
* **核心能力**：
  * URL Scheme & Regex (正则清洗数据)
  * ASR (语音转文字)
  * LLM (大模型语义理解与总结)

## 📸 工作流截图
<img width="5143" height="880" alt="notey" src="https://github.com/user-attachments/assets/3f56505d-6124-4aac-810c-afa41e2fd04f" />

## 📥 如何安装
如果你想体验这个工作流，请点击下方链接获取快捷指令：
[👉 点击安装 Notey (iCloud Link)](https://www.icloud.com/shortcuts/bde57319deb644a38b5b5462c97243f5)

## 📚 迭代与版本规划 (Iteration & Roadmap)

本项目采用 **MVP (最小可行性产品) -> 快速迭代** 的敏捷开发模式。所有的功能定义、交互细节及版本历史均维护在迭代档案中。

👉 **[点击查看完整迭代档案 (Project Iteration Docs)](docs/Iteration_Plan.md)**

### 当前版本：v1.4 (设计中)
我们正在集中精力实现核心的“捕获与重试”闭环：
- [x] **需求分析**：完成 v1.4 版本功能定义（含失败重试机制）。
- [ ] **UI 原型**：正在绘制列表页与详情页草图。
- [ ] **核心开发**：Share Extension 与 Coze API 对接 (Coming Soon)。

### 历史版本概览
| 版本 | 状态 | 核心里程碑 |
| :--- | :--- | :--- |
| **v1.4** | 🚧 进行中 | 深化用户痛点，完善“失败重试”与“草稿箱”交互逻辑。 |
| **v1.2** | ✅ 已归档 | 确立自定义文件夹与颜色分类系统。 |
| **v1.0** | ✅ 已归档 | 完成 MVP 基础功能定义。 |
---
*Created by YJJ121388*
