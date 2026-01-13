import { FileText, ChevronRight, ChevronDown, Folder, Star, MoreVertical, Trash2 } from 'lucide-react';
import { useState, useRef, useEffect } from 'react';
import { Toast } from './Toast';
import { ActionSheet } from './ActionSheet';
import { CategorySheet } from './CategorySheet';
import { AddFolderSheet } from './AddFolderSheet';

const recentlyVisited = [
  { id: '1', title: 'enhancement', icon: '📄' },
  { id: '2', title: '面部皮肤检测', icon: '📄' },
  { id: '3', title: 'Interview', icon: '📄' },
  { id: '4', title: 'TERM 2', icon: '📄' },
];

interface MyNotesTabProps {
  uncategorizedNotes: Array<{ id: string; title: string; icon: string }>;
  setUncategorizedNotes: React.Dispatch<React.SetStateAction<Array<{ id: string; title: string; icon: string }>>>;
  categorySheetNoteId: string | null;
  setCategorySheetNoteId: React.Dispatch<React.SetStateAction<string | null>>;
  personalLibrary: Array<{
    id: string;
    title: string;
    icon: string;
    type: 'folder';
    children?: Array<{ id: string; title: string; icon: string }>;
  }>;
  setPersonalLibrary: React.Dispatch<React.SetStateAction<Array<{
    id: string;
    title: string;
    icon: string;
    type: 'folder';
    children?: Array<{ id: string; title: string; icon: string }>;
  }>>>;
  onLibraryNoteClick: (noteId: string) => void;
}

