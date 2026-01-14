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
        
        NoteRow(
            note: Note(title: "示例笔记", icon: "📄"),
            isFavorited: false,
            onTap: {},
            onFavorite: {},
            onMore: {}
        )
        .padding()
    }
}
