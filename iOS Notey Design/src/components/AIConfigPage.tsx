import { ChevronLeft } from 'lucide-react';
import { PieChart, Pie, Cell } from 'recharts';

interface AIConfigPageProps {
  onBack: () => void;
}

export function AIConfigPage({ onBack }: AIConfigPageProps) {
  const usedQuota = 3;
  const totalQuota = 5;
  const percentage = (usedQuota / totalQuota) * 100;

  // Data for the circular gauge
  const data = [
    { name: 'Used', value: usedQuota },
    { name: 'Remaining', value: totalQuota - usedQuota }
  ];

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
            用户额度
          </h1>
        </div>
      </header>

      {/* Content */}
      <main className="relative px-4 pb-8 flex flex-col items-center justify-center min-h-[calc(100vh-160px)]">
        {/* Main Glass Card with Circular Gauge */}
        <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40 w-full max-w-md">
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
          
          <div className="relative px-6 py-12 flex flex-col items-center">
            {/* Circular Gauge */}
            <div className="relative w-64 h-64">
              <PieChart width={256} height={256}>
                <Pie
                  data={data}
                  cx="50%"
                  cy="50%"
                  startAngle={90}
                  endAngle={-270}
                  innerRadius={80}
                  outerRadius={120}
                  paddingAngle={0}
                  dataKey="value"
                  strokeWidth={0}
                  cornerRadius={20}
                >
                  <Cell fill="url(#colorGradient)" />
                  <Cell fill="rgba(255, 255, 255, 0.2)" />
                </Pie>
                <defs>
                  <linearGradient id="colorGradient" x1="0" y1="0" x2="1" y2="1">
                    <stop offset="0%" stopColor="#87CEEB" />
                    <stop offset="100%" stopColor="#3498DB" />
                  </linearGradient>
                </defs>
              </PieChart>
              
              {/* Center content */}
              <div className="absolute inset-0 flex flex-col items-center justify-center">
                <div className="text-[48px] font-bold text-white drop-shadow-lg">
                  {usedQuota} / {totalQuota}
                </div>
                <div className="text-[16px] text-white/80 mt-2 drop-shadow-md">
                  今日已用
                </div>
              </div>
            </div>

            {/* Status Text */}
            <div className="mt-8">
              <div className="text-[20px] font-semibold text-white drop-shadow-lg">
                额度充足
              </div>
            </div>
          </div>
        </div>

        {/* Footer Info */}
        <div className="mt-8 px-4 text-center space-y-2">
          <p className="text-[14px] text-white/60 drop-shadow-sm">
            每日 00:00 自动刷新免费额度。
          </p>
          <p className="text-[14px] text-white/60 drop-shadow-sm">
            为保障服务稳定性，当前限制每日 5 次 AI 总结。
          </p>
        </div>
      </main>
    </div>
  );
}