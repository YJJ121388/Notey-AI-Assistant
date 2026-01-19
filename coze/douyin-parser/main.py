"""
Douyin/TikTok Video URL Parser Middleware
使用 yt-dlp 提取视频音频直链
"""
import subprocess
import json
import os
from typing import Optional, Dict, Any
from fastapi import FastAPI, HTTPException, Query
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import logging

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="Douyin Parser API",
    description="抖音/TikTok 视频解析中间件",
    version="1.0.0"
)

# 配置 CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 从环境变量读取配置
PROXY_URL = os.getenv("PROXY_URL", "")
TIMEOUT = int(os.getenv("TIMEOUT", "30"))


def extract_audio_url(video_url: str) -> Dict[str, Any]:
    """
    使用 yt-dlp 提取音频直链
    
    Args:
        video_url: 视频分享链接
        
    Returns:
        包含音频 URL 和元数据的字典
        
    Raises:
        Exception: 解析失败时抛出异常
    """
    try:
        # 构建 yt-dlp 命令
        cmd = [
            "yt-dlp",
            "-g",  # 只获取 URL，不下载
            "-f", "bestaudio/best",  # 优先获取最佳音频
            "--no-warnings",  # 不显示警告
            video_url
        ]
        
        # 如果配置了代理，添加代理参数
        if PROXY_URL:
            cmd.extend(["--proxy", PROXY_URL])
            logger.info(f"使用代理: {PROXY_URL}")
        
        logger.info(f"执行命令: {' '.join(cmd)}")
        
        # 执行命令
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=TIMEOUT
        )
        
        if result.returncode != 0:
            error_msg = result.stderr.strip()
            logger.error(f"yt-dlp 执行失败: {error_msg}")
            raise Exception(f"解析失败: {error_msg}")
        
        # 获取音频 URL（第一行输出）
        audio_url = result.stdout.strip().split('\n')[0]
        
        if not audio_url:
            raise Exception("未能提取到音频 URL")
        
        logger.info(f"成功提取音频 URL: {audio_url[:100]}...")
        
        return {
            "audio_url": audio_url,
            "original_url": video_url
        }
        
    except subprocess.TimeoutExpired:
        logger.error(f"解析超时 (>{TIMEOUT}s)")
        raise Exception(f"解析超时，请稍后重试")
    except Exception as e:
        logger.error(f"解析异常: {str(e)}")
        raise


def get_video_info(video_url: str) -> Dict[str, Any]:
    """
    获取视频详细信息（标题、作者、时长等）
    
    Args:
        video_url: 视频分享链接
        
    Returns:
        包含视频信息的字典
    """
    try:
        cmd = [
            "yt-dlp",
            "-J",  # 输出 JSON 格式
            "--no-warnings",
            video_url
        ]
        
        if PROXY_URL:
            cmd.extend(["--proxy", PROXY_URL])
        
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=TIMEOUT
        )
        
        if result.returncode != 0:
            logger.warning(f"获取视频信息失败: {result.stderr}")
            return {}
        
        info = json.loads(result.stdout)
        
        return {
            "title": info.get("title", ""),
            "author": info.get("uploader", ""),
            "duration": info.get("duration", 0),
            "description": info.get("description", "")
        }
        
    except Exception as e:
        logger.warning(f"获取视频信息异常: {str(e)}")
        return {}


@app.get("/")
async def root():
    """健康检查端点"""
    return {
        "status": "ok",
        "service": "Douyin Parser API",
        "version": "1.0.0"
    }


@app.get("/extract_audio")
async def extract_audio(
    url: str = Query(..., description="抖音/TikTok 视频分享链接")
):
    """
    提取视频音频直链
    
    Args:
        url: 视频分享链接（如 https://www.douyin.com/video/xxx）
        
    Returns:
        JSON 响应，包含音频 URL 和元数据
    """
    try:
        logger.info(f"收到解析请求: {url}")
        
        # 提取音频 URL
        result = extract_audio_url(url)
        
        # 尝试获取视频信息（可选，失败不影响主流程）
        video_info = get_video_info(url)
        if video_info:
            result["metadata"] = video_info
        
        return JSONResponse(
            status_code=200,
            content={
                "status": "success",
                "data": result
            }
        )
        
    except subprocess.TimeoutExpired:
        logger.error("请求超时")
        raise HTTPException(
            status_code=504,
            detail="解析超时，请稍后重试"
        )
    except Exception as e:
        error_msg = str(e)
        logger.error(f"解析失败: {error_msg}")
        
        # 判断错误类型
        if "网络" in error_msg or "network" in error_msg.lower():
            status_code = 503
        elif "不支持" in error_msg or "unsupported" in error_msg.lower():
            status_code = 400
        else:
            status_code = 500
        
        raise HTTPException(
            status_code=status_code,
            detail=error_msg
        )


@app.get("/health")
async def health_check():
    """
    健康检查端点
    检查 yt-dlp 是否可用
    """
    try:
        result = subprocess.run(
            ["yt-dlp", "--version"],
            capture_output=True,
            text=True,
            timeout=5
        )
        
        if result.returncode == 0:
            version = result.stdout.strip()
            return {
                "status": "healthy",
                "yt_dlp_version": version
            }
        else:
            return JSONResponse(
                status_code=503,
                content={
                    "status": "unhealthy",
                    "error": "yt-dlp 不可用"
                }
            )
    except Exception as e:
        return JSONResponse(
            status_code=503,
            content={
                "status": "unhealthy",
                "error": str(e)
            }
        )


if __name__ == "__main__":
    import uvicorn
    
    port = int(os.getenv("PORT", "8000"))
    host = os.getenv("HOST", "0.0.0.0")
    
    logger.info(f"启动服务: {host}:{port}")
    
    uvicorn.run(
        app,
        host=host,
        port=port,
        log_level="info"
    )
