import { Video, StickyNote, Bell } from 'lucide-react';

interface NoteCardProps {
  title: string;
  summary: string;
  timestamp: string;
  type?: 'recorded' | 'draft';
  videoUrl?: string;
  onClick?: () => void;
}

export function NoteCard({ title, summary, timestamp, type = 'recorded', videoUrl, onClick }: NoteCardProps) {
  const Icon = type === 'recorded' ? StickyNote : Bell;

  return (
    <div 
      className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] p-4 shadow-2xl border border-white/40 active:scale-[0.98] transition-transform cursor-pointer"
      onClick={onClick}
    >
      {/* Glass effect overlay */}
      <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
      
      <div className="relative flex gap-3">
        {/* Icon */}
        <div className="flex-shrink-0 w-10 h-10 bg-white/35 backdrop-blur-md rounded-[15px] flex items-center justify-center border border-white/50 shadow-lg">
          <Icon className="w-5 h-5 text-white drop-shadow-sm" strokeWidth={2} />
        </div>

        {/* Content */}
        <div className="flex-1 min-w-0">
          {type === 'draft' ? (
            // Draft note: show reminder message
            <div className="flex items-start justify-between gap-2">
              <p className="text-[15px] text-white/85 leading-[1.35] drop-shadow-sm">
                这篇笔记录入失败了，请点击查看
              </p>
              <span className="text-[13px] text-white/70 flex-shrink-0 mt-0.5 drop-shadow-sm">
                {timestamp}
              </span>
            </div>
          ) : (
            // Recorded note: show title and summary
            <>
              <div className="flex items-start justify-between gap-2 mb-1">
                <h3 className="font-semibold text-[17px] text-white leading-tight drop-shadow-md">
                  {title}
                </h3>
                <span className="text-[13px] text-white/70 flex-shrink-0 mt-0.5 drop-shadow-sm">
                  {timestamp}
                </span>
              </div>
              <p className="text-[15px] text-white/85 leading-[1.35] line-clamp-2 drop-shadow-sm">
                {summary}
              </p>
            </>
          )}
        </div>
      </div>
    </div>
  );
}