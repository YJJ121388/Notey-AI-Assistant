//
//  ContentView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: Tab = .recent
    @State private var uncategorizedNotes: [Note] = [
        Note(id: "unc-1", title: "随手记录 - 项目想法", icon: "📝", videoUrl: "https://example.com/video/project-idea"),
        Note(id: "unc-2", title: "临时笔记 - 会议记录", icon: "📝", videoUrl: "https://example.com/video/meeting-notes"),
        Note(id: "unc-3", title: "待整理 - 学习资料", icon: "📝", videoUrl: "https://example.com/video/study-materials"),
        Note(id: "unc-4", title: "灵感备忘录", icon: "💡", videoUrl: "https://example.com/video/inspiration"),
        Note(id: "unc-5", title: "读书笔记 - 设计心理学", icon: "📚", videoUrl: "https://example.com/video/book-notes"),
        Note(id: "unc-6", title: "旅行计划草稿", icon: "✈️", videoUrl: "https://example.com/video/travel-plan")
    ]
    @State private var personalLibrary: [Folder] = [
        Folder(id: "1", title: "Interview", icon: "📁", children: [
            Note(id: "1-1", title: "Technical Interview Notes", icon: "📄", videoUrl: "https://example.com/video/tech-interview"),
            Note(id: "1-2", title: "Behavioral Questions", icon: "📄", videoUrl: "https://example.com/video/behavioral"),
            Note(id: "1-3", title: "Company Research", icon: "📄", videoUrl: "https://example.com/video/company-research"),
            Note(id: "1-4", title: "Salary Negotiation Tips", icon: "💰", videoUrl: "https://example.com/video/salary-tips")
        ]),
        Folder(id: "2", title: "TERM 2", icon: "📚", children: [
            Note(id: "2-1", title: "Lecture Notes - Week 1", icon: "📄", videoUrl: "https://example.com/video/lecture-week1"),
            Note(id: "2-2", title: "Lecture Notes - Week 2", icon: "📄", videoUrl: "https://example.com/video/lecture-week2"),
            Note(id: "2-3", title: "Assignment Ideas", icon: "📄", videoUrl: "https://example.com/video/assignment"),
            Note(id: "2-4", title: "Group Project Plan", icon: "👥", videoUrl: "https://example.com/video/group-project"),
            Note(id: "2-5", title: "Exam Preparation", icon: "📝", videoUrl: "https://example.com/video/exam-prep")
        ]),
        Folder(id: "3", title: "Enhancement", icon: "⚡", children: [
            Note(id: "3-1", title: "UI Improvements", icon: "🎨", videoUrl: "https://example.com/video/ui-improvements"),
            Note(id: "3-2", title: "Feature Requests", icon: "✨", videoUrl: "https://example.com/video/features"),
            Note(id: "3-3", title: "Bug Fixes", icon: "🐛", videoUrl: "https://example.com/video/bug-fixes")
        ]),
        Folder(id: "4", title: "神经网络学习", icon: "🧠", children: [
            Note(id: "4-1", title: "YOLO模型与CNN", icon: "📄", videoUrl: "https://example.com/video/yolo-cnn"),
            Note(id: "4-2", title: "反向传播算法", icon: "📄", videoUrl: "https://example.com/video/backprop"),
            Note(id: "4-3", title: "激活函数对比", icon: "📊", videoUrl: "https://example.com/video/activation")
        ]),
        Folder(id: "5", title: "健身计划", icon: "💪", children: [
            Note(id: "5-1", title: "周一 - 胸部训练", icon: "🏋️", videoUrl: "https://example.com/video/chest-workout"),
            Note(id: "5-2", title: "周三 - 背部训练", icon: "🏋️", videoUrl: "https://example.com/video/back-workout"),
            Note(id: "5-3", title: "周五 - 腿部训练", icon: "🏋️", videoUrl: "https://example.com/video/leg-workout"),
            Note(id: "5-4", title: "饮食计划", icon: "🥗", videoUrl: "https://example.com/video/diet-plan")
        ]),
        Folder(id: "6", title: "读书笔记", icon: "📖", children: [
            Note(id: "6-1", title: "设计心理学 - 第一章", icon: "📄", videoUrl: "https://example.com/video/design-psychology"),
            Note(id: "6-2", title: "人类简史 - 读后感", icon: "📄", videoUrl: "https://example.com/video/sapiens"),
            Note(id: "6-3", title: "代码大全 - 重点摘录", icon: "💻", videoUrl: "https://example.com/video/code-complete")
        ]),
        Folder(id: "7", title: "旅行规划", icon: "🗺️", children: [
            Note(id: "7-1", title: "日本旅行攻略", icon: "🗾", videoUrl: "https://example.com/video/japan-travel"),
            Note(id: "7-2", title: "欧洲行程安排", icon: "🏰", videoUrl: "https://example.com/video/europe-trip"),
            Note(id: "7-3", title: "旅行装备清单", icon: "🎒", videoUrl: "https://example.com/video/travel-gear")
        ]),
        Folder(id: "8", title: "美食记录", icon: "🍜", children: [
            Note(id: "8-1", title: "川菜菜谱", icon: "🌶️", videoUrl: "https://example.com/video/sichuan-cuisine"),
            Note(id: "8-2", title: "烘焙笔记", icon: "🍰", videoUrl: "https://example.com/video/baking"),
            Note(id: "8-3", title: "餐厅推荐", icon: "⭐", videoUrl: "https://example.com/video/restaurant-review")
        ])
    ]
    @State private var recentlyClassifiedNotes: [Note] = [] // 最近分类的笔记
    @State private var draftNotes: [DraftNote] = [
        DraftNote(id: "4", title: "UX Workshop Notes", summary: "Brainstorming session on improving user onboarding experience", timestamp: "Yesterday", videoUrl: "https://example.com/video/ux-workshop"),
        DraftNote(id: "5", title: "Marketing Strategy Call", summary: "Q1 campaign planning and budget allocation discussion", timestamp: "Jan 7", videoUrl: "https://example.com/video/marketing-call"),
        DraftNote(id: "6", title: "Engineering Sync", summary: "Technical architecture review and performance optimization", timestamp: "Jan 6", videoUrl: "https://example.com/video/engineering-sync")
    ]
    @State private var defaultFolder: Folder = Folder(id: "default-folder", title: "默认文件夹", icon: "📁", children: [])
    @State private var selectedDraft: DraftNote? = nil
    @State private var selectedNote: Note? = nil
    @State private var showAIConfig = false
    @State private var showNotificationSettings = false
    @State private var showDataManagement = false
    @State private var showAbout = false
    @State private var scrollToUncategorized = false // 是否滚动到未分类区域
    @State private var expandFolderId: String? = nil // 需要展开的文件夹 ID
    @State private var newlyAddedNoteIds: Set<String> = [] // 新添加的笔记 ID 集合
    @StateObject private var toastManager = ToastManager()
    
    // 移动笔记到文件夹的函数
    private func moveNoteToFolder(noteId: String, folderId: String) {
        print("📦 ContentView: 移动笔记 \(noteId) 到文件夹 \(folderId)")
        
        // 找到笔记
        guard let noteIndex = uncategorizedNotes.firstIndex(where: { $0.id == noteId }) else {
            print("❌ 未找到笔记")
            return
        }
        
        let note = uncategorizedNotes[noteIndex]
        print("✅ 找到笔记: \(note.title)")
        
        var folderTitle: String = ""
        
        // 检查是否是默认文件夹
        if folderId == defaultFolder.id {
            folderTitle = defaultFolder.title
            print("✅ 找到默认文件夹: \(folderTitle)")
            
            // 添加笔记到默认文件夹
            if defaultFolder.children == nil {
                defaultFolder.children = []
            }
            defaultFolder.children?.append(note)
            print("✅ 添加成功，默认文件夹子笔记数: \(defaultFolder.children?.count ?? 0)")
        } else {
            // 找到普通文件夹
            guard let folderIndex = personalLibrary.firstIndex(where: { $0.id == folderId }) else {
                print("❌ 未找到文件夹")
                return
            }
            
            folderTitle = personalLibrary[folderIndex].title
            print("✅ 找到文件夹: \(folderTitle)")
            
            // 添加笔记到文件夹
            if personalLibrary[folderIndex].children == nil {
                personalLibrary[folderIndex].children = []
            }
            personalLibrary[folderIndex].children?.append(note)
            print("✅ 添加成功，文件夹子笔记数: \(personalLibrary[folderIndex].children?.count ?? 0)")
        }
        
        // 从未分类笔记中移除
        uncategorizedNotes.remove(at: noteIndex)
        print("✅ 移除成功，剩余未分类笔记: \(uncategorizedNotes.count)")
        
        // 添加到最近分类笔记列表（插入到开头）
        recentlyClassifiedNotes.insert(note, at: 0)
        // 只保留最多8个
        if recentlyClassifiedNotes.count > 8 {
            recentlyClassifiedNotes = Array(recentlyClassifiedNotes.prefix(8))
        }
        print("✅ 添加到最近笔记，当前数量: \(recentlyClassifiedNotes.count)")
        
        // 设置需要展开的文件夹 ID
        expandFolderId = folderId
        
        // 标记为新添加的笔记
        newlyAddedNoteIds.insert(noteId)
        
        // 显示分类成功提示
        toastManager.show("分类归档成功，已归档至「\(folderTitle)」")
    }
    
    // 删除笔记的函数
    private func deleteNote(noteId: String) {
        print("🗑️ ContentView: 删除笔记 \(noteId)")
        
        // 先检查是否是文件夹
        if let folderIndex = personalLibrary.firstIndex(where: { $0.id == noteId }) {
            // 删除文件夹
            let folderTitle = personalLibrary[folderIndex].title
            personalLibrary.remove(at: folderIndex)
            print("✅ 删除文件夹成功: \(folderTitle)")
            toastManager.show("文件夹「\(folderTitle)」已删除")
            return
        }
        
        // 检查默认文件夹中的笔记
        if let children = defaultFolder.children,
           let noteIndex = children.firstIndex(where: { $0.id == noteId }) {
            let noteTitle = children[noteIndex].title
            defaultFolder.children?.remove(at: noteIndex)
            print("✅ 从默认文件夹中删除笔记: \(noteTitle)")
            toastManager.show("笔记「\(noteTitle)」已删除")
            return
        }
        
        // 在所有文件夹中查找并删除笔记
        for (folderIndex, folder) in personalLibrary.enumerated() {
            if let children = folder.children,
               let noteIndex = children.firstIndex(where: { $0.id == noteId }) {
                let noteTitle = children[noteIndex].title
                personalLibrary[folderIndex].children?.remove(at: noteIndex)
                print("✅ 从文件夹 \(folder.title) 中删除笔记: \(noteTitle)")
                toastManager.show("笔记「\(noteTitle)」已删除")
                return
            }
        }
        
        // 检查未分类笔记
        if let noteIndex = uncategorizedNotes.firstIndex(where: { $0.id == noteId }) {
            let noteTitle = uncategorizedNotes[noteIndex].title
            uncategorizedNotes.remove(at: noteIndex)
            print("✅ 从未分类笔记中删除: \(noteTitle)")
            toastManager.show("笔记「\(noteTitle)」已删除")
            return
        }
        
        print("❌ 未找到要删除的笔记")
    }
    
    // 在文件夹之间移动笔记
    private func moveNoteBetweenFolders(noteId: String, fromFolderId: String, toFolderId: String) {
        print("📦 ContentView: 移动笔记 \(noteId) 从 \(fromFolderId) 到 \(toFolderId)")
        
        // 如果源和目标相同，不做任何操作
        if fromFolderId == toFolderId {
            print("⚠️ 源文件夹和目标文件夹相同，跳过")
            return
        }
        
        var note: Note?
        var targetFolderTitle: String = ""
        
        // 从源文件夹中找到并移除笔记
        if fromFolderId == defaultFolder.id {
            // 从默认文件夹移除
            if let noteIndex = defaultFolder.children?.firstIndex(where: { $0.id == noteId }) {
                note = defaultFolder.children?[noteIndex]
                defaultFolder.children?.remove(at: noteIndex)
                print("✅ 从默认文件夹移除笔记")
            }
        } else {
            // 从普通文件夹移除
            if let folderIndex = personalLibrary.firstIndex(where: { $0.id == fromFolderId }),
               let noteIndex = personalLibrary[folderIndex].children?.firstIndex(where: { $0.id == noteId }) {
                note = personalLibrary[folderIndex].children?[noteIndex]
                personalLibrary[folderIndex].children?.remove(at: noteIndex)
                print("✅ 从文件夹 \(personalLibrary[folderIndex].title) 移除笔记")
            }
        }
        
        guard let noteToMove = note else {
            print("❌ 未找到要移动的笔记")
            return
        }
        
        // 添加到目标文件夹
        if toFolderId == defaultFolder.id {
            // 添加到默认文件夹
            if defaultFolder.children == nil {
                defaultFolder.children = []
            }
            defaultFolder.children?.append(noteToMove)
            targetFolderTitle = defaultFolder.title
            print("✅ 添加到默认文件夹")
        } else {
            // 添加到普通文件夹
            if let folderIndex = personalLibrary.firstIndex(where: { $0.id == toFolderId }) {
                if personalLibrary[folderIndex].children == nil {
                    personalLibrary[folderIndex].children = []
                }
                personalLibrary[folderIndex].children?.append(noteToMove)
                targetFolderTitle = personalLibrary[folderIndex].title
                print("✅ 添加到文件夹 \(targetFolderTitle)")
            }
        }
        
        // 设置需要展开的文件夹
        expandFolderId = toFolderId
        
        // 标记为新添加的笔记
        newlyAddedNoteIds.insert(noteId)
        
        // 显示移动成功提示
        toastManager.show("已移动至「\(targetFolderTitle)」")
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.noteyBackgroundStart, Color.noteyBackgroundEnd],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Decorative blobs
            BackgroundBlobsView()
            
            // Content
            Group {
                if activeTab == .recent {
                    HomeView(
                        uncategorizedNotes: $uncategorizedNotes,
                        draftNotes: $draftNotes,
                        personalLibrary: $personalLibrary,
                        defaultFolder: $defaultFolder,
                        onNoteClick: { noteId in
                            activeTab = .notes
                        },
                        onDraftClick: { draftId in
                            selectedDraft = draftNotes.first { $0.id == draftId }
                        },
                        onMoveNoteToFolder: moveNoteToFolder,
                        onViewAllUncategorized: {
                            scrollToUncategorized = true
                            activeTab = .notes
                        }
                    )
                } else if activeTab == .notes {
                    LibraryView(
                        personalLibrary: $personalLibrary,
                        uncategorizedNotes: $uncategorizedNotes,
                        recentlyClassifiedNotes: $recentlyClassifiedNotes,
                        defaultFolder: $defaultFolder,
                        onMoveNoteToFolder: moveNoteToFolder,
                        onMoveNoteBetweenFolders: moveNoteBetweenFolders,
                        onDeleteNote: deleteNote,
                        scrollToUncategorized: scrollToUncategorized,
                        expandFolderId: $expandFolderId,
                        newlyAddedNoteIds: $newlyAddedNoteIds,
                        onLibraryNoteClick: { noteId in
                            // 移除新添加标记
                            newlyAddedNoteIds.remove(noteId)
                            
                            // 先检查默认文件夹
                            if let note = defaultFolder.children?.first(where: { $0.id == noteId }) {
                                selectedNote = note
                                return
                            }
                            // 再检查其他文件夹
                            if let folder = personalLibrary.first(where: { $0.children?.contains(where: { $0.id == noteId }) ?? false }) {
                                selectedNote = folder.children?.first { $0.id == noteId }
                            }
                        },
                        onUncategorizedNoteClick: { noteId in
                            // Handle uncategorized note click
                        }
                    )
                    .onDisappear {
                        // 离开 LibraryView 时重置滚动状态
                        scrollToUncategorized = false
                    }
                } else if activeTab == .settings {
                    SettingsView { itemId in
                        if itemId == "1" {
                            showAIConfig = true
                        } else if itemId == "2" {
                            showNotificationSettings = true
                        } else if itemId == "3" {
                            showDataManagement = true
                        } else if itemId == "4" {
                            showAbout = true
                        }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                // Tab Bar - 使用 overlay 确保始终在最上层，不会被内容遮挡
                TabBar(activeTab: $activeTab) { tab in
                    activeTab = tab
                }
                .padding(.bottom, 0) // 紧贴 Safe Area 边界，自然坐在 Home Indicator 上方
                .zIndex(999) // 确保 TabBar 在最顶层
            }
        }
        .fullScreenCover(item: $selectedDraft) { draft in
            DraftDetailView(
                draft: draft,
                onBack: { selectedDraft = nil },
                onDelete: { id in
                    draftNotes.removeAll { $0.id == id }
                    selectedDraft = nil
                    toastManager.show("草稿已删除")
                },
                onRetry: { id in
                    toastManager.show("正在重新记录...")
                    selectedDraft = nil
                }
            )
        }
        .fullScreenCover(item: $selectedNote) { note in
            NoteDetailView(
                note: note,
                onBack: { selectedNote = nil },
                onSave: { noteId, title, content in
                    if let index = personalLibrary.firstIndex(where: { $0.children?.contains(where: { $0.id == noteId }) ?? false }) {
                        if let childIndex = personalLibrary[index].children?.firstIndex(where: { $0.id == noteId }) {
                            personalLibrary[index].children?[childIndex].title = title
                            personalLibrary[index].children?[childIndex].content = content
                        }
                    }
                    selectedNote?.title = title
                    selectedNote?.content = content
                    toastManager.show("笔记已保存")
                }
            )
        }
        .fullScreenCover(isPresented: $showAIConfig) {
            QuotaDetailView(onBack: { showAIConfig = false })
        }
        .fullScreenCover(isPresented: $showNotificationSettings) {
            NotificationSettingsView(onBack: { showNotificationSettings = false })
        }
        .fullScreenCover(isPresented: $showDataManagement) {
            DataManagementView(onBack: { showDataManagement = false })
        }
        .fullScreenCover(isPresented: $showAbout) {
            HelpView(onBack: { showAbout = false })
        }
        .overlay {
            ToastView(message: toastManager.message, isVisible: $toastManager.isVisible)
                .zIndex(1000) // 确保在最顶层
        }
    }
}

#Preview {
    ContentView()
}
