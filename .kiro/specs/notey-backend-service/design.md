# Notey 后端服务设计文档

## 1. 系统架构设计

### 1.1 整体架构

```
┌─────────────────────────────────────────────────────────────┐
│                    iOS App (SwiftUI)                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ Share Ext    │  │ Main App     │  │ AI Assistant │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
└─────────┼──────────────────┼──────────────────┼────────────┘
          │                  │                  │
          │ HTTPS            │ HTTPS            │ HTTPS
          ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────┐
│              Notey Backend Service (Node.js)                │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  API Gateway (Express/Fastify)                       │  │
│  │    ├── Rate Limiter                                  │  │
│  │    ├── Auth Middleware                               │  │
│  │    └── Request Logger                                │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Video Service│  │ Quota Service│  │ AI Service   │    │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘    │
└─────────┼──────────────────┼──────────────────┼────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────┐
│                   External Services                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Video APIs   │  │ Redis/DB     │  │ Coze API     │    │
│  │ (抖音/B站)    │  │ (额度存储)    │  │ (LLM)        │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
│  ┌──────────────┐  ┌──────────────┐                      │
│  │ 阿里云 ASR    │  │ Search API   │                      │
│  │ (语音转文字)  │  │ (Serper)     │                      │
│  └──────────────┘  └──────────────┘                      │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 技术栈选型

**后端框架**：Node.js + Express/Fastify
- 理由：轻量级、生态丰富、适合 I/O 密集型任务

**数据库**：
- Redis：用户额度缓存、会话管理
- SQLite/PostgreSQL：用户数据持久化（可选）

**部署方式**：
- Docker 容器化
- 阿里云 ECS 或 Serverless（函数计算）



---

## 2. 核心模块设计

### 2.1 Video Service（视频处理服务）

**职责**：
- 解析视频分享链接
- 提取视频元数据和音频流
- 调用 ASR 服务进行语音转文字
- 调用 LLM 进行内容总结

**接口设计**：

```typescript
interface VideoService {
  // 处理视频链接
  processVideo(url: string, userId: string): Promise<ProcessResult>
  
  // 解析视频 URL
  parseVideoUrl(url: string): Promise<VideoMetadata>
  
  // 提取音频
  extractAudio(videoUrl: string): Promise<AudioStream>
  
  // 语音转文字
  transcribeAudio(audioStream: AudioStream): Promise<string>
  
  // AI 总结
  summarizeContent(transcript: string, metadata: VideoMetadata): Promise<string>
}

interface VideoMetadata {
  platform: 'douyin' | 'bilibili' | 'xiaohongshu' | 'tiktok'
  videoId: string
  title: string
  author: string
  duration: number
  thumbnailUrl?: string
}

interface ProcessResult {
  success: boolean
  markdown?: string
  error?: {
    code: string
    message: string
    retryable: boolean
  }
  metadata: VideoMetadata
}
```

**处理流程**：

```
1. 接收分享链接
   ↓
2. 识别平台类型（正则匹配）
   ↓
3. 调用平台特定解析器
   ↓
4. 获取视频真实地址和元数据
   ↓
5. 检查视频时长（> 10分钟则返回错误）
   ↓
6. 提取音频流
   ↓
7. 调用阿里云 ASR（语音转文字）
   ↓
8. 调用 Coze API（内容总结）
   ↓
9. 格式化为 Markdown
   ↓
10. 返回结果
```

**错误处理**：
- `VIDEO_TOO_LONG`: 视频超过 10 分钟
- `PLATFORM_NOT_SUPPORTED`: 不支持的平台
- `PARSE_FAILED`: URL 解析失败
- `ASR_FAILED`: 语音转文字失败
- `LLM_FAILED`: AI 总结失败
- `NETWORK_ERROR`: 网络请求失败



---

### 2.2 Quota Service（额度管理服务）

**职责**：
- 验证用户额度
- 记录额度消耗
- 每日自动重置额度
- 提供额度查询接口

**接口设计**：

```typescript
interface QuotaService {
  // 检查额度
  checkQuota(userId: string, quotaType: QuotaType): Promise<QuotaStatus>
  
  // 消耗额度
  consumeQuota(userId: string, quotaType: QuotaType): Promise<boolean>
  
  // 查询额度
  getQuota(userId: string): Promise<QuotaInfo>
  
  // 重置额度（定时任务）
  resetDailyQuota(): Promise<void>
}

