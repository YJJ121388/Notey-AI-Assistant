import { X } from 'lucide-react';

interface CategorySheetProps {
  isOpen: boolean;
  onClose: () => void;
  onSelectCategory?: (categoryId: string) => void;
  onCategorySelect?: (categoryId: string) => void;
  categories?: Array<{ id: string; title: string; icon: string }>;
  parentCategories?: Array<{ id: string; title: string; icon: string }>;
}

export function CategorySheet({ 
  isOpen, 
  onClose, 
  onSelectCategory, 
  onCategorySelect,
  categories,
  parentCategories 
}: CategorySheetProps) {
  if (!isOpen) return null;

  const categoryList = categories || parentCategories || [];
  const handleSelect = onSelectCategory || onCategorySelect;

  if (!handleSelect) {
    console.error('CategorySheet: No select handler provided');
    return null;
  }

  return (
    <>
      {/* Backdrop */}
      <div
        className="fixed inset-0 bg-black/40 backdrop-blur-sm z-40 transition-opacity"
        onClick={onClose}
      />

      {/* Sheet */}
      <div className="fixed bottom-0 left-0 right-0 z-50 animate-slide-up">
        <div className="relative bg-white/20 backdrop-blur-2xl rounded-t-[30px] border-t border-white/30 shadow-2xl">
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-t-[30px] pointer-events-none" />
          
          <div className="relative">
            {/* Header */}
            <div className="flex items-center justify-between p-4 border-b border-white/20">
              <h3 className="text-[17px] font-semibold text-white drop-shadow-md">选择分类</h3>
              <button
                onClick={onClose}
                className="w-8 h-8 flex items-center justify-center rounded-full bg-white/20 hover:bg-white/30 transition-colors active:scale-95"
              >
                <X className="w-5 h-5 text-white drop-shadow-sm" strokeWidth={2} />
              </button>
            </div>

            {/* Category List */}
            <div className="max-h-[60vh] overflow-y-auto p-4 space-y-2">
              {categoryList.map((category) => (
                <button
                  key={category.id}
                  onClick={() => handleSelect(category.id)}
                  className="w-full relative overflow-hidden bg-white/20 backdrop-blur-md rounded-[20px] p-4 shadow-lg border border-white/30 active:scale-[0.98] transition-transform text-left"
                >
                  {/* Glass effect overlay */}
                  <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-white/5 to-transparent rounded-[20px] pointer-events-none" />
                  
                  <div className="relative flex items-center gap-3">
                    <span className="text-2xl">{category.icon}</span>
                    <span className="text-[16px] font-medium text-white drop-shadow-sm">
                      {category.title}
                    </span>
                  </div>
                </button>
              ))}
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