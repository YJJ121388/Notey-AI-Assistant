import { NoteCard } from './NoteCard';

interface RecentTabProps {
  uncategorizedNotes: Array<{ id: string; title: string; icon: string }>;
  onNoteClick: (noteId: string) => void;
  draftNotes: Array<{
    id: string;
    title: string;
    summary: string;
    timestamp: string;
    videoUrl?: string;
  }>;
  onDraftClick: (draftId: string) => void;
}

export function RecentTab({ uncategorizedNotes, onNoteClick, draftNotes, onDraftClick }: RecentTabProps) {
  return (
    <main className="relative px-4 pb-8">
      {/* Recent Notes Section - show uncategorized notes */}
      <div className="mb-6">
        <h2 className="text-[20px] font-semibold text-white/60 uppercase tracking-wide mb-3 px-1 font-[Aclonica] text-[rgb(255,255,255)]">
          最近笔记
        </h2>
        <div className="space-y-3">
          {uncategorizedNotes.length === 0 ? (
            <div className="text-center py-8">
              <p className="text-[14px] text-white/50 drop-shadow-sm">暂无未分类的笔记</p>
            </div>
          ) : (
            uncategorizedNotes.map((note) => (
              <div
                key={note.id}
                onClick={() => onNoteClick(note.id)}
                className="cursor-pointer"
              >
                <NoteCard
                  title={note.title}
                  summary="点击为此笔记选择分类"
                  timestamp="未分类"
                  type="recorded"
                />
              </div>
            ))
          )}
        </div>
      </div>

      {/* Draft Notes Section */}
      <div>
        <h2 className="text-[20px] font-semibold text-white/60 uppercase tracking-wide mb-3 px-1 font-[Aclonica] text-[rgb(255,255,255)]">
          草稿箱 / 未录入笔记
        </h2>
        <div className="space-y-3">
          {draftNotes.length === 0 ? (
            <div className="text-center py-8">
              <p className="text-[14px] text-white/50 drop-shadow-sm">暂无失败的笔记</p>
            </div>
          ) : (
            draftNotes.map((note) => (
              <NoteCard
                key={note.id}
                title={note.title}
                summary={note.summary}
                timestamp={note.timestamp}
                type="draft"
                videoUrl={note.videoUrl}
                onClick={() => onDraftClick(note.id)}
              />
            ))
          )}
        </div>
      </div>
    </main>
  );
}