enum QuotaType {
  VIDEO_PROCESS = 'video_process',  // 视频转笔记
  AI_ASSISTANT = 'ai_assistant'     // AI 助手
}

interface QuotaStatus {
  allowed: boolean
  remaining: number
  total: number
  resetAt: Date
}

interface QuotaInfo {
  videoProcess: {
    used: number
    total: number
    remaining: number
  }
  aiAssistant: {
    used: number
    total: number
    remaining: number
  }
  resetAt: Date
}
```

**数据存储设计（Redis）**：

```
Key 格式：quota:{userId}:{quotaType}:{date}
Value：已使用次数（整数）
TTL：24 小时（自动过期）

示例：
quota:device123:video_process:2026-01-18 = 3
quota:device123:ai_assistant:2026-01-18 = 1
```

**额度配置**：

```typescript
const QUOTA_CONFIG = {
  video_process: {
    daily_limit: 5,
    reset_hour: 0  // 凌晨 0 点重置
  },
  ai_assistant: {
    daily_limit: 3,
    reset_hour: 0
  }
}
```

**重置机制**：
- 使用 Redis TTL 自动过期（24 小时）
- 定时任务每日 00:00 清理过期 key（双保险）
- 支持用户时区（客户端传递时区信息）



---

### 2.3 AI Service（AI 助手服务 - V3.0）

**职责**：
- 分析笔记内容提取主题
- 联网搜索相关内容
- 格式化搜索结果
- 内容去重和质量筛选

**接口设计**：

```typescript
interface AIService {
  // 笔记内容拓展
  expandNote(content: string, userId: string): Promise<ExpansionResult>
  
  // 提取主题
  extractTopics(content: string): Promise<Topic[]>
  
  // 联网搜索
  searchContent(topics: Topic[]): Promise<SearchResult[]>
  
  // 格式化结果
  formatResults(results: SearchResult[], originalStyle: string): Promise<Recommendation[]>
}

interface Topic {
  keyword: string
  category: string  // 'travel' | 'tech' | 'food' | 'education' | 'other'
  weight: number    // 重要性权重
}

interface SearchResult {
  title: string
  snippet: string
  url: string
  source: string    // 'zhihu' | 'xiaohongshu' | 'bilibili'
  popularity: number // 热度分数
}

interface Recommendation {
  id: string
  title: string
  description: string
  icon: string
  source: string
  selected: boolean  // 默认 false，由用户选择
}

interface ExpansionResult {
  success: boolean
  recommendations: Recommendation[]
  error?: {
    code: string
    message: string
  }
}
```

**处理流程**：

```
1. 接收笔记 Markdown 内容
   ↓
2. 调用 LLM 提取核心主题（3-5 个关键词）
   ↓
3. 构建搜索查询
   - 添加限定词："高赞"、"必看"、"推荐"
   - 指定来源：site:zhihu.com / site:xiaohongshu.com
   ↓
4. 调用搜索 API（Serper/Bing）
   ↓
5. 过滤低质量结果
   - 检查热度指标（点赞数、浏览量）
   - 过滤广告和营销内容
   ↓
6. 调用 LLM 格式化结果
   - 匹配原笔记风格
   - 生成简洁描述
   - 添加 emoji 图标
   ↓
7. 去重检查（与原笔记内容对比）
   ↓
