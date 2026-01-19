# 🚀 Coze 工作流相关文件

本目录包含 Notey V1.0 Coze 工作流的相关配置和中间件服务。

## ✅ 项目状态

**状态**: ✅ 开发完成，可投入使用  
**完成时间**: 2026-01-19  
**目的**: 替代失效的第三方插件，恢复 Notey V1.0 视频转笔记功能

## 目录结构

```
coze/
├── README.md                    # 本文件
├── gemini's plan.md            # 原始技术方案文档
└── douyin-parser/              # 抖音视频解析中间件
    ├── main.py                 # FastAPI 应用主文件
    ├── requirements.txt        # Python 依赖
    ├── Dockerfile              # Docker 镜像配置
    ├── docker-compose.yml      # Docker Compose 配置
    ├── .env.example            # 环境变量示例
    ├── .gitignore              # Git 忽略文件
    ├── test_api.sh             # API 测试脚本
    ├── README.md               # 详细使用文档
    └── DEPLOYMENT.md           # 部署指南
```

## 快速开始

### 问题背景

Notey V1.0 的 Coze 工作流依赖第三方插件来解析抖音视频链接。由于第三方插件失效，导致整个工作流无法使用。

### 解决方案

我们构建了一个基于 **yt-dlp** 的自托管解析服务，作为 Coze 工作流的中间件，替代失效的第三方插件。

### 核心功能

- ✅ 提取抖音/TikTok 视频音频直链
- ✅ 支持多平台（抖音、TikTok、B站等）
- ✅ 获取视频元数据（标题、作者、时长）
- ✅ 代理支持（应对 IP 风控）
- ✅ Docker 容器化部署

## 使用步骤

### 1. 本地测试（5 分钟）

```bash
# 进入项目目录
cd coze/douyin-parser

# 安装依赖
pip3 install -r requirements.txt

# 启动服务
python3 main.py
```

服务启动后，访问 http://localhost:8000 查看 API 文档。

### 2. Docker 部署（推荐）

```bash
# 进入项目目录
cd coze/douyin-parser

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f
```

### 3. 测试 API

```bash
# 健康检查
curl http://localhost:8000/health

# 提取视频音频（替换为真实视频链接）
curl "http://localhost:8000/extract_audio?url=https://www.douyin.com/video/7596656920576970025"
```

### 4. 部署到云服务

选择以下任一平台部署：

- **Render**: 免费套餐，适合测试（[部署指南](douyin-parser/DEPLOYMENT.md#render-部署)）
- **Railway**: 简单快速，按量计费（[部署指南](douyin-parser/DEPLOYMENT.md#railway-部署)）
- **阿里云 ECS**: 完全控制，适合生产（[部署指南](douyin-parser/DEPLOYMENT.md#阿里云-ecs-部署)）

### 5. 集成到 Coze 工作流

1. 在 Coze 平台创建自定义插件
2. 配置 API 端点: `https://your-domain.com/extract_audio`
3. 在工作流中替换原有的视频解析节点
4. 测试完整流程

详细步骤请查看 [DEPLOYMENT.md](douyin-parser/DEPLOYMENT.md#coze-集成配置)

## API 文档

### 提取音频直链

**端点**: `GET /extract_audio`

**参数**:
- `url` (必填): 视频分享链接

**示例**:
```bash
curl "http://localhost:8000/extract_audio?url=https://www.douyin.com/video/7596656920576970025"
```

**响应**:
```json
{
  "status": "success",
  "data": {
    "audio_url": "https://v3-dy-d.zjcdn.com/...",
    "original_url": "https://www.douyin.com/video/7596656920576970025",
    "metadata": {
      "title": "视频标题",
      "author": "作者名",
      "duration": 120
    }
  }
}
```

## 工作流架构

```
用户分享视频
    ↓
iOS Shortcuts 提取 URL
    ↓
Coze 工作流接收
    ↓
调用自定义插件 (Douyin Parser API)
    ↓
获取音频直链
    ↓
阿里云 ASR 语音转文字
    ↓
Coze LLM 总结
    ↓
返回 Markdown 笔记
    ↓
保存到 Apple 备忘录
```

## 技术栈

- **语言**: Python 3.11
- **框架**: FastAPI
- **核心工具**: yt-dlp
- **部署**: Docker + Docker Compose
- **依赖**: ffmpeg

## 维护建议

1. **定期更新 yt-dlp**: 平台反爬机制会变化
   ```bash
   pip install --upgrade yt-dlp
   ```

2. **监控日志**: 关注解析失败率

3. **配置代理**: 如遇 IP 风控，配置代理服务器

4. **备用方案**: 考虑集成商用 API 作为备用

## 故障排查

### 问题 1: 解析失败

**原因**: 
- 视频链接无效
- 平台更新反爬机制
- 网络问题

**解决**:
1. 更新 yt-dlp
2. 配置代理
3. 检查视频链接

### 问题 2: 服务无法启动

**解决**:
```bash
# 检查端口占用
lsof -i :8000

# 查看日志
docker-compose logs

# 重新构建
docker-compose build --no-cache
```

### 问题 3: 响应慢

**解决**:
- 增加 TIMEOUT 环境变量
- 使用代理
- 升级服务器配置

## 相关文档

- [详细使用文档](douyin-parser/README.md)
- [部署指南](douyin-parser/DEPLOYMENT.md)
- [原始技术方案](gemini's%20plan.md)

## 下一步

1. ✅ 本地测试服务
2. ✅ 部署到云平台
3. ✅ 在 Coze 创建自定义插件
4. ✅ 更新工作流配置
5. ✅ 测试完整流程
6. 📊 监控运行状态

## 支持

如有问题，请查看：
1. [README.md](douyin-parser/README.md) - 详细使用说明
2. [DEPLOYMENT.md](douyin-parser/DEPLOYMENT.md) - 部署指南
3. 提交 Issue 到项目仓库

---

**Created for Notey V1.0 - 让视频转笔记重新工作起来！** 🚀
