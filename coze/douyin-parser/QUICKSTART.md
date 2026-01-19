# 快速开始 - 5 分钟恢复 Notey V1.0 功能

本指南帮助你在 5 分钟内部署 Douyin Parser API 并恢复 Notey V1.0 的视频转笔记功能。

## 🎯 目标

将失效的第三方插件替换为自托管的 yt-dlp 解析服务。

## 📋 前置要求

选择以下任一方式：

### 方式 A: 本地运行（测试用）
- Python 3.9+
- ffmpeg

### 方式 B: Docker 部署（推荐）
- Docker
- Docker Compose

### 方式 C: 云服务部署（生产用）
- Render/Railway/阿里云账号

---

## ⚡ 方式 A: 本地快速测试（2 分钟）

```bash
# 1. 进入目录
cd coze/douyin-parser

# 2. 安装依赖（首次运行）
pip3 install -r requirements.txt

# 3. 启动服务
./start.sh
# 或者
python3 main.py
```

✅ 服务启动在 `http://localhost:8000`

### 测试

```bash
# 健康检查
curl http://localhost:8000/health

# 测试解析（替换为真实视频链接）
curl "http://localhost:8000/extract_audio?url=https://www.douyin.com/video/YOUR_VIDEO_ID"
```

---

## 🐳 方式 B: Docker 部署（3 分钟）

```bash
# 1. 进入目录
cd coze/douyin-parser

# 2. 启动服务
docker-compose up -d

# 3. 查看日志
docker-compose logs -f
```

✅ 服务启动在 `http://localhost:8000`

### 测试

```bash
curl http://localhost:8000/health
```

### 停止服务

```bash
docker-compose down
```

---

## ☁️ 方式 C: Render 云部署（5 分钟）

### 步骤 1: 准备代码

```bash
# 1. 初始化 Git（如果还没有）
git init
git add .
git commit -m "Add douyin parser"

# 2. 推送到 GitHub
git remote add origin YOUR_GITHUB_REPO
git push -u origin main
```

### 步骤 2: 部署到 Render

1. 访问 https://dashboard.render.com/
2. 点击 "New +" → "Web Service"
3. 连接 GitHub 仓库
4. 配置：
   - **Name**: `douyin-parser`
   - **Environment**: `Docker`
   - **Region**: `Singapore`（离中国最近）
   - **Branch**: `main`
   - **Root Directory**: `coze/douyin-parser`（如果不在根目录）

5. 点击 "Create Web Service"

✅ 等待 5-10 分钟部署完成

### 步骤 3: 获取 URL

部署完成后，Render 会提供一个 URL：
```
https://douyin-parser.onrender.com
```

### 测试

```bash
curl https://douyin-parser.onrender.com/health
```

---

## 🔌 集成到 Coze 工作流

### 步骤 1: 创建自定义插件

1. 登录 [Coze 平台](https://www.coze.com/)
2. 进入你的工作流
3. 点击 "插件" → "创建自定义插件"

### 步骤 2: 配置插件

**基本信息**:
- 插件名称: `Douyin Video Parser`
- 描述: `提取抖音/TikTok视频音频直链`

**API 配置**:
```
请求方式: GET
API 地址: https://your-domain.com/extract_audio
超时时间: 30 秒
```

**参数**:
| 参数名 | 类型 | 必填 | 描述 |
|--------|------|------|------|
| url | String | 是 | 视频分享链接 |

**返回值路径**:
- 音频 URL: `data.audio_url`
- 视频标题: `data.metadata.title`
- 作者: `data.metadata.author`

### 步骤 3: 更新工作流

1. 找到原来的视频解析节点（失效的第三方插件）
2. 删除或禁用它
3. 添加你的新插件节点
4. 连接输入输出：
   ```
   输入: {{video_url}}
   输出: {{parser_result.data.audio_url}}
   ```

### 步骤 4: 测试

1. 使用真实的抖音视频链接测试
2. 检查是否成功提取音频 URL
3. 验证后续的 ASR 和总结流程是否正常

---

## 🎉 完成！

现在你的 Notey V1.0 应该可以正常工作了！

### 工作流程

```
用户分享抖音视频
    ↓
iOS Shortcuts 提取 URL
    ↓
Coze 工作流
    ↓
你的 Douyin Parser API ✨ (新)
    ↓
获取音频直链
    ↓
阿里云 ASR 转文字
    ↓
Coze LLM 总结
    ↓
Markdown 笔记
    ↓
Apple 备忘录
```

---

## 🔧 常见问题

### Q1: 解析失败怎么办？

**A**: 
1. 检查视频链接是否有效
2. 更新 yt-dlp: `pip install --upgrade yt-dlp`
3. 配置代理（如遇 IP 风控）

### Q2: Render 免费版会休眠？

**A**: 
- 是的，15 分钟无请求会休眠
- 首次唤醒需要 30-60 秒
- 生产环境建议升级到 Starter ($7/月)

### Q3: 如何配置代理？

**A**: 
在环境变量中添加：
```bash
PROXY_URL=http://your-proxy:8080
```

### Q4: 支持哪些平台？

**A**: 
- ✅ 抖音 (douyin.com)
- ✅ TikTok (tiktok.com)
- ✅ B站 (bilibili.com)
- ✅ 小红书 (xiaohongshu.com)
- ✅ 更多平台（yt-dlp 支持 1000+ 网站）

---

## 📚 更多资源

- [详细文档](README.md)
- [部署指南](DEPLOYMENT.md)
- [Coze 插件配置](coze-plugin-config.json)
- [API 测试脚本](test_api.sh)

---

## 🆘 需要帮助？

1. 查看 [README.md](README.md) 详细文档
2. 查看 [DEPLOYMENT.md](DEPLOYMENT.md) 部署指南
3. 检查日志: `docker-compose logs -f`
4. 提交 Issue 到项目仓库

---

**祝你使用愉快！让 Notey 重新工作起来！** 🚀