8. 返回推荐列表（5-10 条）
```

**搜索策略**：

```typescript
// 根据笔记类型构建不同的搜索查询
const SEARCH_STRATEGIES = {
  travel: {
    keywords: ['攻略', '必去', '避雷', '推荐'],
    sources: ['xiaohongshu.com', 'mafengwo.com'],
    filters: ['高赞', '精华']
  },
  tech: {
    keywords: ['教程', '最佳实践', '详解'],
    sources: ['zhihu.com', 'juejin.cn'],
    filters: ['高赞', '收藏']
  },
  food: {
    keywords: ['推荐', '必吃', '排行'],
    sources: ['xiaohongshu.com', 'dianping.com'],
    filters: ['热门', '好评']
  }
}
```



---

## 3. API 接口设计

### 3.1 V2.0 核心 API

#### 3.1.1 POST /api/v2/process-video

**功能**：处理视频链接，生成 Markdown 笔记

**请求**：
```json
{
  "url": "https://v.douyin.com/xxx",
  "userId": "device_abc123",
  "timezone": "Asia/Shanghai"
}
```

**响应（成功）**：
```json
{
  "success": true,
  "data": {
    "markdown": "# 视频标题\n\n## 核心要点\n...",
    "metadata": {
      "platform": "douyin",
      "title": "视频标题",
      "author": "作者名",
      "duration": 180,
      "thumbnailUrl": "https://..."
    }
  },
  "quota": {
    "remaining": 4,
    "total": 5,
    "resetAt": "2026-01-19T00:00:00Z"
  }
}
```

**响应（失败 - 额度耗尽）**：
```json
{
  "success": false,
  "error": {
    "code": "QUOTA_EXCEEDED",
    "message": "今日 AI 额度已用完，请明天再来探索",
    "retryable": false
  },
  "quota": {
    "remaining": 0,
    "total": 5,
    "resetAt": "2026-01-19T00:00:00Z"
  }
}
```

**响应（失败 - 视频过长）**：
```json
{
  "success": false,
  "error": {
    "code": "VIDEO_TOO_LONG",
    "message": "视频时长超过 10 分钟，暂不支持",
    "retryable": false
  },
  "metadata": {
    "platform": "douyin",
    "title": "视频标题",
    "duration": 720,
    "url": "https://v.douyin.com/xxx"
  }
}
```

**响应（失败 - 可重试）**：
```json
{
  "success": false,
  "error": {
    "code": "ASR_FAILED",
    "message": "语音识别服务暂时不可用，请稍后重试",
    "retryable": true
  },
  "metadata": {
    "platform": "douyin",
    "title": "视频标题",
    "url": "https://v.douyin.com/xxx"
  }
}
```

**状态码**：
- `200`: 处理成功
- `400`: 请求参数错误
- `429`: 额度耗尽
- `500`: 服务器错误
- `503`: 第三方服务不可用



#### 3.1.2 GET /api/v2/quota

**功能**：查询用户剩余额度

**请求参数**：
```
GET /api/v2/quota?userId=device_abc123&timezone=Asia/Shanghai
```

**响应**：
```json
{
  "success": true,
  "data": {
    "videoProcess": {
      "used": 3,
      "total": 5,
      "remaining": 2
    },
    "resetAt": "2026-01-19T00:00:00Z"
  }
}
```

#### 3.1.3 POST /api/v2/retry-draft

**功能**：重试失败的草稿

**请求**：
```json
{
  "url": "https://v.douyin.com/xxx",
  "userId": "device_abc123",
  "timezone": "Asia/Shanghai"
}
```

**响应**：与 `/api/v2/process-video` 相同

---

### 3.2 V3.0 AI 助手 API

#### 3.2.1 POST /api/v3/expand-note

**功能**：基于笔记内容提供拓展推荐

**请求**：
```json
{
  "content": "# 厦门旅游攻略\n\n🏝️ 鼓浪屿...",
  "userId": "device_abc123",
  "timezone": "Asia/Shanghai"
}
```

**响应（成功）**：
```json
{
  "success": true,
  "data": {
    "recommendations": [
      {
        "id": "rec_1",
        "title": "沙坡尾",
        "description": "厦门最文艺的老街区，咖啡馆和涂鸦墙的天堂",
        "icon": "🌊",
        "source": "小红书高赞",
        "selected": false
      },
      {
        "id": "rec_2",
        "title": "环岛路",
        "description": "骑行看海的最佳路线，全长约 31 公里",
        "icon": "🚴",
        "source": "知乎推荐",
        "selected": false
      }
    ]
  },
  "quota": {
    "remaining": 2,
    "total": 3,
    "resetAt": "2026-01-19T00:00:00Z"
  }
}
```

**响应（失败 - 无相关内容）**：
```json
{
  "success": true,
  "data": {
    "recommendations": []
  },
  "message": "暂未找到更多相关推荐"
}
```

#### 3.2.2 GET /api/v3/assistant-quota

**功能**：查询 AI 助手额度

**请求参数**：
```
GET /api/v3/assistant-quota?userId=device_abc123&timezone=Asia/Shanghai
```

**响应**：
```json
{
  "success": true,
  "data": {
    "aiAssistant": {
      "used": 1,
      "total": 3,
      "remaining": 2
    },
    "resetAt": "2026-01-19T00:00:00Z"
  }
}
```



---

## 4. 数据模型设计

### 4.1 用户额度记录（Redis）

```typescript
// Key 格式
const quotaKey = `quota:${userId}:${quotaType}:${date}`

