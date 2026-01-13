import { ChevronLeft } from 'lucide-react';
import { useState } from 'react';

interface NotificationSettingsPageProps {
  onBack: () => void;
}

export function NotificationSettingsPage({ onBack }: NotificationSettingsPageProps) {
  const [recordComplete, setRecordComplete] = useState(true);

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
            通知
          </h1>
        </div>
      </header>

      {/* Content */}
      <main className="relative px-4 pb-8">
        <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40">
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
          
          <div className="relative">
            {/* Record Complete */}
            <div className="px-4 py-4">
              <div className="flex items-center justify-between">
                <div className="flex-1">
                  <div className="text-[16px] text-white drop-shadow-md mb-1">
                    记录完成
                  </div>
                  <div className="text-[13px] text-white/60 leading-relaxed drop-shadow-sm">
                    当notey完成笔记生成时通知我
                  </div>
                </div>
                
                {/* iOS Toggle Switch */}
                <button
                  onClick={() => setRecordComplete(!recordComplete)}
                  className={`relative w-[51px] h-[31px] rounded-full transition-colors duration-200 ease-in-out flex-shrink-0 ml-3 ${
                    recordComplete ? 'bg-[#34C759]' : 'bg-white/30'
                  }`}
                  role="switch"
                  aria-checked={recordComplete}
                >
                  <span
                    className={`absolute top-[2px] left-[2px] w-[27px] h-[27px] bg-white rounded-full shadow-md transition-transform duration-200 ease-in-out ${
                      recordComplete ? 'translate-x-[20px]' : 'translate-x-0'
                    }`}
                  />
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
