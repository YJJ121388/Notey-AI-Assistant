import { X } from 'lucide-react';
import { useState } from 'react';

interface AddFolderSheetProps {
  isOpen: boolean;
  onClose: () => void;
  onAdd: (folderName: string) => void;
}

export function AddFolderSheet({ isOpen, onClose, onAdd }: AddFolderSheetProps) {
  const [folderName, setFolderName] = useState('');

  if (!isOpen) return null;

  const handleSubmit = () => {
    if (folderName.trim()) {
      onAdd(folderName.trim());
      setFolderName('');
      onClose();
    }
  };

  const handleClose = () => {
    setFolderName('');
    onClose();
  };

  return (
    <>
      {/* Backdrop */}
      <div
        className="fixed inset-0 bg-black/40 backdrop-blur-sm z-40 transition-opacity"
        onClick={handleClose}
      />

      {/* Sheet */}
      <div className="fixed bottom-0 left-0 right-0 z-50 animate-slide-up">
        <div className="relative bg-white/20 backdrop-blur-2xl rounded-t-[30px] border-t border-white/30 shadow-2xl">
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-t-[30px] pointer-events-none" />
          
          <div className="relative">
            {/* Header */}
            <div className="flex items-center justify-between p-4 border-b border-white/20">
              <h3 className="text-[17px] font-semibold text-white drop-shadow-md">新建文件夹</h3>
              <button
                onClick={handleClose}
                className="w-8 h-8 flex items-center justify-center rounded-full bg-white/20 hover:bg-white/30 transition-colors active:scale-95"
              >
                <X className="w-5 h-5 text-white drop-shadow-sm" strokeWidth={2} />
              </button>
            </div>

            {/* Content */}
            <div className="p-4 space-y-4">
              {/* Input Field */}
              <div className="relative overflow-hidden bg-white/20 backdrop-blur-md rounded-[20px] border border-white/30 shadow-lg">
                <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-white/5 to-transparent rounded-[20px] pointer-events-none" />
                <input
                  type="text"
                  value={folderName}
                  onChange={(e) => setFolderName(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') {
                      handleSubmit();
                    }
                  }}
                  placeholder="输入文件夹名称"
                  className="relative w-full bg-transparent px-4 py-3 text-[16px] text-white placeholder-white/50 outline-none"
                  autoFocus
                />
              </div>

              {/* Action Buttons */}
              <div className="flex gap-3">
                <button
                  onClick={handleClose}
                  className="flex-1 relative overflow-hidden bg-white/15 backdrop-blur-md rounded-[20px] py-3 shadow-lg border border-white/30 active:scale-[0.98] transition-transform"
                >
                  <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-white/5 to-transparent rounded-[20px] pointer-events-none" />
                  <span className="relative text-[16px] font-medium text-white/80 drop-shadow-sm">取消</span>
                </button>
                <button
                  onClick={handleSubmit}
                  disabled={!folderName.trim()}
                  className={`flex-1 relative overflow-hidden backdrop-blur-md rounded-[20px] py-3 shadow-lg border active:scale-[0.98] transition-transform ${
                    folderName.trim()
                      ? 'bg-white/30 border-white/40'
                      : 'bg-white/10 border-white/20 opacity-50'
                  }`}
                >
                  <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[20px] pointer-events-none" />
                  <span className="relative text-[16px] font-semibold text-white drop-shadow-sm">创建</span>
                </button>
              </div>
            </div>

            {/* Bottom safe area */}
            <div className="h-8" />
          </div>
        </div>
      </div>

      <style>{`
        @keyframes slide-up {
          from {
            transform: translateY(100%);
          }
          to {
            transform: translateY(0);
          }
        }
        .animate-slide-up {
          animation: slide-up 0.3s ease-out;
        }
      `}</style>
    </>
  );
}