// 示例
quota:device_abc123:video_process:2026-01-18 = 3
quota:device_abc123:ai_assistant:2026-01-18 = 1

// TTL: 24 小时自动过期
```

### 4.2 请求日志（可选 - 数据库）

```sql
CREATE TABLE request_logs (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL,
  request_type VARCHAR(50) NOT NULL,  -- 'video_process' | 'ai_assistant'
  status VARCHAR(20) NOT NULL,        -- 'success' | 'failed'
  error_code VARCHAR(50),
  platform VARCHAR(50),               -- 'douyin' | 'bilibili' | ...
  duration_ms INT,                    -- 处理耗时（毫秒）
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_created_at (created_at)
);
```

### 4.3 用户配置（可选 - 数据库）

```sql
CREATE TABLE user_configs (
  user_id VARCHAR(255) PRIMARY KEY,
  custom_quota_video INT DEFAULT 5,
  custom_quota_ai INT DEFAULT 3,
  timezone VARCHAR(50) DEFAULT 'Asia/Shanghai',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

---

## 5. 安全设计

### 5.1 身份验证

**设备 ID 方案**（推荐用于 MVP）：
- 客户端生成唯一设备 ID（UUID）
- 存储在 iOS Keychain 中
- 每次请求携带在 Header 中：`X-Device-ID: device_abc123`

**Token 方案**（可选，用于后续迭代）：
- 用户注册后获得 JWT Token
- Token 包含用户 ID 和过期时间
- 每次请求携带在 Header 中：`Authorization: Bearer <token>`

### 5.2 速率限制

**全局限制**：
- 每个 IP 每分钟最多 60 次请求
- 使用 `express-rate-limit` 中间件

**用户限制**：
- 每个用户每日额度由 Quota Service 管理
- 超出额度返回 429 状态码

### 5.3 API Key 管理

**环境变量**：
```bash
# Coze API
COZE_API_KEY=your_coze_api_key
COZE_WORKFLOW_ID=your_workflow_id

# 阿里云 ASR
ALIYUN_ACCESS_KEY_ID=your_access_key_id
ALIYUN_ACCESS_KEY_SECRET=your_access_key_secret

# 搜索 API（V3.0）
SERPER_API_KEY=your_serper_api_key

# Redis
REDIS_URL=redis://localhost:6379

# 服务配置
PORT=3000
NODE_ENV=production
```

**配置加载**：
```typescript
import dotenv from 'dotenv'

dotenv.config()

export const config = {
  coze: {
    apiKey: process.env.COZE_API_KEY!,
    workflowId: process.env.COZE_WORKFLOW_ID!
  },
  aliyun: {
    accessKeyId: process.env.ALIYUN_ACCESS_KEY_ID!,
    accessKeySecret: process.env.ALIYUN_ACCESS_KEY_SECRET!
  },
  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379'
  },
  quota: {
    videoProcess: {
      dailyLimit: parseInt(process.env.QUOTA_VIDEO_LIMIT || '5'),
      resetHour: 0
    },
    aiAssistant: {
      dailyLimit: parseInt(process.env.QUOTA_AI_LIMIT || '3'),
      resetHour: 0
    }
  }
}
```



---

## 6. 错误处理与日志

### 6.1 错误码设计

```typescript
enum ErrorCode {
  // 客户端错误 (4xx)
  INVALID_REQUEST = 'INVALID_REQUEST',
  INVALID_URL = 'INVALID_URL',
  QUOTA_EXCEEDED = 'QUOTA_EXCEEDED',
  
  // 视频处理错误
  PLATFORM_NOT_SUPPORTED = 'PLATFORM_NOT_SUPPORTED',
  VIDEO_TOO_LONG = 'VIDEO_TOO_LONG',
  VIDEO_NOT_FOUND = 'VIDEO_NOT_FOUND',
  PARSE_FAILED = 'PARSE_FAILED',
  
  // 第三方服务错误 (5xx)
  ASR_FAILED = 'ASR_FAILED',
  LLM_FAILED = 'LLM_FAILED',
  SEARCH_FAILED = 'SEARCH_FAILED',
  NETWORK_ERROR = 'NETWORK_ERROR',
  
  // 服务器错误
  INTERNAL_ERROR = 'INTERNAL_ERROR',
  SERVICE_UNAVAILABLE = 'SERVICE_UNAVAILABLE'
}

interface ApiError {
  code: ErrorCode
  message: string
  retryable: boolean
  details?: any
}
```

### 6.2 日志设计

**日志级别**：
- `ERROR`: 错误日志（需要立即处理）
- `WARN`: 警告日志（需要关注）
- `INFO`: 信息日志（正常业务流程）
- `DEBUG`: 调试日志（开发环境）

**日志格式**（JSON）：
```json
{
  "timestamp": "2026-01-18T10:30:00.000Z",
  "level": "INFO",
  "requestId": "req_abc123",
  "userId": "device_abc123",
  "action": "process_video",
  "platform": "douyin",
  "duration": 8500,
  "status": "success",
  "message": "Video processed successfully"
}
```

**日志记录点**：
1. 请求开始：记录 userId、action、requestId
2. 关键步骤：视频解析、ASR 调用、LLM 调用
3. 错误发生：记录错误码、错误信息、堆栈
4. 请求结束：记录状态、耗时

**日志工具**：
```typescript
import winston from 'winston'

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
    new winston.transports.File({ filename: 'logs/combined.log' })
  ]
})

export default logger
```



---

## 7. 部署架构

### 7.1 Docker 容器化

**Dockerfile**：
```dockerfile
FROM node:18-alpine

WORKDIR /app

# 安装依赖
COPY package*.json ./
RUN npm ci --only=production

# 复制源码
COPY . .

# 构建 TypeScript
RUN npm run build

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["node", "dist/index.js"]
```

**docker-compose.yml**：
```yaml
version: '3.8'

services:
  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - REDIS_URL=redis://redis:6379
    env_file:
      - .env
    depends_on:
      - redis
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    restart: unless-stopped

volumes:
  redis_data:
```

### 7.2 阿里云部署方案

**方案 A：ECS + Docker**
- 购买阿里云 ECS（2核4G 起步）
- 安装 Docker 和 Docker Compose
- 使用 Nginx 反向代理
- 配置 HTTPS 证书（Let's Encrypt）

**方案 B：函数计算（Serverless）**
- 使用阿里云函数计算（FC）
- 按调用次数计费，成本更低
- 自动扩缩容
- 需要适配 Serverless 架构（无状态）

**推荐方案**：
- MVP 阶段：方案 A（ECS + Docker）- 更灵活，易于调试
- 成熟阶段：方案 B（Serverless）- 成本优化

### 7.3 监控与告警

**健康检查**：
```typescript
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    redis: redisClient.status === 'ready'
  })
})
```

**监控指标**：
- API 响应时间（P50、P95、P99）
- 错误率（按错误码分类）
- 额度使用情况
- 第三方服务调用成功率
- Redis 连接状态

**告警规则**：
- 错误率 > 5%：发送告警
- API 响应时间 P95 > 30s：发送告警
- Redis 连接失败：发送告警
- 每日 API 成本超预算：发送告警



---

## 8. 项目结构

```
notey-backend/
├── src/
│   ├── index.ts                 # 应用入口
│   ├── config/
│   │   └── index.ts             # 配置管理
│   ├── middleware/
│   │   ├── auth.ts              # 身份验证
│   │   ├── rateLimit.ts         # 速率限制
│   │   └── logger.ts            # 请求日志
│   ├── services/
│   │   ├── video.service.ts     # 视频处理服务
│   │   ├── quota.service.ts     # 额度管理服务
│   │   ├── ai.service.ts        # AI 助手服务
│   │   ├── coze.service.ts      # Coze API 封装
│   │   ├── asr.service.ts       # 阿里云 ASR 封装
│   │   └── search.service.ts    # 搜索 API 封装
│   ├── parsers/
│   │   ├── douyin.parser.ts     # 抖音解析器
│   │   ├── bilibili.parser.ts   # B站解析器
│   │   ├── xiaohongshu.parser.ts # 小红书解析器
│   │   └── tiktok.parser.ts     # TikTok 解析器
│   ├── routes/
│   │   ├── v2.routes.ts         # V2.0 API 路由
│   │   └── v3.routes.ts         # V3.0 API 路由
│   ├── types/
│   │   └── index.ts             # TypeScript 类型定义
│   └── utils/
│       ├── redis.ts             # Redis 客户端
│       ├── logger.ts            # 日志工具
│       └── errors.ts            # 错误处理
├── tests/
│   ├── unit/                    # 单元测试
│   └── integration/             # 集成测试
├── logs/                        # 日志文件
├── .env.example                 # 环境变量示例
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── package.json
├── tsconfig.json
└── README.md
```

---

## 9. 开发计划

### Phase 1: 基础架构（1 周）
- [ ] 项目初始化（Express + TypeScript）
- [ ] Redis 连接和配置
- [ ] 中间件开发（auth、rate limit、logger）
- [ ] 健康检查接口
- [ ] Docker 容器化

### Phase 2: V2.0 核心功能（2-3 周）
- [ ] 视频 URL 解析器（抖音、B站）
- [ ] Coze API 集成
- [ ] 阿里云 ASR 集成
- [ ] 额度管理服务
- [ ] `/api/v2/process-video` 接口
- [ ] `/api/v2/quota` 接口
- [ ] 错误处理和日志
- [ ] 单元测试

### Phase 3: 部署与测试（1 周）
- [ ] 阿里云 ECS 部署
- [ ] Nginx 反向代理配置
- [ ] HTTPS 证书配置
- [ ] 监控和告警设置
- [ ] 压力测试
- [ ] iOS 客户端联调

### Phase 4: V3.0 AI 助手（2 周）
- [ ] 搜索 API 集成（Serper）
- [ ] AI 主题提取功能
- [ ] 内容格式化和去重
- [ ] `/api/v3/expand-note` 接口
- [ ] AI 助手额度管理
- [ ] 集成测试

**总计**：约 6-7 周

---

## 10. 风险与应对

### 风险 1：视频平台反爬
**影响**：无法解析视频 URL
**应对**：
- 使用多个解析方案（官方 API + 第三方库）
- 实现降级策略（解析失败时保存原始链接）
- 定期更新解析器

### 风险 2：第三方服务稳定性
**影响**：Coze/阿里云服务故障导致功能不可用
**应对**：
- 实现重试机制（指数退避）
- 设置超时时间（30 秒）
- 提供降级方案（保存草稿）
- 监控第三方服务可用性

### 风险 3：成本超预期
**影响**：LLM 和 ASR 调用成本过高
**应对**：
- 严格的额度限制（每日 5 次）
- 实时成本监控和告警
- 优化 Prompt 减少 Token 消耗
- 考虑使用更便宜的模型

### 风险 4：用户滥用
**影响**：恶意用户绕过额度限制
**应对**：
- 设备 ID + IP 双重限制
- 异常行为检测（短时间大量请求）
- 黑名单机制
- 验证码（极端情况）

---

## 11. 性能优化

### 11.1 缓存策略
- 视频元数据缓存（1 小时）
- 搜索结果缓存（V3.0，30 分钟）
- 用户额度缓存（Redis）

### 11.2 并发处理
- 使用 Node.js 异步 I/O
- 限制并发请求数（避免第三方服务过载）
- 使用消息队列处理长时间任务（可选）

### 11.3 数据库优化
- Redis 连接池
- 索引优化（如果使用 SQL 数据库）
- 定期清理过期数据

---

## 12. 测试策略

### 12.1 单元测试
- 视频解析器测试
- 额度管理逻辑测试
- 错误处理测试
- 覆盖率目标：> 70%

### 12.2 集成测试
- API 端到端测试
- 第三方服务 Mock 测试
- 错误场景测试

### 12.3 压力测试
- 并发请求测试（100 QPS）
- 长时间运行测试（24 小时）
- 内存泄漏检测

---

## 13. 文档

### 13.1 API 文档
- 使用 Swagger/OpenAPI 规范
- 提供交互式 API 测试界面
- 包含请求示例和响应示例

### 13.2 部署文档
- 环境配置说明
- Docker 部署步骤
- 阿里云部署指南
- 故障排查指南

### 13.3 开发文档
- 项目架构说明
- 代码规范
- 贡献指南
- 常见问题 FAQ

---

## 14. 后续优化方向

- [ ] 支持更多视频平台（YouTube、微博视频）
- [ ] 多语言支持（英文视频转笔记）
- [ ] 用户自定义 API Key（高级用户）
- [ ] 笔记云同步功能
- [ ] 管理后台（用户管理、数据统计）
- [ ] WebSocket 实时推送（处理进度）
- [ ] CDN 加速（视频下载）
- [ ] 分布式部署（多地域）
