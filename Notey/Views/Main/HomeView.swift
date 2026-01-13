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
    let onNoteClick: (String) -> Void
    let onDraftClick: (String) -> Void
    
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
                
                // Recent Notes Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("最近笔记")
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
                        ForEach(uncategorizedNotes) { note in
                            Button(action: { onNoteClick(note.id) }) {
                                NoteCardView(
                                    title: note.title,
                                    summary: "点击为此笔记选择分类",
                                    timestamp: "未分类",
                                    type: .recorded
                                )
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
                    if type == .draft {
                        Text("这篇笔记录入失败了，请点击查看")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.85))
                            .lineSpacing(2)
                    } else {
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
            onNoteClick: { _ in },
            onDraftClick: { _ in }
        )
    }
}
