#!/bin/bash

# 测试脚本 - Douyin Parser API

BASE_URL="http://localhost:8000"

echo "=========================================="
echo "Douyin Parser API 测试脚本"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 测试 1: 健康检查
echo -e "${YELLOW}测试 1: 健康检查${NC}"
echo "GET $BASE_URL/health"
curl -s "$BASE_URL/health" | python3 -m json.tool
echo ""
echo ""

# 测试 2: 服务信息
echo -e "${YELLOW}测试 2: 服务信息${NC}"
echo "GET $BASE_URL/"
curl -s "$BASE_URL/" | python3 -m json.tool
echo ""
echo ""

# 测试 3: 提取抖音视频（需要替换为真实的视频链接）
echo -e "${YELLOW}测试 3: 提取抖音视频音频${NC}"
DOUYIN_URL="https://www.douyin.com/video/7596656920576970025"
echo "GET $BASE_URL/extract_audio?url=$DOUYIN_URL"
echo ""
echo "注意: 请替换为真实有效的抖音视频链接"
echo "执行命令:"
echo "curl \"$BASE_URL/extract_audio?url=$DOUYIN_URL\""
echo ""

# 测试 4: 错误处理 - 无效 URL
echo -e "${YELLOW}测试 4: 错误处理 - 无效 URL${NC}"
INVALID_URL="https://invalid-url.com/video/123"
echo "GET $BASE_URL/extract_audio?url=$INVALID_URL"
curl -s "$BASE_URL/extract_audio?url=$INVALID_URL" | python3 -m json.tool
echo ""
echo ""

echo "=========================================="
echo -e "${GREEN}测试完成${NC}"
echo "=========================================="
echo ""
echo "手动测试命令:"
echo "curl \"$BASE_URL/extract_audio?url=YOUR_VIDEO_URL\""
