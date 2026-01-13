import { Clock, FileText, Settings } from 'lucide-react';

type Tab = 'recent' | 'notes' | 'settings';

interface TabBarProps {
  activeTab: Tab;
  onTabChange: (tab: Tab) => void;
}

export function TabBar({ activeTab, onTabChange }: TabBarProps) {
  const tabs = [
    { id: 'recent' as Tab, label: '最近内容', icon: Clock },
    { id: 'notes' as Tab, label: '我的笔记', icon: FileText },
    { id: 'settings' as Tab, label: '设置', icon: Settings },
  ];

  return (
    <div className="fixed bottom-6 left-4 right-4 flex justify-center">
      <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40 p-1.5 flex gap-1.5 max-w-md w-full">
        {/* Glass effect overlay */}
        <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
        
        <div className="relative flex gap-1.5 w-full">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            const isActive = activeTab === tab.id;
            
            return (
              <button
                key={tab.id}
                onClick={() => onTabChange(tab.id)}
                className={`flex-1 flex flex-col items-center justify-center py-2 px-3 rounded-[25px] transition-all ${
                  isActive 
                    ? 'bg-white/40 text-white shadow-lg backdrop-blur-sm' 
                    : 'text-white/85 active:bg-white/20'
                }`}
              >
                <Icon className="w-5 h-5 mb-0.5 drop-shadow-md" strokeWidth={2} />
                <span className="text-[10px] font-medium drop-shadow-md text-[rgb(255,255,255)]">{tab.label}</span>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}

export type { Tab };