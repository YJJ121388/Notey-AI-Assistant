//
//  HomeView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct HomeView: View {
    @Binding var uncategorizedNotes: [Note]
    @Binding var draftNotes: [DraftNote]
    @Binding var personalLibrary: [Folder] // 改为 Binding 以支持添加文件夹
    @Binding var defaultFolder: Folder // 默认文件夹
    let onNoteClick: (String) -> Void
    let onDraftClick: (String) -> Void
    let onMoveNoteToFolder: (String, String) -> Void // 添加分类回调
    let onViewAllUncategorized: () -> Void // 查看全部未分类笔记
    
    @State private var categorySheetNoteId: String? = nil // 分类弹窗状态
    
    // 格式化时间戳
    private func formatTimestamp(_ date: Date?) -> String {
        guard let date = date else { return "刚刚" }
        
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return "今天 \(formatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            return "昨天"
        } else {
            let components = calendar.dateComponents([.day], from: date, to: now)
            if let days = components.day, days < 7 {
                return "\(days)天前"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM月dd日"
                return formatter.string(from: date)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header - Notey Logo
                HStack {
                    Text("Notey")
                        .font(.aclonica(size: 64))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    
                    Spacer()
                }
                .padding(.horizontal, 4)
                .padding(.top, 20)
                .padding(.bottom, 8)
                
                // Recent Uncategorized Notes Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("最近记录的未分类笔记")
                        .font(.aclonica(size: 20))
                        .foregroundColor(.white.opacity(0.6))
                        .textCase(.uppercase)
                        .tracking(0.5)
                        .padding(.horizontal, 4)
                    
                    if uncategorizedNotes.isEmpty {
                        Text("暂无未分类的笔记")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                    } else {
                        // 只显示最近 6 条
                        ForEach(Array(uncategorizedNotes.prefix(6))) { note in
                            Button(action: { categorySheetNoteId = note.id }) {
                                NoteCardView(
                                    title: note.title,
                                    summary: "点击为此笔记选择分类",
                                    timestamp: formatTimestamp(note.createdAt),
                                    type: .recorded
                                )
                            }
                        }
                        
                        // 提示卡片 - 可点击跳转到 LibraryView
                        Button(action: { onViewAllUncategorized() }) {
                            GlassCard {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(.white.opacity(0.2))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                                            }
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "arrow.right.circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    
                                    Text("过往记录但未归档笔记可以在我的笔记页面的未分类笔记库中查看哦")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                        .lineSpacing(3)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                .padding(16)
                            }
                        }
                    }
                }
                
                // Draft Notes Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("草稿箱 / 未录入笔记")
                        .font(.aclonica(size: 20))
                        .foregroundColor(.white.opacity(0.6))
                        .textCase(.uppercase)
                        .tracking(0.5)
                        .padding(.horizontal, 4)
                    
                    if draftNotes.isEmpty {
                        Text("暂无失败的笔记")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                    } else {
                        ForEach(draftNotes) { draft in
                            Button(action: { onDraftClick(draft.id) }) {
                                NoteCardView(
                                    title: draft.title,
                                    summary: draft.summary,
                                    timestamp: draft.timestamp,
                                    type: .draft
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 150) // 为 TabBar 留出足够空间，防止遮挡
        }
        .scrollIndicators(.hidden)
        .sheet(item: Binding(
            get: { categorySheetNoteId.map { CategorySheetItem(id: $0) } },
            set: { categorySheetNoteId = $0?.id }
        )) { item in
            CategorySheetView(
                categories: [CategoryItem(id: defaultFolder.id, title: defaultFolder.title, icon: defaultFolder.icon)] + personalLibrary.map { CategoryItem(id: $0.id, title: $0.title, icon: $0.icon) },
                onSelectCategory: { categoryId in
                    onMoveNoteToFolder(item.id, categoryId)
                    categorySheetNoteId = nil
                },
                onAddFolder: { name in
                    let newFolder = Folder(
                        title: name,
                        icon: "📁",
                        children: []
                    )
                    personalLibrary.insert(newFolder, at: 0)
                }
            )
        }
    }
}

struct NoteCardView: View {
    let title: String
    let summary: String
    let timestamp: String
    let type: NoteCardType
    
    enum NoteCardType {
        case recorded
        case draft
    }
    
    var body: some View {
        GlassCard {
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white.opacity(0.35))
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white.opacity(0.5), lineWidth: 1)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 8)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: type == .recorded ? "note.text" : "bell")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(timestamp)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    if type == .draft {
                        Text("这篇笔记录入失败了，请点击查看")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.85))
                            .lineSpacing(2)
                    } else {
                        Text(summary)
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.85))
                            .lineLimit(2)
                            .lineSpacing(2)
                    }
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.noteyBackgroundStart, Color.noteyBackgroundEnd],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        BackgroundBlobsView()
        
        HomeView(
            uncategorizedNotes: .constant([
                Note(id: "unc-1", title: "随手记录 - 项目想法", icon: "📝"),
                Note(id: "unc-2", title: "临时笔记 - 会议记录", icon: "📝")
            ]),
            draftNotes: .constant([
                DraftNote(id: "4", title: "UX Workshop Notes", summary: "Brainstorming session on improving user onboarding experience", timestamp: "Yesterday")
            ]),
            personalLibrary: .constant([
                Folder(title: "工作笔记", icon: "💼"),
                Folder(title: "学习资料", icon: "📚")
            ]),
            defaultFolder: .constant(Folder(id: "default-folder", title: "默认文件夹", icon: "📁", children: [])),
            onNoteClick: { _ in },
            onDraftClick: { _ in },
            onMoveNoteToFolder: { _, _ in },
            onViewAllUncategorized: { }
        )
    }
}
