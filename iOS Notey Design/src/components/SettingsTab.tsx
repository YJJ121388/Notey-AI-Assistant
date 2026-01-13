import { Bell, Database, HelpCircle, ChevronRight, Wallet } from 'lucide-react';

const settingsItems = [
  { id: '1', title: '用户额度', icon: Wallet },
  { id: '2', title: '通知', icon: Bell },
  { id: '3', title: '数据管理', icon: Database },
  { id: '4', title: '帮助与支持', icon: HelpCircle },
];

interface SettingsTabProps {
  onSettingsItemClick: (itemId: string) => void;
}

export function SettingsTab({ onSettingsItemClick }: SettingsTabProps) {
  return (
    <main className="relative px-4 pb-8">
      <h2 className="text-[20px] font-semibold text-white/60 uppercase tracking-wide mb-3 px-1 font-[Aclonica] text-[rgb(255,255,255)]">
        设置
      </h2>
      
      <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40">
        {/* Glass effect overlay */}
        <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
        
        <div className="relative">
          {settingsItems.map((item, index) => {
            const Icon = item.icon;
            return (
              <div
                key={item.id}
                className={`flex items-center gap-3 px-4 py-4 active:bg-white/10 transition-colors cursor-pointer ${
                  index < settingsItems.length - 1 ? 'border-b border-white/10' : ''
                }`}
                onClick={() => onSettingsItemClick(item.id)}
              >
                <div className="w-10 h-10 bg-white/35 backdrop-blur-md rounded-[15px] flex items-center justify-center border border-white/50 shadow-lg flex-shrink-0">
                  <Icon className="w-5 h-5 text-white drop-shadow-sm" strokeWidth={2} />
                </div>
                <span className="text-[16px] text-white flex-1 drop-shadow-md">
                  {item.title}
                </span>
                <ChevronRight className="w-5 h-5 text-white/50 drop-shadow-sm" strokeWidth={2} />
              </div>
            );
          })}
        </div>
      </div>
    </main>
  );
}