import { ChevronLeft, BookOpen, HelpCircle, MessageSquare } from 'lucide-react';

interface AboutPageProps {
  onBack: () => void;
}

export function AboutPage({ onBack }: AboutPageProps) {
  const handleGuide = () => {
    console.log('Open guide');
  };

  const handleFAQ = () => {
    console.log('Open FAQ');
  };

  const handleFeedback = () => {
    console.log('Open feedback');
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
            帮助与支持
          </h1>
        </div>
      </header>

      {/* Content */}
      <main className="relative px-4 pb-8 flex flex-col min-h-[calc(100vh-120px)]">
        {/* Brand Display */}
        <div className="flex-1 flex flex-col items-center justify-start pt-12">
          {/* App Logo */}
          <div className="w-28 h-28 mb-6 relative overflow-hidden bg-white/20 backdrop-blur-xl rounded-[28px] shadow-2xl border border-white/40 flex items-center justify-center">
            <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[28px] pointer-events-none" />
            <span className="relative text-[48px]">📝</span>
          </div>

          {/* App Name & Version */}
          <h2 className="text-[32px] font-bold text-white drop-shadow-lg mb-8">
            Notey v2.0
          </h2>

          {/* Help Resources Card */}
          <div className="w-full max-w-md mb-6">
            <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40">
              {/* Glass effect overlay */}
              <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
              
              <div className="relative">
                {/* Guide & Documentation */}
                <button
                  onClick={handleGuide}
                  className="w-full px-4 py-4 flex items-center gap-3 active:bg-white/10 transition-colors border-b border-white/20"
                >
                  <div className="w-7 h-7 flex items-center justify-center flex-shrink-0">
                    <BookOpen className="w-5 h-5 text-white/80 drop-shadow-sm" strokeWidth={2} />
                  </div>
                  <div className="flex-1 text-left">
                    <div className="text-[16px] text-white drop-shadow-md">
                      指南与文档
                    </div>
                  </div>
                  <div className="text-white/50">
                    <svg width="8" height="13" viewBox="0 0 8 13" fill="none">
                      <path d="M1 1L6.5 6.5L1 12" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    </svg>
                  </div>
                </button>

                {/* FAQ */}
                <button
                  onClick={handleFAQ}
                  className="w-full px-4 py-4 flex items-center gap-3 active:bg-white/10 transition-colors border-b border-white/20"
                >
                  <div className="w-7 h-7 flex items-center justify-center flex-shrink-0">
                    <HelpCircle className="w-5 h-5 text-white/80 drop-shadow-sm" strokeWidth={2} />
                  </div>
                  <div className="flex-1 text-left">
                    <div className="text-[16px] text-white drop-shadow-md">
                      常见问题
                    </div>
                  </div>
                  <div className="text-white/50">
                    <svg width="8" height="13" viewBox="0 0 8 13" fill="none">
                      <path d="M1 1L6.5 6.5L1 12" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    </svg>
                  </div>
                </button>

                {/* Feedback & Contact */}
                <button
                  onClick={handleFeedback}
                  className="w-full px-4 py-4 flex items-center gap-3 active:bg-white/10 transition-colors"
                >
                  <div className="w-7 h-7 flex items-center justify-center flex-shrink-0">
                    <MessageSquare className="w-5 h-5 text-white/80 drop-shadow-sm" strokeWidth={2} />
                  </div>
                  <div className="flex-1 text-left">
                    <div className="text-[16px] text-white drop-shadow-md">
                      反馈与联系
                    </div>
                    <div className="text-[13px] text-white/60 drop-shadow-sm">
                      报告问题或提出建议
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
          </div>

          {/* Developer Info Card */}
          <div className="w-full max-w-md">
            <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40">
              {/* Glass effect overlay */}
              <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
              
              <div className="relative px-4 py-4 flex items-center justify-between">
                <div className="text-[16px] text-white/70 drop-shadow-md">
                  开发者
                </div>
                <div className="text-[16px] text-white drop-shadow-md font-medium">
                  Notey Team
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Copyright Footer */}
        <div className="pt-8 pb-6">
          <p className="text-center text-[11px] text-white/40 drop-shadow-sm">
            © 2026 Notey Team
          </p>
        </div>
      </main>
    </div>
  );
}