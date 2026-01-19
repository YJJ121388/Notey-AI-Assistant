# Douyin Parser API - 抖音视频解析中间件

基于 yt-dlp 的轻量级视频解析服务，用于提取抖音/TikTok 视频的音频直链。

## 功能特性

- ✅ 提取视频音频直链（无需下载完整视频）
- ✅ 支持抖音、TikTok、B站等多平台
- ✅ 获取视频元数据（标题、作者、时长）
- ✅ 代理支持（应对 IP 风控）
- ✅ 超时控制和错误处理
- ✅ Docker 容器化部署
- ✅ 健康检查端点

## 快速开始

### 方式 1: 本地运行

#### 前置要求
- Python 3.9+
- ffmpeg

#### 安装依赖
```bash
cd coze/douyin-parser
pip install -r requirements.txt
```

#### 启动服务
```bash
python main.py
```

服务将在 `http://localhost:8000` 启动。

### 方式 2: Docker 部署（推荐）

#### 构建并启动
```bash
cd coze/douyin-parser
docker-compose up -d
```

#### 查看日志
```bash
docker-compose logs -f
```

#### 停止服务
```bash
docker-compose down
```

## API 文档

### 1. 提取音频直链

**端点**: `GET /extract_audio`

**参数**:
- `url` (必填): 视频分享链接

**示例请求**:
```bash
curl "http://localhost:8000/extract_audio?url=https://www.douyin.com/video/7596656920576970025"
```

**成功响应** (200):
```json
{
  "status": "success",
  "data": {
    "audio_url": "https://v3-dy-d.zjcdn.com/...",
    "original_url": "https://www.douyin.com/video/7596656920576970025",
    "metadata": {
      "title": "视频标题",
      "author": "作者名",
      "duration": 120,
      "description": "视频描述"
    }
  }
}
```

**错误响应**:
- `400`: 不支持的 URL 格式
- `500`: 解析失败
- `503`: 网络错误
- `504`: 解析超时

### 2. 健康检查

**端点**: `GET /health`

**示例请求**:
```bash
curl http://localhost:8000/health
```

**响应**:
```json
{
  "status": "healthy",
  "yt_dlp_version": "2024.12.23"
}
```

### 3. 服务信息

**端点**: `GET /`

**响应**:
```json
{
  "status": "ok",
  "service": "Douyin Parser API",
  "version": "1.0.0"
}
```

## 配置说明

### 环境变量

创建 `.env` 文件（参考 `.env.example`）：

```bash
# 服务配置
HOST=0.0.0.0
PORT=8000

# 超时设置（秒）
TIMEOUT=30

# 代理配置（可选）
PROXY_URL=http://proxy.example.com:8080
```

### 代理配置

如果遇到 IP 风控，可以配置代理：

```bash
# HTTP 代理
PROXY_URL=http://proxy.example.com:8080

# SOCKS5 代理
PROXY_URL=socks5://proxy.example.com:1080
```

## 部署到云服务

### Render 部署

1. 在 Render 创建新的 Web Service
2. 连接 GitHub 仓库
3. 配置构建命令：
   ```bash
   pip install -r requirements.txt
   ```
4. 配置启动命令：
   ```bash
   python main.py
   ```
5. 添加环境变量（如需要）

### Railway 部署

1. 在 Railway 创建新项目
2. 连接 GitHub 仓库
3. Railway 会自动检测 Dockerfile 并部署
4. 在设置中添加环境变量（如需要）

## 集成到 Coze

### 1. 创建自定义插件

在 Coze 平台创建自定义插件，配置如下：

**插件名称**: Douyin Parser

**API 端点**: `https://your-domain.com/extract_audio`

**请求方法**: GET

**参数配置**:
- 参数名: `url`
- 类型: String
- 必填: 是
- 描述: 视频分享链接

### 2. 在工作流中使用

替换原有的 `get_douyin_video_url` 节点为新的自定义插件节点。

**输入**: 视频分享链接
**输出**: `data.audio_url` - 音频直链

## 测试

### 测试抖音视频
```bash
curl "http://localhost:8000/extract_audio?url=https://www.douyin.com/video/7596656920576970025"
```

### 测试 TikTok 视频
```bash
curl "http://localhost:8000/extract_audio?url=https://www.tiktok.com/@username/video/1234567890"
```

### 测试 B站视频
```bash
curl "http://localhost:8000/extract_audio?url=https://www.bilibili.com/video/BV1xx411c7XZ"
```

## 故障排查

### 问题 1: yt-dlp 解析失败

**可能原因**:
- 视频链接无效或已删除
- 平台更新了反爬机制
- 网络连接问题

**解决方案**:
1. 更新 yt-dlp: `pip install --upgrade yt-dlp`
2. 配置代理
3. 检查视频链接是否有效

### 问题 2: 解析超时

**解决方案**:
- 增加 `TIMEOUT` 环境变量的值
- 检查网络连接
- 使用代理

### 问题 3: Docker 容器无法启动

**解决方案**:
1. 检查端口是否被占用: `lsof -i :8000`
2. 查看容器日志: `docker-compose logs`
3. 重新构建镜像: `docker-compose build --no-cache`

## 性能优化

- 使用 `-g` 参数只获取 URL，避免下载完整视频
- 设置合理的超时时间（默认 30 秒）
- 使用代理池轮换 IP（如需要）
- 部署多个实例实现负载均衡

## 维护建议

1. **定期更新 yt-dlp**: 平台反爬机制会变化，需要及时更新
   ```bash
   pip install --upgrade yt-dlp
   ```

2. **监控日志**: 关注解析失败率，及时发现问题

3. **备用方案**: 如果 yt-dlp 失败，可以考虑集成商用 API

## 许可证

MIT License

## 作者

Created for Notey V2.0 Project
