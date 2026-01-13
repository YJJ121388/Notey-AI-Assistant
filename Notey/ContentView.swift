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
        Note(id: "unc-1", title: "随手记录 - 项目想法", icon: "📝"),
        Note(id: "unc-2", title: "临时笔记 - 会议记录", icon: "📝"),
        Note(id: "unc-3", title: "待整理 - 学习资料", icon: "📝"),
        Note(id: "unc-4", title: "灵感备忘录", icon: "💡"),
        Note(id: "unc-5", title: "读书笔记 - 设计心理学", icon: "📚"),
        Note(id: "unc-6", title: "旅行计划草稿", icon: "✈️")
    ]
    @State private var personalLibrary: [Folder] = [
        Folder(id: "1", title: "Interview", icon: "📁", children: [
            Note(id: "1-1", title: "Technical Interview Notes", icon: "📄"),
            Note(id: "1-2", title: "Behavioral Questions", icon: "📄"),
            Note(id: "1-3", title: "Company Research", icon: "📄"),
            Note(id: "1-4", title: "Salary Negotiation Tips", icon: "💰")
        ]),
        Folder(id: "2", title: "TERM 2", icon: "📚", children: [
            Note(id: "2-1", title: "Lecture Notes - Week 1", icon: "📄"),
            Note(id: "2-2", title: "Lecture Notes - Week 2", icon: "📄"),
            Note(id: "2-3", title: "Assignment Ideas", icon: "📄"),
            Note(id: "2-4", title: "Group Project Plan", icon: "👥"),
            Note(id: "2-5", title: "Exam Preparation", icon: "📝")
        ]),
        Folder(id: "3", title: "Enhancement", icon: "⚡", children: [
            Note(id: "3-1", title: "UI Improvements", icon: "🎨"),
            Note(id: "3-2", title: "Feature Requests", icon: "✨"),
            Note(id: "3-3", title: "Bug Fixes", icon: "🐛")
        ]),
        Folder(id: "4", title: "神经网络学习", icon: "🧠", children: [
            Note(id: "4-1", title: "YOLO模型与CNN", icon: "📄"),
            Note(id: "4-2", title: "反向传播算法", icon: "📄"),
            Note(id: "4-3", title: "激活函数对比", icon: "📊")
        ]),
        Folder(id: "5", title: "健身计划", icon: "💪", children: [
            Note(id: "5-1", title: "周一 - 胸部训练", icon: "🏋️"),
            Note(id: "5-2", title: "周三 - 背部训练", icon: "🏋️"),
            Note(id: "5-3", title: "周五 - 腿部训练", icon: "🏋️"),
            Note(id: "5-4", title: "饮食计划", icon: "🥗")
        ]),
        Folder(id: "6", title: "读书笔记", icon: "📖", children: [
            Note(id: "6-1", title: "设计心理学 - 第一章", icon: "📄"),
            Note(id: "6-2", title: "人类简史 - 读后感", icon: "📄"),
            Note(id: "6-3", title: "代码大全 - 重点摘录", icon: "💻")
        ]),
        Folder(id: "7", title: "旅行规划", icon: "🗺️", children: [
            Note(id: "7-1", title: "日本旅行攻略", icon: "🗾"),
            Note(id: "7-2", title: "欧洲行程安排", icon: "🏰"),
            Note(id: "7-3", title: "旅行装备清单", icon: "🎒")
        ]),
        Folder(id: "8", title: "美食记录", icon: "🍜", children: [
            Note(id: "8-1", title: "川菜菜谱", icon: "🌶️"),
            Note(id: "8-2", title: "烘焙笔记", icon: "🍰"),
            Note(id: "8-3", title: "餐厅推荐", icon: "⭐")
        ])
    ]
    @State private var draftNotes: [DraftNote] = [
        DraftNote(id: "4", title: "UX Workshop Notes", summary: "Brainstorming session on improving user onboarding experience", timestamp: "Yesterday", videoUrl: "https://example.com/video/ux-workshop"),
        DraftNote(id: "5", title: "Marketing Strategy Call", summary: "Q1 campaign planning and budget allocation discussion", timestamp: "Jan 7", videoUrl: "https://example.com/video/marketing-call"),
        DraftNote(id: "6", title: "Engineering Sync", summary: "Technical architecture review and performance optimization", timestamp: "Jan 6", videoUrl: "https://example.com/video/engineering-sync")
    ]
    @State private var selectedDraft: DraftNote? = nil
    @State private var selectedNote: Note? = nil
    @State private var showAIConfig = false
    @State private var showNotificationSettings = false
    @State private var showDataManagement = false
    @State private var showAbout = false
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
        
        // 找到文件夹
        guard let folderIndex = personalLibrary.firstIndex(where: { $0.id == folderId }) else {
            print("❌ 未找到文件夹")
            return
        }
        
        print("✅ 找到文件夹: \(personalLibrary[folderIndex].title)")
        
        // 添加笔记到文件夹
        if personalLibrary[folderIndex].children == nil {
            personalLibrary[folderIndex].children = []
        }
        personalLibrary[folderIndex].children?.append(note)
        print("✅ 添加成功，文件夹子笔记数: \(personalLibrary[folderIndex].children?.count ?? 0)")
        
        // 从未分类笔记中移除
        uncategorizedNotes.remove(at: noteIndex)
        print("✅ 移除成功，剩余未分类笔记: \(uncategorizedNotes.count)")
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
                        onNoteClick: { noteId in
                            activeTab = .notes
                        },
                        onDraftClick: { draftId in
                            selectedDraft = draftNotes.first { $0.id == draftId }
                        }
                    )
                } else if activeTab == .notes {
                    LibraryView(
                        personalLibrary: $personalLibrary,
                        uncategorizedNotes: $uncategorizedNotes,
                        onMoveNoteToFolder: moveNoteToFolder,
                        onDeleteNote: deleteNote,
                        onLibraryNoteClick: { noteId in
                            if let folder = personalLibrary.first(where: { $0.children?.contains(where: { $0.id == noteId }) ?? false }) {
                                selectedNote = folder.children?.first { $0.id == noteId }
                            }
                        },
                        onUncategorizedNoteClick: { noteId in
                            // Handle uncategorized note click
                        }
                    )
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
