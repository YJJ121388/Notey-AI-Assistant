import { ChevronLeft, Pencil, Check, ChevronDown } from 'lucide-react';
import { useState } from 'react';

interface NoteDetailPageProps {
  note: {
    id: string;
    title: string;
    icon: string;
  };
  onBack: () => void;
  onSave: (noteId: string, updatedContent: { title: string; content: string }) => void;
}

export function NoteDetailPage({ note, onBack, onSave }: NoteDetailPageProps) {
  const [isEditing, setIsEditing] = useState(false);
  const [title, setTitle] = useState(note.title);
  const [content, setContent] = useState('这是笔记的详细内容。您可以在这里记录更多信息、想法和细节。\n\n点击右上角的铅笔图标开始编辑。');

  const handleSave = () => {
    onSave(note.id, { title, content });
    setIsEditing(false);
  };

  const handleCancel = () => {
    // Reset to original values
    setTitle(note.title);
    setContent('这是笔记的详细内容。您可以在这里记录更多信息、想法和细节。\n\n点击右上角的铅笔图标开始编辑。');
    setIsEditing(false);
  };

  // Render editing mode
  if (isEditing) {
    return (
      <div className="fixed inset-0 bg-gradient-to-b from-[#87CEEB] to-[#000000] z-50 flex flex-col">
        {/* Decorative background elements */}
        <div className="absolute top-0 left-0 w-96 h-96 bg-[#5DADE2] rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob"></div>
        <div className="absolute top-0 right-0 w-96 h-96 bg-[#3498DB] rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob animation-delay-2000"></div>
        <div className="absolute bottom-0 left-1/2 w-96 h-96 bg-[#1C1C1C] rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob animation-delay-4000"></div>

        {/* Header with Cancel and Done buttons */}
        <header className="relative px-5 pt-16 pb-4 flex-shrink-0">
          <div className="flex items-center justify-between">
            <button
              onClick={handleCancel}
              className="text-[17px] text-white/90 active:text-white/60 transition-colors drop-shadow-md"
            >
              取消
            </button>
            <h1 className="text-[17px] font-semibold text-white drop-shadow-lg">
              编辑笔记
            </h1>
            <button
              onClick={handleSave}
              className="text-[17px] font-semibold text-white active:text-white/60 transition-colors drop-shadow-md"
            >
              完成
            </button>
          </div>
        </header>

        {/* Scrollable content area */}
        <main className="relative flex-1 overflow-auto px-4 pb-4">
          <div className="space-y-3">
            {/* Title Card */}
            <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40">
              {/* Glass effect overlay */}
              <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
              
              <div className="relative p-5">
                <input
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="w-full bg-transparent text-[28px] font-bold text-white placeholder-white/40 focus:outline-none drop-shadow-md"
                  placeholder="标题"
                  autoFocus
                />
              </div>
            </div>

            {/* Content Card */}
            <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40">
              {/* Glass effect overlay */}
              <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
              
              <div className="relative p-5">
                <textarea
                  value={content}
                  onChange={(e) => setContent(e.target.value)}
                  className="w-full min-h-[300px] bg-transparent text-[17px] text-white/90 placeholder-white/40 focus:outline-none resize-none drop-shadow-sm leading-relaxed"
                  placeholder="输入笔记内容..."
                />
              </div>
            </div>
          </div>
        </main>

        {/* iOS Keyboard Simulation */}
        <div className="relative flex-shrink-0 bg-[#D1D5DB]/95 backdrop-blur-xl border-t border-white/20" style={{ height: '291px' }}>
          {/* Keyboard suggestion bar */}
          <div className="h-11 bg-[#C7CBD1]/90 border-b border-[#A8ACB3] flex items-center justify-between px-3">
            <div className="flex gap-2">
              <div className="px-3 py-1 bg-white/80 rounded-md text-[13px] text-gray-800">笔记</div>
              <div className="px-3 py-1 bg-white/80 rounded-md text-[13px] text-gray-800">编辑</div>
            </div>
            <button className="text-[15px] text-gray-700">
              <ChevronDown className="w-5 h-5" strokeWidth={2} />
            </button>
          </div>

          {/* Keyboard keys - simplified representation */}
          <div className="p-1.5 space-y-2">
            {/* Row 1 */}
            <div className="flex gap-1.5 justify-center">
              {['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'].map((key) => (
                <div key={key} className="flex-1 h-10 bg-white rounded-md shadow-sm flex items-center justify-center text-[20px] font-normal text-gray-900">
                  {key}
                </div>
              ))}
            </div>

            {/* Row 2 */}
            <div className="flex gap-1.5 justify-center px-3">
              {['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'].map((key) => (
                <div key={key} className="flex-1 h-10 bg-white rounded-md shadow-sm flex items-center justify-center text-[20px] font-normal text-gray-900">
                  {key}
                </div>
              ))}
            </div>

            {/* Row 3 */}
            <div className="flex gap-1.5 justify-center">
              <div className="w-12 h-10 bg-[#AEB4BC] rounded-md shadow-sm flex items-center justify-center">
                <svg className="w-5 h-5 text-gray-900" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 15l7-7 7 7" />
                </svg>
              </div>
              {['Z', 'X', 'C', 'V', 'B', 'N', 'M'].map((key) => (
                <div key={key} className="flex-1 h-10 bg-white rounded-md shadow-sm flex items-center justify-center text-[20px] font-normal text-gray-900">
                  {key}
                </div>
              ))}
              <div className="w-12 h-10 bg-[#AEB4BC] rounded-md shadow-sm flex items-center justify-center">
                <svg className="w-5 h-5 text-gray-900" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
              </div>
            </div>

            {/* Row 4 - Space bar row */}
            <div className="flex gap-1.5 justify-center">
              <div className="w-16 h-10 bg-[#AEB4BC] rounded-md shadow-sm flex items-center justify-center text-[15px] text-gray-900">
                123
              </div>
              <div className="w-12 h-10 bg-white rounded-md shadow-sm flex items-center justify-center text-[20px]">
                🌐
              </div>
              <div className="flex-1 h-10 bg-white rounded-md shadow-sm flex items-center justify-center text-[15px] text-gray-900">
                space
              </div>
              <div className="w-16 h-10 bg-[#AEB4BC] rounded-md shadow-sm flex items-center justify-center text-[15px] font-medium text-gray-900">
                return
              </div>
            </div>
          </div>

          {/* Home indicator */}
          <div className="absolute bottom-2 left-1/2 -translate-x-1/2 w-32 h-1 bg-gray-900/30 rounded-full" />
        </div>
      </div>
    );
  }

  // Render reading mode
  return (
    <div className="fixed inset-0 bg-gradient-to-b from-[#87CEEB] to-[#000000] z-50 overflow-auto">
      {/* Decorative background elements */}
      <div className="absolute top-0 left-0 w-96 h-96 bg-[#5DADE2] rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob"></div>
      <div className="absolute top-0 right-0 w-96 h-96 bg-[#3498DB] rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob animation-delay-2000"></div>
      <div className="absolute bottom-0 left-1/2 w-96 h-96 bg-[#1C1C1C] rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob animation-delay-4000"></div>

      {/* Header */}
      <header className="relative px-5 pt-16 pb-4">
        <div className="flex items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <button
              onClick={onBack}
              className="w-10 h-10 flex items-center justify-center rounded-full bg-white/20 backdrop-blur-md active:bg-white/30 transition-colors"
              aria-label="返回"
            >
              <ChevronLeft className="w-6 h-6 text-white" strokeWidth={2} />
            </button>
            <h1 className="text-[28px] font-bold tracking-tight text-white drop-shadow-lg">
              {isEditing ? '编辑笔记' : '笔记详情'}
            </h1>
          </div>
          
          <button
            onClick={isEditing ? handleSave : () => setIsEditing(true)}
            className="w-10 h-10 flex items-center justify-center rounded-full bg-white/20 backdrop-blur-md active:bg-white/30 transition-colors"
            aria-label={isEditing ? '保存' : '编辑'}
          >
            {isEditing ? (
              <Check className="w-6 h-6 text-white" strokeWidth={2} />
            ) : (
              <Pencil className="w-5 h-5 text-white" strokeWidth={2} />
            )}
          </button>
        </div>
      </header>

      {/* Content */}
      <main className="relative px-4 pb-8">
        <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40">
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
          
          <div className="relative p-6">
            {/* Icon and Title */}
            <div className="flex items-center gap-3 mb-6">
              <div className="flex-shrink-0 w-12 h-12 bg-white/35 backdrop-blur-md rounded-[18px] flex items-center justify-center border border-white/50 shadow-lg">
                <span className="text-2xl">{note.icon}</span>
              </div>
              
              {isEditing ? (
                <input
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="flex-1 bg-white/20 backdrop-blur-md rounded-[15px] px-4 py-2 text-[20px] font-semibold text-white placeholder-white/50 border border-white/30 focus:outline-none focus:ring-2 focus:ring-white/40 drop-shadow-md"
                  placeholder="笔记标题"
                />
              ) : (
                <h2 className="flex-1 text-[20px] font-semibold text-white drop-shadow-md">
                  {title}
                </h2>
              )}
            </div>

            {/* Divider */}
            <div className="h-px bg-white/20 mb-6" />

            {/* Content */}
            {isEditing ? (
              <textarea
                value={content}
                onChange={(e) => setContent(e.target.value)}
                className="w-full min-h-[400px] bg-white/20 backdrop-blur-md rounded-[20px] p-4 text-[15px] text-white/90 placeholder-white/50 border border-white/30 focus:outline-none focus:ring-2 focus:ring-white/40 resize-none drop-shadow-sm leading-relaxed"
                placeholder="在这里输入笔记内容..."
              />
            ) : (
              <div className="prose prose-invert max-w-none">
                <p className="text-[15px] text-white/90 leading-relaxed drop-shadow-sm whitespace-pre-wrap">
                  {content}
                </p>
              </div>
            )}

            {/* Edit hint in reading mode */}
            {!isEditing && (
              <div className="mt-6 pt-6 border-t border-white/20">
                <p className="text-[13px] text-white/60 text-center drop-shadow-sm">
                  点击右上角的 <Pencil className="inline w-3.5 h-3.5 mx-0.5" strokeWidth={2} /> 图标开始编辑
                </p>
              </div>
            )}
          </div>
        </div>

        {/* Metadata card */}
        {!isEditing && (
          <div className="relative overflow-hidden bg-white/10 backdrop-blur-2xl rounded-[30px] shadow-xl border border-white/30 mt-4">
            <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-white/5 to-transparent rounded-[30px] pointer-events-none" />
            
            <div className="relative p-5">
              <h3 className="text-[15px] font-semibold text-white/80 mb-3 drop-shadow-sm">笔记信息</h3>
              <div className="space-y-2">
                <div className="flex justify-between items-center">
                  <span className="text-[14px] text-white/60 drop-shadow-sm">创建时间</span>
                  <span className="text-[14px] text-white/80 drop-shadow-sm">2024年1月10日</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-[14px] text-white/60 drop-shadow-sm">最后编辑</span>
                  <span className="text-[14px] text-white/80 drop-shadow-sm">今天</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-[14px] text-white/60 drop-shadow-sm">字数统计</span>
                  <span className="text-[14px] text-white/80 drop-shadow-sm">{content.length} 字</span>
                </div>
              </div>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}