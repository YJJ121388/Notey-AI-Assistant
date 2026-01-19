# 部署指南 - Douyin Parser API

本文档提供详细的部署步骤，帮助你快速将服务部署到生产环境。

## 目录

1. [本地开发环境](#本地开发环境)
2. [Docker 本地部署](#docker-本地部署)
3. [云服务部署](#云服务部署)
   - [Render 部署](#render-部署)
   - [Railway 部署](#railway-部署)
   - [阿里云 ECS 部署](#阿里云-ecs-部署)
4. [Coze 集成配置](#coze-集成配置)
5. [监控和维护](#监控和维护)

---

## 本地开发环境

### 1. 安装依赖

#### macOS
```bash
# 安装 Python 3.9+
brew install python@3.11

# 安装 ffmpeg
brew install ffmpeg

# 安装 Python 依赖
cd coze/douyin-parser
pip3 install -r requirements.txt
```

#### Ubuntu/Debian
```bash
# 安装 Python 3.9+
sudo apt update
sudo apt install python3.11 python3-pip

# 安装 ffmpeg
sudo apt install ffmpeg

# 安装 Python 依赖
cd coze/douyin-parser
pip3 install -r requirements.txt
```

### 2. 启动服务

```bash
python3 main.py
```

服务将在 `http://localhost:8000` 启动。

### 3. 测试

```bash
# 赋予测试脚本执行权限
chmod +x test_api.sh

# 运行测试
./test_api.sh
```

---

## Docker 本地部署

### 1. 安装 Docker

#### macOS
```bash
# 下载并安装 Docker Desktop
# https://www.docker.com/products/docker-desktop
```

#### Ubuntu
```bash
# 安装 Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装 Docker Compose
sudo apt install docker-compose
```

### 2. 构建并启动

```bash
cd coze/douyin-parser

# 构建镜像
docker-compose build

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f
```

### 3. 验证服务

```bash
# 健康检查
curl http://localhost:8000/health

# 测试解析
curl "http://localhost:8000/extract_audio?url=YOUR_VIDEO_URL"
```

### 4. 停止服务

```bash
docker-compose down
```

---

## 云服务部署

### Render 部署

Render 提供免费的 Web Service 托管，适合快速部署。

#### 步骤 1: 准备代码

1. 将 `coze/douyin-parser` 目录推送到 GitHub 仓库
2. 确保 `Dockerfile` 和 `requirements.txt` 在根目录

#### 步骤 2: 创建 Render 服务

1. 访问 [Render Dashboard](https://dashboard.render.com/)
2. 点击 "New +" → "Web Service"
3. 连接 GitHub 仓库
4. 配置服务：
   - **Name**: `douyin-parser`
   - **Environment**: `Docker`
   - **Region**: 选择离中国最近的区域（Singapore）
   - **Instance Type**: Free（测试）或 Starter（生产）

#### 步骤 3: 配置环境变量（可选）

在 "Environment" 标签页添加：
```
TIMEOUT=30
PROXY_URL=http://your-proxy:8080  # 如需代理
```

#### 步骤 4: 部署

1. 点击 "Create Web Service"
2. 等待部署完成（约 5-10 分钟）
3. 获取服务 URL: `https://douyin-parser.onrender.com`

#### 步骤 5: 测试

```bash
curl https://douyin-parser.onrender.com/health
```

#### 注意事项

- **免费套餐限制**: 
  - 15 分钟无请求后会休眠
  - 首次唤醒需要 30-60 秒
  - 每月 750 小时免费运行时间
  
- **生产环境建议**: 使用 Starter 套餐（$7/月）避免休眠

---

### Railway 部署

Railway 提供简单的部署体验，支持自动检测 Dockerfile。

#### 步骤 1: 创建项目

1. 访问 [Railway](https://railway.app/)
2. 点击 "New Project"
3. 选择 "Deploy from GitHub repo"
4. 选择你的仓库和 `coze/douyin-parser` 目录

#### 步骤 2: 配置

Railway 会自动检测 Dockerfile 并开始构建。

#### 步骤 3: 添加环境变量（可选）

在 "Variables" 标签页添加：
```
PORT=8000
TIMEOUT=30
PROXY_URL=http://your-proxy:8080  # 如需代理
```

#### 步骤 4: 获取域名

1. 在 "Settings" 标签页
2. 点击 "Generate Domain"
3. 获取 URL: `https://your-app.railway.app`

#### 步骤 5: 测试

```bash
curl https://your-app.railway.app/health
```

#### 定价

- 免费套餐: $5 免费额度/月
- 按使用量计费: 约 $0.000463/分钟

---

### 阿里云 ECS 部署

适合需要完全控制和稳定性的生产环境。

#### 步骤 1: 购买 ECS 实例

1. 访问 [阿里云 ECS 控制台](https://ecs.console.aliyun.com/)
2. 创建实例：
   - **地域**: 选择离用户最近的区域
   - **实例规格**: ecs.t6-c1m1.large（1核2GB，适合测试）
   - **镜像**: Ubuntu 22.04
   - **网络**: 分配公网 IP
   - **安全组**: 开放 8000 端口

#### 步骤 2: 连接服务器

```bash
ssh root@YOUR_SERVER_IP
```

#### 步骤 3: 安装 Docker

```bash
# 更新系统
apt update && apt upgrade -y

# 安装 Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# 安装 Docker Compose
apt install docker-compose -y

# 验证安装
docker --version
docker-compose --version
```

#### 步骤 4: 部署应用

```bash
# 创建应用目录
mkdir -p /opt/douyin-parser
cd /opt/douyin-parser

# 上传代码（使用 scp 或 git clone）
# 方式 1: 使用 git
git clone YOUR_REPO_URL .

# 方式 2: 使用 scp（从本地上传）
# scp -r coze/douyin-parser/* root@YOUR_SERVER_IP:/opt/douyin-parser/

# 创建 .env 文件
cat > .env << EOF
HOST=0.0.0.0
PORT=8000
TIMEOUT=30
EOF

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f
```

#### 步骤 5: 配置 Nginx 反向代理（可选）

```bash
# 安装 Nginx
apt install nginx -y

# 创建配置文件
cat > /etc/nginx/sites-available/douyin-parser << EOF
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF

# 启用配置
ln -s /etc/nginx/sites-available/douyin-parser /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

#### 步骤 6: 配置 HTTPS（推荐）

```bash
# 安装 Certbot
apt install certbot python3-certbot-nginx -y

# 申请证书
certbot --nginx -d your-domain.com

# 自动续期
certbot renew --dry-run
```

#### 步骤 7: 配置开机自启

```bash
# 创建 systemd 服务
cat > /etc/systemd/system/douyin-parser.service << EOF
[Unit]
Description=Douyin Parser API
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/douyin-parser
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down

[Install]
WantedBy=multi-user.target
EOF

# 启用服务
systemctl enable douyin-parser
systemctl start douyin-parser
```

---

## Coze 集成配置

### 步骤 1: 创建自定义插件

1. 登录 [Coze 平台](https://www.coze.com/)
2. 进入你的工作流
3. 点击 "插件" → "创建自定义插件"

### 步骤 2: 配置插件

**基本信息**:
- **插件名称**: Douyin Video Parser
- **描述**: 提取抖音/TikTok 视频音频直链
- **图标**: 上传一个图标（可选）

**API 配置**:
- **请求方式**: GET
- **API 地址**: `https://your-domain.com/extract_audio`
- **超时时间**: 30 秒

**参数配置**:

| 参数名 | 类型 | 必填 | 描述 |
|--------|------|------|------|
| url | String | 是 | 视频分享链接 |

**返回值配置**:

```json
{
  "status": "success",
  "data": {
    "audio_url": "string",
    "original_url": "string",
    "metadata": {
      "title": "string",
      "author": "string",
      "duration": "number"
    }
  }
}
```

### 步骤 3: 在工作流中使用

1. 在工作流中添加你的自定义插件节点
2. 连接输入（视频 URL）
3. 使用输出 `data.audio_url` 作为音频直链
4. 传递给后续的 ASR 和 LLM 节点

### 步骤 4: 测试工作流

1. 使用真实的抖音视频链接测试
2. 检查是否成功提取音频 URL
3. 验证后续的 ASR 和总结流程

---

## 监控和维护

### 日志查看

#### Docker 部署
```bash
# 查看实时日志
docker-compose logs -f

# 查看最近 100 行
docker-compose logs --tail=100

# 查看特定时间段
docker-compose logs --since 2024-01-01T00:00:00
```

#### 系统服务
```bash
# 查看服务状态
systemctl status douyin-parser

# 查看日志
journalctl -u douyin-parser -f
```

### 性能监控

#### 使用 htop 监控资源
```bash
apt install htop
htop
```

#### 监控 Docker 容器
```bash
# 查看容器资源使用
docker stats

# 查看容器详情
docker inspect douyin-parser
```

### 更新 yt-dlp

yt-dlp 需要定期更新以应对平台反爬机制变化。

```bash
# 进入容器
docker exec -it douyin-parser bash

# 更新 yt-dlp
pip install --upgrade yt-dlp

# 退出容器
exit

# 重启服务
docker-compose restart
```

### 备份和恢复

```bash
# 备份配置
tar -czf douyin-parser-backup.tar.gz /opt/douyin-parser

# 恢复
tar -xzf douyin-parser-backup.tar.gz -C /
```

### 故障排查

#### 问题 1: 服务无法启动

```bash
# 检查端口占用
lsof -i :8000

# 检查 Docker 日志
docker-compose logs

# 重新构建
docker-compose build --no-cache
docker-compose up -d
```

#### 问题 2: 解析失败率高

1. 检查 yt-dlp 版本是否最新
2. 尝试配置代理
3. 查看错误日志分析原因

#### 问题 3: 响应慢

1. 增加服务器资源
2. 优化超时设置
3. 使用 CDN 加速

---

## 安全建议

1. **使用 HTTPS**: 保护 API 通信安全
2. **添加认证**: 使用 API Key 或 JWT 认证
3. **限流**: 防止滥用和 DDoS 攻击
4. **日志脱敏**: 不记录敏感信息
5. **定期更新**: 及时更新依赖和系统补丁

---

## 成本估算

### Render (推荐用于测试)
- 免费套餐: $0/月（有休眠限制）
- Starter: $7/月（无休眠）

### Railway
- 免费额度: $5/月
- 按量计费: 约 $20-30/月（中等使用量）

### 阿里云 ECS
- 1核2GB: ¥60-80/月
- 2核4GB: ¥120-150/月
- 带宽: ¥0.8/GB（按流量）

---

## 下一步

1. ✅ 完成部署
2. ✅ 集成到 Coze 工作流
3. ✅ 测试完整流程
4. 📊 监控运行状态
5. 🔄 定期维护更新

如有问题，请查看 [README.md](README.md) 或提交 Issue。
