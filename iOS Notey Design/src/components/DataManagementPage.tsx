import { ChevronLeft, Download, FileText, Share2, Mail, Copy, X } from 'lucide-react';
import { useState } from 'react';

interface DataManagementPageProps {
  onBack: () => void;
}

export function DataManagementPage({ onBack }: DataManagementPageProps) {
  const [showShareSheet, setShowShareSheet] = useState(false);

  const handleExport = () => {
    setShowShareSheet(true);
  };

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
          <h1 className="text-[28px] font-bold tracking-tight text-white drop-shadow-lg">
            数据管理
          </h1>
        </div>
      </header>

      {/* Storage Info */}
      <div className="relative px-4 pb-3">
        <div className="text-center">
          <p className="text-[13px] text-white/60 drop-shadow-sm">
            已用存储空间：12.5 MB
          </p>
        </div>
      </div>

      {/* Content */}
      <main className="relative px-4 pb-8 space-y-4">
        {/* Export Section */}
        <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40">
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
          
          <div className="relative">
            <button
              onClick={handleExport}
              className="w-full px-4 py-4 flex items-center gap-3 active:bg-white/10 transition-colors"
            >
              <div className="w-7 h-7 flex items-center justify-center flex-shrink-0">
                <Download className="w-5 h-5 text-white/80 drop-shadow-sm" strokeWidth={2} />
              </div>
              <div className="flex-1 text-left">
                <div className="text-[16px] text-white drop-shadow-md">
                  导出所有笔记
                </div>
                <div className="text-[13px] text-white/60 drop-shadow-sm">
                  导出 JSON/Markdown
                </div>
              </div>
              <div className="text-white/50">
                <svg width="8" height="13" viewBox="0 0 8 13" fill="none">
                  <path d="M1 1L6.5 6.5L1 12" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </div>
            </button>
          </div>
        </div>
      </main>

      {/* Share Sheet */}
      {showShareSheet && (
        <>
          {/* Backdrop */}
          <div 
            className="fixed inset-0 bg-black/40 z-[60] animate-fade-in"
            onClick={() => setShowShareSheet(false)}
          />
          
          {/* Share Sheet Panel */}
          <div className="fixed inset-x-0 bottom-0 z-[70] animate-slide-up">
            <div className="mx-4 mb-2">
              {/* File Preview Card */}
              <div className="mb-2 relative overflow-hidden bg-white/95 backdrop-blur-2xl rounded-[20px] shadow-2xl border border-white/50">
                <div className="absolute inset-0 bg-gradient-to-br from-white/50 via-white/20 to-transparent rounded-[20px] pointer-events-none" />
                
                <div className="relative px-5 py-4 flex items-center gap-4">
                  {/* File Icon */}
                  <div className="w-12 h-12 flex items-center justify-center bg-[#007AFF] rounded-xl shadow-lg flex-shrink-0">
                    <FileText className="w-6 h-6 text-white" strokeWidth={2} />
                  </div>
                  
                  {/* File Info */}
                  <div className="flex-1 min-w-0">
                    <div className="text-[15px] font-semibold text-gray-900 truncate">
                      Notey_Backup_20260110.md
                    </div>
                    <div className="text-[13px] text-gray-500 mt-0.5">
                      Markdown 文档
                    </div>
                  </div>
                </div>
              </div>

              {/* Share Actions */}
              <div className="relative overflow-hidden bg-white/95 backdrop-blur-2xl rounded-[20px] shadow-2xl border border-white/50">
                <div className="absolute inset-0 bg-gradient-to-br from-white/50 via-white/20 to-transparent rounded-[20px] pointer-events-none" />
                
                <div className="relative divide-y divide-gray-200/50">
                  <button className="w-full px-5 py-3.5 flex items-center gap-4 active:bg-gray-100/50 transition-colors">
                    <div className="w-9 h-9 flex items-center justify-center bg-gray-100 rounded-full flex-shrink-0">
                      <Share2 className="w-4.5 h-4.5 text-[#007AFF]" strokeWidth={2} />
                    </div>
                    <div className="flex-1 text-left">
                      <div className="text-[16px] text-gray-900">AirDrop</div>
                    </div>
                  </button>

                  <button className="w-full px-5 py-3.5 flex items-center gap-4 active:bg-gray-100/50 transition-colors">
                    <div className="w-9 h-9 flex items-center justify-center bg-gray-100 rounded-full flex-shrink-0">
                      <Mail className="w-4.5 h-4.5 text-[#007AFF]" strokeWidth={2} />
                    </div>
                    <div className="flex-1 text-left">
                      <div className="text-[16px] text-gray-900">邮件</div>
                    </div>
                  </button>

                  <button className="w-full px-5 py-3.5 flex items-center gap-4 active:bg-gray-100/50 transition-colors">
                    <div className="w-9 h-9 flex items-center justify-center bg-gray-100 rounded-full flex-shrink-0">
                      <Copy className="w-4.5 h-4.5 text-[#007AFF]" strokeWidth={2} />
                    </div>
                    <div className="flex-1 text-left">
                      <div className="text-[16px] text-gray-900">拷贝</div>
                    </div>
                  </button>

                  <button className="w-full px-5 py-3.5 flex items-center gap-4 active:bg-gray-100/50 transition-colors">
                    <div className="w-9 h-9 flex items-center justify-center bg-gray-100 rounded-full flex-shrink-0">
                      <Download className="w-4.5 h-4.5 text-[#007AFF]" strokeWidth={2} />
                    </div>
                    <div className="flex-1 text-left">
                      <div className="text-[16px] text-gray-900">存储到文件</div>
                    </div>
                  </button>
                </div>
              </div>

              {/* Cancel Button */}
              <div className="mt-2 relative overflow-hidden bg-white/95 backdrop-blur-2xl rounded-[20px] shadow-2xl border border-white/50">
                <div className="absolute inset-0 bg-gradient-to-br from-white/50 via-white/20 to-transparent rounded-[20px] pointer-events-none" />
                
                <button 
                  onClick={() => setShowShareSheet(false)}
                  className="relative w-full px-5 py-3.5 active:bg-gray-100/50 transition-colors"
                >
                  <div className="text-[16px] font-semibold text-[#007AFF]">
                    取消
                  </div>
                </button>
              </div>
            </div>
            
            {/* Safe area padding for iPhone */}
            <div className="h-[env(safe-area-inset-bottom,20px)]" />
          </div>
        </>
      )}
    </div>
  );
}