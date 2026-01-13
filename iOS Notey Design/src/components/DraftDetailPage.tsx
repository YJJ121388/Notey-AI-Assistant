import { ChevronLeft, Trash2, RefreshCw, ExternalLink } from 'lucide-react';

interface DraftDetailPageProps {
  note: {
    id: string;
    title: string;
    summary: string;
    timestamp: string;
    videoUrl?: string;
  };
  onBack: () => void;
  onDelete: (id: string) => void;
  onRetry: (id: string) => void;
}

export function DraftDetailPage({ note, onBack, onDelete, onRetry }: DraftDetailPageProps) {
  const videoUrl = note.videoUrl || 'https://example.com/video/placeholder';

  return (
    <div className="fixed inset-0 bg-gradient-to-b from-[#87CEEB] to-[#000000] z-50 overflow-auto">
      {/* Decorative background elements */}
      <div className="absolute top-0 left-0 w-96 h-96 bg-[#5DADE2] rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob"></div>
      <div className="absolute top-0 right-0 w-96 h-96 bg-[#3498DB] rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob animation-delay-2000"></div>
      <div className="absolute bottom-0 left-1/2 w-96 h-96 bg-[#1C1C1C] rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob animation-delay-4000"></div>

      {/* Header */}
      <header className="relative px-5 pt-16 pb-4">
        <div className="flex items-center gap-3">
          <button
            onClick={onBack}
            className="w-10 h-10 flex items-center justify-center rounded-full bg-white/20 backdrop-blur-md active:bg-white/30 transition-colors"
            aria-label="返回"
          >
            <ChevronLeft className="w-6 h-6 text-white" strokeWidth={2} />
          </button>
          <h1 className="text-[28px] font-bold tracking-tight text-white drop-shadow-lg">笔记详情</h1>
        </div>
      </header>

      {/* Content */}
      <main className="relative px-4 pb-8">
        {/* Error message card */}
        <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40 mb-4">
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
          
          <div className="relative p-6">
            {/* Alert icon */}
            <div className="w-16 h-16 bg-red-500/20 backdrop-blur-md rounded-full flex items-center justify-center border border-red-400/50 shadow-lg mb-4 mx-auto">
              <span className="text-3xl">⚠️</span>
            </div>

            {/* Title - generic, not showing specific note title */}
            <h2 className="text-[20px] font-semibold text-white text-center mb-2 drop-shadow-md">
              笔记录入失败
            </h2>

            {/* Timestamp */}
            <p className="text-[13px] text-white/60 text-center mb-6 drop-shadow-sm">
              {note.timestamp}
            </p>

            {/* Error message */}
            <p className="text-[15px] text-white/90 text-center leading-relaxed drop-shadow-sm mb-6">
              您的笔记没有被 Notey 捕捉到，以下是原视频链接，您可以尝试再次发送给 Notey 重新记录
            </p>

            {/* Video link */}
            <div className="relative overflow-hidden bg-white/20 backdrop-blur-md rounded-[20px] p-4 shadow-lg border border-white/30 mb-6">
              <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-white/5 to-transparent rounded-[20px] pointer-events-none" />
              
              <div className="relative">
                <p className="text-[13px] text-white/70 mb-2 drop-shadow-sm">原视频链接：</p>
                <a
                  href={videoUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-2 text-[14px] text-blue-300 hover:text-blue-200 transition-colors active:scale-[0.98]"
                >
                  <span className="truncate drop-shadow-sm">{videoUrl}</span>
                  <ExternalLink className="w-4 h-4 flex-shrink-0 drop-shadow-sm" strokeWidth={2} />
                </a>
              </div>
            </div>

            {/* Action buttons */}
            <div className="space-y-3">
              {/* Retry button */}
              <button
                onClick={() => onRetry(note.id)}
                className="w-full relative overflow-hidden bg-blue-500/30 backdrop-blur-md rounded-[20px] p-4 shadow-lg border border-blue-400/50 active:scale-[0.98] transition-transform"
              >
                <div className="absolute inset-0 bg-gradient-to-br from-blue-400/30 via-blue-500/10 to-transparent rounded-[20px] pointer-events-none" />
                
                <div className="relative flex items-center justify-center gap-2">
                  <RefreshCw className="w-5 h-5 text-white drop-shadow-sm" strokeWidth={2} />
                  <span className="text-[16px] font-semibold text-white drop-shadow-md">重新记录</span>
                </div>
              </button>

              {/* Delete button */}
              <button
                onClick={() => onDelete(note.id)}
                className="w-full relative overflow-hidden bg-red-500/20 backdrop-blur-md rounded-[20px] p-4 shadow-lg border border-red-400/40 active:scale-[0.98] transition-transform"
              >
                <div className="absolute inset-0 bg-gradient-to-br from-red-400/20 via-red-500/5 to-transparent rounded-[20px] pointer-events-none" />
                
                <div className="relative flex items-center justify-center gap-2">
                  <Trash2 className="w-5 h-5 text-white drop-shadow-sm" strokeWidth={2} />
                  <span className="text-[16px] font-semibold text-white drop-shadow-md">删除</span>
                </div>
              </button>
            </div>
          </div>
        </div>

        {/* Additional info card */}
        <div className="relative overflow-hidden bg-white/10 backdrop-blur-2xl rounded-[30px] shadow-xl border border-white/30">
          <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-white/5 to-transparent rounded-[30px] pointer-events-none" />
          
          <div className="relative p-5">
            <h3 className="text-[15px] font-semibold text-white/80 mb-3 drop-shadow-sm">说明</h3>
            <p className="text-[14px] text-white/70 leading-relaxed drop-shadow-sm">
              由于网络等原因，您的内容并没有被Notey捕捉到
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}