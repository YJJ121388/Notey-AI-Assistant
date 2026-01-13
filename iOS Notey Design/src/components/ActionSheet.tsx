import { Star, Trash2, X } from 'lucide-react';

interface ActionSheetProps {
  isOpen: boolean;
  onClose: () => void;
  onFavorite: () => void;
  onDelete: () => void;
  isFavorited: boolean;
}

export function ActionSheet({ 
  isOpen, 
  onClose, 
  onFavorite, 
  onDelete,
  isFavorited 
}: ActionSheetProps) {
  if (!isOpen) return null;

  return (
    <>
      {/* Backdrop */}
      <div 
        className="fixed inset-0 bg-black/50 backdrop-blur-sm z-40 animate-in fade-in duration-200"
        onClick={onClose}
      />

      {/* Action Sheet */}
      <div className="fixed bottom-0 left-0 right-0 z-50 animate-in slide-in-from-bottom duration-300 px-4 pb-8">
        <div className="relative overflow-hidden bg-white/20 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40">
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
          
          <div className="relative">
            {/* Favorite Option */}
            <button
              onClick={() => {
                onFavorite();
                onClose();
              }}
              className="w-full flex items-center gap-4 p-4 active:bg-white/20 transition-colors border-b border-white/20"
            >
              <div className="w-10 h-10 bg-white/25 backdrop-blur-md rounded-full flex items-center justify-center border border-white/30">
                <Star 
                  className={`w-5 h-5 drop-shadow-sm ${
                    isFavorited 
                      ? 'fill-yellow-300 text-yellow-300' 
                      : 'text-white'
                  }`}
                  strokeWidth={2}
                />
              </div>
              <span className="text-[16px] font-medium text-white drop-shadow-md">
                {isFavorited ? '取消收藏' : '收藏该内容'}
              </span>
            </button>

            {/* Delete Option */}
            <button
              onClick={() => {
                onDelete();
                onClose();
              }}
              className="w-full flex items-center gap-4 p-4 active:bg-white/20 transition-colors"
            >
              <div className="w-10 h-10 bg-red-500/30 backdrop-blur-md rounded-full flex items-center justify-center border border-red-400/40">
                <Trash2 className="w-5 h-5 text-red-300 drop-shadow-sm" strokeWidth={2} />
              </div>
              <span className="text-[16px] font-medium text-red-300 drop-shadow-md">
                删除该内容
              </span>
            </button>
          </div>
        </div>

        {/* Cancel Button */}
        <button
          onClick={onClose}
          className="mt-3 w-full relative overflow-hidden bg-white/20 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40 p-4 active:bg-white/30 transition-colors"
        >
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
          <span className="relative text-[16px] font-semibold text-white drop-shadow-md">
            取消
          </span>
        </button>
      </div>
    </>
  );
}
