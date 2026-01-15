//
//  NoteRow.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct NoteRow: View {
    let note: Note
    let isFavorited: Bool
    var showFavoriteButton: Bool = true
    var isNewlyAdded: Bool = false // 是否是新添加的笔记
    let onTap: () -> Void
    let onFavorite: () -> Void
    let onMore: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            GlassCard {
                HStack(spacing: 12) {
                    Text(note.icon)
                        .font(.system(size: 18))
                    
                    Text(note.title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        // 新添加标记 - 绿色小圆点
                        if isNewlyAdded {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                        }
                        
                        if showFavoriteButton {
                            Button(action: onFavorite) {
                                Image(systemName: isFavorited ? "star.fill" : "star")
                                    .font(.system(size: 14))
                                    .foregroundColor(isFavorited ? .yellow : .white.opacity(0.7))
                            }
                        }
                        
                        Button(action: onMore) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                .padding(12)
            }
        }
        .buttonStyle(PlainButtonStyle())
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
        
        VStack(spacing: 12) {
            NoteRow(
                note: Note(title: "普通笔记", icon: "📄"),
                isFavorited: false,
                onTap: {},
                onFavorite: {},
                onMore: {}
            )
            
            NoteRow(
                note: Note(title: "新添加的笔记", icon: "📄"),
                isFavorited: false,
                isNewlyAdded: true,
                onTap: {},
                onFavorite: {},
                onMore: {}
            )
        }
        .padding()
    }
}