export function MyNotesTab({ 
  uncategorizedNotes, 
  setUncategorizedNotes,
  categorySheetNoteId,
  setCategorySheetNoteId,
  personalLibrary,
  setPersonalLibrary,
  onLibraryNoteClick
}: MyNotesTabProps) {
  const [isExpanded, setIsExpanded] = useState(true);
  const [isFavoritesExpanded, setIsFavoritesExpanded] = useState(true);
  const [isUncategorizedExpanded, setIsUncategorizedExpanded] = useState(true);
  const [expandedFolders, setExpandedFolders] = useState<Set<string>>(new Set());
  const [favorites, setFavorites] = useState<Set<string>>(new Set(['11', '11-1'])); // Pre-favorite 神经网络学习 folder and its child
  const [markedForDeletion, setMarkedForDeletion] = useState<Set<string>>(new Set());
  const [showToast, setShowToast] = useState(false);
  const [toastMessage, setToastMessage] = useState('已收藏');
  const [actionSheetId, setActionSheetId] = useState<string | null>(null);
  const [addFolderSheetId, setAddFolderSheetId] = useState<string | null>(null);
  
  // Ref for the My Favorites card
  const favoritesCardRef = useRef<HTMLDivElement>(null);

  const handleScrollToFavorites = () => {
    setIsFavoritesExpanded(true);
    setTimeout(() => {
      favoritesCardRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }, 100);
  };

  const toggleFolder = (folderId: string) => {
    const newExpanded = new Set(expandedFolders);
    if (newExpanded.has(folderId)) {
      newExpanded.delete(folderId);
    } else {
      newExpanded.add(folderId);
    }
    setExpandedFolders(newExpanded);
  };

  const toggleFavorite = (e: React.MouseEvent, id: string) => {
    e.stopPropagation();
    const newFavorites = new Set(favorites);
    
    // Find if this is a parent item
    const parentItem = personalLibrary.find(item => item.id === id);
    
    if (parentItem && parentItem.children) {
      // If it's a parent with children
      if (newFavorites.has(id)) {
        // Unfavorite parent and all children
        newFavorites.delete(id);
        parentItem.children.forEach(child => {
          newFavorites.delete(child.id);
        });
      } else {
        // Favorite parent and all children
        newFavorites.add(id);
        parentItem.children.forEach(child => {
          newFavorites.add(child.id);
        });
        setShowToast(true);
        setToastMessage('已收藏');
      }
    } else {
      // Regular toggle for child items or items without children
      if (newFavorites.has(id)) {
        newFavorites.delete(id);
      } else {
        newFavorites.add(id);
        setShowToast(true);
        setToastMessage('已收藏');
      }
    }
    
    setFavorites(newFavorites);
  };

  const handleMoreOptions = (e: React.MouseEvent, id: string) => {
    e.stopPropagation();
    setActionSheetId(id);
  };

  const handleDeleteItem = (id: string) => {
    console.log('Deleting item:', id);
    // Here you would actually delete the item from your data
    const newMarkedForDeletion = new Set(markedForDeletion);
    newMarkedForDeletion.add(id);
    setMarkedForDeletion(newMarkedForDeletion);
  };

  const toggleDeleteMark = (e: React.MouseEvent, id: string) => {
    e.stopPropagation();
    const newMarkedForDeletion = new Set(markedForDeletion);
    
    if (newMarkedForDeletion.has(id)) {
      // Already marked, now actually delete it
      setUncategorizedNotes(uncategorizedNotes.filter(note => note.id !== id));
      newMarkedForDeletion.delete(id);
      setToastMessage('已删除');
      setShowToast(true);
    } else {
      // Mark for deletion
      newMarkedForDeletion.add(id);
    }
    
    setMarkedForDeletion(newMarkedForDeletion);
  };

  const handleFavoriteFromSheet = (id: string) => {
    const newFavorites = new Set(favorites);
    
    // Find if this is a parent item
    const parentItem = personalLibrary.find(item => item.id === id);
    
    if (parentItem && parentItem.children) {
      // If it's a parent with children
      if (newFavorites.has(id)) {
        // Unfavorite parent and all children
        newFavorites.delete(id);
        parentItem.children.forEach(child => {
          newFavorites.delete(child.id);
        });
      } else {
        // Favorite parent and all children
        newFavorites.add(id);
        parentItem.children.forEach(child => {
          newFavorites.add(child.id);
        });
        setShowToast(true);
        setToastMessage('已收藏');
      }
    } else {
      // Regular toggle for child items or items without children
      if (newFavorites.has(id)) {
        newFavorites.delete(id);
      } else {
        newFavorites.add(id);
        setShowToast(true);
        setToastMessage('已收藏');
      }
    }
    
    setFavorites(newFavorites);
  };

  const handleAddFolderClick = (id: string) => {
    setAddFolderSheetId(id);
  };

  const handleAddFolder = (folderName: string) => {
    if (!addFolderSheetId) return;
    
    // Add new folder to personalLibrary
    const newFolder = {
      id: `new-folder-${Date.now()}`,
      title: folderName,
      icon: '📁',
      type: 'folder' as const,
      children: []
    };
    setPersonalLibrary([...personalLibrary, newFolder]);
    
    // Show success toast
    setToastMessage('已添加文件夹');
    setShowToast(true);
    
    // Close the add folder sheet
    setAddFolderSheetId(null);
  };

  const handleUncategorizedNoteClick = (noteId: string) => {
    setCategorySheetNoteId(noteId);
  };

  const handleSelectCategory = (categoryId: string) => {
    if (!categorySheetNoteId) return;
    
    // Find the uncategorized note
    const noteToMove = uncategorizedNotes.find(note => note.id === categorySheetNoteId);
    
    if (noteToMove) {
      // Find the target folder in personalLibrary
      const targetFolder = personalLibrary.find(folder => folder.id === categoryId);
      
      if (targetFolder && targetFolder.type === 'folder') {
        // Add the note to the target folder's children
        const newNote = {
          id: `${categoryId}-${Date.now()}`,
          title: noteToMove.title,
          icon: noteToMove.icon
        };
        
        // Update personalLibrary with the new note
        setPersonalLibrary(personalLibrary.map(folder => {
          if (folder.id === categoryId) {
            return {
              ...folder,
              children: [...(folder.children || []), newNote]
            };
          }
          return folder;
        }));
        
        // Remove from uncategorized notes
        setUncategorizedNotes(uncategorizedNotes.filter(note => note.id !== categorySheetNoteId));
        
        // Show success toast
        setToastMessage(`已添加到"${targetFolder.title}"`);
        setShowToast(true);
      }
    }
    
    // Close the category sheet
    setCategorySheetNoteId(null);
  };

  // Auto-open category sheet when note is clicked from RecentTab
  useEffect(() => {
    if (categorySheetNoteId) {
      // Optional: Scroll to uncategorized section
      setIsUncategorizedExpanded(true);
    }
  }, [categorySheetNoteId]);

  // Get parent categories for the category sheet
  const parentCategories = personalLibrary.map(item => ({
    id: item.id,
    title: item.title,
    icon: item.icon
  }));

  // Get all favorited notes (only child notes, not parent folders)
  const favoritedNotes = personalLibrary.reduce<Array<{ id: string; title: string; icon: string }>>((acc, item) => {
    // Only add children if favorited (skip parent folders)
    if (item.children) {
      item.children.forEach(child => {
        if (favorites.has(child.id)) {
          acc.push({ id: child.id, title: child.title, icon: child.icon });
        }
      });
    }
    
    return acc;
  }, []);

  // Show only the first 8 favorited notes
  const recentFavoritedNotes = favoritedNotes.slice(0, 8);
  const hasMoreFavorites = favoritedNotes.length > 8;

  return (
    <main className="relative px-4 pb-8">
      {/* Recently Visited Section */}
      <div className="mb-6">
        <h2 className="text-[20px] font-semibold text-white/60 uppercase tracking-wide mb-3 px-1 font-[Aclonica] text-[rgb(255,255,255)]">
          收藏的笔记
        </h2>
        
        {/* Horizontal scrollable cards */}
        <div className="overflow-x-auto -mx-4 px-4 pb-2">
          <div className="flex gap-3" style={{ width: 'max-content' }}>
            {recentFavoritedNotes.length === 0 ? (
              <div className="w-full py-8 text-center">
                <Star className="w-12 h-12 text-white/30 mx-auto mb-3" strokeWidth={1.5} />
                <p className="text-[14px] text-white/50 drop-shadow-sm">还没有收藏的笔记</p>
              </div>
            ) : (
              <>
                {recentFavoritedNotes.map((note) => (
                  <div
                    key={note.id}
                    className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40 active:scale-[0.98] transition-transform cursor-pointer"
                    style={{ width: '160px', height: '160px' }}
                  >
                    {/* Glass effect overlay */}
                    <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
                    
                    <div className="relative h-full flex flex-col items-center justify-center p-4">
                      <div className="w-12 h-12 bg-white/35 backdrop-blur-md rounded-[18px] flex items-center justify-center border border-white/50 shadow-lg mb-3">
                        <FileText className="w-6 h-6 text-white drop-shadow-sm" strokeWidth={2} />
                      </div>
                      <p className="text-[14px] font-medium text-white text-center line-clamp-2 drop-shadow-md">
                        {note.title}
                      </p>
                    </div>
                  </div>
                ))}
                
                {/* View More Card */}
                {hasMoreFavorites && (
                  <div
                    onClick={handleScrollToFavorites}
                    className="relative overflow-hidden bg-white/10 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/30 active:scale-[0.98] transition-transform cursor-pointer"
                    style={{ width: '160px', height: '160px' }}
                  >
                    {/* Glass effect overlay */}
                    <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-white/5 to-transparent rounded-[30px] pointer-events-none" />
                    
                    <div className="relative h-full flex flex-col items-center justify-center p-4">
                      <div className="w-12 h-12 bg-white/25 backdrop-blur-md rounded-[18px] flex items-center justify-center border border-white/40 shadow-lg mb-3">
                        <ChevronRight className="w-6 h-6 text-white drop-shadow-sm" strokeWidth={2} />
                      </div>
                      <p className="text-[13px] font-medium text-white/80 text-center drop-shadow-md">
                        前往我的收藏中
                      </p>
                      <p className="text-[12px] text-white/60 text-center mt-1 drop-shadow-sm">
                        查看更多收藏的笔记
                      </p>
                    </div>
                  </div>
                )}
              </>
            )}
          </div>
        </div>
      </div>

      {/* Personal Library Section */}
      <div>
        <h2 className="text-[20px] font-semibold text-white/60 uppercase tracking-wide mb-3 px-1 font-[Aclonica] text-[rgb(255,255,255)]">
          个人笔记库
        </h2>
        
        {/* My Favorites Card */}
        <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40 mb-4 scroll-mt-4" ref={favoritesCardRef}>
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
          
          <div className="relative">
            {/* My Favorites Section Header */}
            <button
              onClick={() => setIsFavoritesExpanded(!isFavoritesExpanded)}
              className="w-full flex items-center justify-between p-4 active:bg-white/10 transition-colors"
            >
              <div className="flex items-center gap-2">
                {isFavoritesExpanded ? (
                  <ChevronDown className="w-5 h-5 text-white/70 drop-shadow-sm" strokeWidth={2} />
                ) : (
                  <ChevronRight className="w-5 h-5 text-white/70 drop-shadow-sm" strokeWidth={2} />
                )}
                <span className="text-[15px] font-medium text-white drop-shadow-md">我的收藏</span>
              </div>
            </button>

            {/* Favorites Expandable list */}
            {isFavoritesExpanded && (
              <div className="border-t border-white/20 p-3">
                {favorites.size === 0 ? (
                  <div className="py-8 text-center">
                    <Star className="w-12 h-12 text-white/30 mx-auto mb-3" strokeWidth={1.5} />
                    <p className="text-[14px] text-white/50 drop-shadow-sm">暂无收藏的笔记</p>
                  </div>
                ) : (
                  <div className="space-y-3">
                    {/* Display favorited items with parent-child hierarchy */}
                    {personalLibrary.map((item) => {
                      // Check if this parent or any of its children are favorited
                      const hasAnyFavoritedChild = item.children?.some(child => favorites.has(child.id));
                      const isParentFavorited = favorites.has(item.id);
                      
                      // Show parent if it's favorited or if any child is favorited
                      if (isParentFavorited || hasAnyFavoritedChild) {
                        return (
                          <div key={item.id} className="space-y-2">
                            {/* Parent Item */}
                            <div 
                              onClick={() => toggleFolder(item.id)}
                              className="relative overflow-hidden bg-white/20 backdrop-blur-md rounded-[20px] p-3 shadow-lg border border-white/30 active:scale-[0.98] transition-transform cursor-pointer"
                            >
                              <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-white/5 to-transparent rounded-[20px] pointer-events-none" />
                              <div className="relative flex items-center gap-3">
                                {expandedFolders.has(item.id) ? (
                                  <ChevronDown className="w-4 h-4 text-white/70 flex-shrink-0 drop-shadow-sm" strokeWidth={2} />
                                ) : (
                                  <ChevronRight className="w-4 h-4 text-white/70 flex-shrink-0 drop-shadow-sm" strokeWidth={2} />
                                )}
                                <span className="text-lg">{item.icon}</span>
                                <span className="text-[15px] font-medium text-white drop-shadow-sm flex-1">
                                  {item.title}
                                </span>
                                <button
                                  onClick={(e) => toggleFavorite(e, item.id)}
                                  className="p-1.5 rounded-full hover:bg-white/20 transition-colors active:scale-95"
                                >
                                  <Star 
                                    className={`w-4 h-4 drop-shadow-sm transition-all ${
                                      isParentFavorited
                                        ? 'fill-yellow-300 text-yellow-300'
                                        : 'text-white/70'
                                    }`}
                                    strokeWidth={2}
                                  />
                                </button>
                              </div>
                            </div>
                            
                            {/* Child Items - only show favorited ones */}
                            {expandedFolders.has(item.id) && item.children && (
                              <div className="ml-6 space-y-2">
                                {item.children.map((child) => {
                                  if (favorites.has(child.id)) {
                                    return (
                                      <div
                                        key={child.id}
                                        className="relative overflow-hidden bg-white/15 backdrop-blur-md rounded-[15px] p-2.5 shadow-md border border-white/25 active:scale-[0.98] transition-transform cursor-pointer"
                                      >
                                        <div className="absolute inset-0 bg-gradient-to-br from-white/15 via-white/5 to-transparent rounded-[15px] pointer-events-none" />
                                        <div className="relative flex items-center gap-2">
                                          <span className="text-base">{child.icon}</span>
                                          <span className="text-[14px] text-white/90 drop-shadow-sm flex-1">
                                            {child.title}
                                          </span>
                                          <button
                                            onClick={(e) => toggleFavorite(e, child.id)}
                                            className="p-1 rounded-full hover:bg-white/20 transition-colors active:scale-95"
                                          >
                                            <Star className="w-3.5 h-3.5 fill-yellow-300 text-yellow-300 drop-shadow-sm" strokeWidth={2} />
                                          </button>
                                        </div>
                                      </div>
                                    );
                                  }
                                  return null;
                                })}
                              </div>
                            )}
                          </div>
                        );
                      }
                      return null;
                    })}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>

        {/* Private Library card container */}
        <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40">
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
          
          <div className="relative">
            {/* Private Section Header with dropdown */}
            <button
              onClick={() => setIsExpanded(!isExpanded)}
              className="w-full flex items-center justify-between p-4 active:bg-white/10 transition-colors"
            >
              <div className="flex items-center gap-2">
                {isExpanded ? (
                  <ChevronDown className="w-5 h-5 text-white/70 drop-shadow-sm" strokeWidth={2} />
                ) : (
                  <ChevronRight className="w-5 h-5 text-white/70 drop-shadow-sm" strokeWidth={2} />
                )}
                <span className="text-[15px] font-medium text-white drop-shadow-md">我的笔记</span>
              </div>
              <div 
                onClick={(e) => {
                  e.stopPropagation();
                  handleAddFolderClick('my-notes');
                }}
                className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-white/20 transition-colors active:scale-95 cursor-pointer"
              >
                <span className="text-white text-lg drop-shadow-md">+</span>
              </div>
            </button>

            {/* Expandable list */}
            {isExpanded && (
              <div className="border-t border-white/20 p-3 space-y-3">
                {personalLibrary.map((item) => (
                  <div key={item.id}>
                    {item.type === 'folder' ? (
                      // Parent folder - rounded card
                      <div className="space-y-2">
                        <div
                          onClick={() => toggleFolder(item.id)}
                          className="relative overflow-hidden bg-white/20 backdrop-blur-md rounded-[20px] p-3 shadow-lg border border-white/30 active:scale-[0.98] transition-transform cursor-pointer"
                        >
                          {/* Glass effect overlay */}
                          <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-white/5 to-transparent rounded-[20px] pointer-events-none" />
                          
                          <div className="relative flex items-center gap-3">
                            {expandedFolders.has(item.id) ? (
                              <ChevronDown className="w-4 h-4 text-white/70 flex-shrink-0 drop-shadow-sm" strokeWidth={2} />
                            ) : (
                              <ChevronRight className="w-4 h-4 text-white/70 flex-shrink-0 drop-shadow-sm" strokeWidth={2} />
                            )}
                            <span className="text-lg">{item.icon}</span>
                            <span className="text-[15px] font-medium text-white drop-shadow-sm flex-1">
                              {item.title}
                            </span>
                            {/* Action buttons */}
                            <div className="flex items-center gap-1">
                              <button
                                onClick={(e) => toggleFavorite(e, item.id)}
                                className="p-1.5 rounded-full hover:bg-white/20 transition-colors active:scale-95"
                              >
                                <Star
                                  className={`w-4 h-4 drop-shadow-sm transition-all ${
                                    favorites.has(item.id)
                                      ? 'fill-yellow-300 text-yellow-300'
                                      : 'text-white/70'
                                  }`}
                                  strokeWidth={2}
                                />
                              </button>
                              <button
                                onClick={(e) => handleMoreOptions(e, item.id)}
                                className="p-1.5 rounded-full hover:bg-white/20 transition-colors active:scale-95"
                              >
                                <MoreVertical className="w-4 h-4 text-white/70 drop-shadow-sm" strokeWidth={2} />
                              </button>
                            </div>
                          </div>
                        </div>
                        
                        {/* Child files - smaller rounded cards */}
                        {expandedFolders.has(item.id) && item.children && (
                          <div className="ml-6 space-y-2">
                            {item.children.map((child) => (
                              <div
                                key={child.id}
                                onClick={() => onLibraryNoteClick(child.id)}
                                className="relative overflow-hidden bg-white/15 backdrop-blur-md rounded-[15px] p-2.5 shadow-md border border-white/25 active:scale-[0.98] transition-transform cursor-pointer"
                              >
                                {/* Glass effect overlay */}
                                <div className="absolute inset-0 bg-gradient-to-br from-white/15 via-white/5 to-transparent rounded-[15px] pointer-events-none" />
                                
                                <div className="relative flex items-center gap-2">
                                  <span className="text-base">{child.icon}</span>
                                  <span className="text-[14px] text-white/90 drop-shadow-sm flex-1">
                                    {child.title}
                                  </span>
                                  {/* Action buttons for child items */}
                                  <div className="flex items-center gap-1">
                                    <button
                                      onClick={(e) => toggleFavorite(e, child.id)}
                                      className="p-1 rounded-full hover:bg-white/20 transition-colors active:scale-95"
                                    >
                                      <Star
                                        className={`w-3.5 h-3.5 drop-shadow-sm transition-all ${
                                          favorites.has(child.id)
                                            ? 'fill-yellow-300 text-yellow-300'
                                            : 'text-white/70'
                                        }`}
                                        strokeWidth={2}
                                      />
                                    </button>
                                    <button
                                      onClick={(e) => handleMoreOptions(e, child.id)}
                                      className="p-1 rounded-full hover:bg-white/20 transition-colors active:scale-95"
                                    >
                                      <MoreVertical className="w-3.5 h-3.5 text-white/70 drop-shadow-sm" strokeWidth={2} />
                                    </button>
                                  </div>
                                </div>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>
                    ) : (
                      // Regular item - simple list style
                      <div className="flex items-center gap-3 px-3 py-2 active:bg-white/10 rounded-[15px] transition-colors cursor-pointer">
                        <span className="text-lg">{item.icon}</span>
                        <span className="text-[15px] text-white truncate drop-shadow-sm">
                          {item.title}
                        </span>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Uncategorized Notes Card */}
        <div className="relative overflow-hidden bg-white/15 backdrop-blur-2xl rounded-[30px] shadow-2xl border border-white/40 mt-4">
          {/* Glass effect overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent rounded-[30px] pointer-events-none" />
          
          <div className="relative">
            {/* Uncategorized Section Header */}
            <button
              onClick={() => setIsUncategorizedExpanded(!isUncategorizedExpanded)}
              className="w-full flex items-center justify-between p-4 active:bg-white/10 transition-colors"
            >
              <div className="flex items-center gap-2">
                {isUncategorizedExpanded ? (
                  <ChevronDown className="w-5 h-5 text-white/70 drop-shadow-sm" strokeWidth={2} />
                ) : (
                  <ChevronRight className="w-5 h-5 text-white/70 drop-shadow-sm" strokeWidth={2} />
                )}
                <span className="text-[15px] font-medium text-white drop-shadow-md">未分类笔记</span>
              </div>
            </button>

            {/* Expandable list */}
            {isUncategorizedExpanded && (
              <div className="border-t border-white/20 p-3 space-y-3">
                {uncategorizedNotes.map((note) => (
                  <div key={note.id}>
                    <div
                      onClick={() => handleUncategorizedNoteClick(note.id)}
                      className="relative overflow-hidden bg-white/20 backdrop-blur-md rounded-[20px] p-3 shadow-lg border border-white/30 active:scale-[0.98] transition-transform cursor-pointer"
                    >
                      {/* Glass effect overlay */}
                      <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-white/5 to-transparent rounded-[20px] pointer-events-none" />
                      
                      <div className="relative flex items-center gap-3">
                        <span className="text-lg">{note.icon}</span>
                        <span className="text-[15px] font-medium text-white drop-shadow-sm flex-1">
                          {note.title}
                        </span>
                        {/* Delete button only */}
                        <button
                          onClick={(e) => toggleDeleteMark(e, note.id)}
                          className="p-1.5 rounded-full hover:bg-white/20 transition-colors active:scale-95"
                        >
                          <Trash2
                            className={`w-4 h-4 drop-shadow-sm transition-all ${
                              markedForDeletion.has(note.id)
                                ? 'fill-red-400 text-red-400'
                                : 'text-white/70'
                            }`}
                            strokeWidth={2}
                          />
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Toast Notification */}
      <Toast
        message={toastMessage}
        isVisible={showToast}
        onClose={() => setShowToast(false)}
      />

      {/* Action Sheet */}
      {actionSheetId && (
        <ActionSheet
          isOpen={true}
          onClose={() => setActionSheetId(null)}
          onFavorite={() => handleFavoriteFromSheet(actionSheetId)}
          onDelete={() => handleDeleteItem(actionSheetId)}
          isFavorited={favorites.has(actionSheetId)}
        />
      )}

      {/* Add Folder Sheet */}
      {addFolderSheetId && (
        <AddFolderSheet
          isOpen={true}
          onClose={() => setAddFolderSheetId(null)}
          onAddFolder={handleAddFolder}
        />
      )}

      {/* Category Sheet */}
      {categorySheetNoteId && (
        <CategorySheet
          isOpen={true}
          onClose={() => setCategorySheetNoteId(null)}
          onCategorySelect={handleSelectCategory}
          parentCategories={parentCategories}
        />
      )}
    </main>
  );
}