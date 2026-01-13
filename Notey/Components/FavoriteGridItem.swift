//
//  FavoriteGridItem.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct FavoriteGridItem: View {
    let note: Note
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            GlassCard {
                VStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.35))
                            .overlay {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(.white.opacity(0.5), lineWidth: 1)
                            }
                            .shadow(color: .black.opacity(0.1), radius: 8)
                        
                        Image(systemName: "doc.text")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    .frame(width: 48, height: 48)
                    
                    Text(note.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                .padding(16)
            }
        }
        .frame(width: 160, height: 160)
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
        
        FavoriteGridItem(
            note: Note(title: "收藏的笔记", icon: "📄"),
            onTap: {}
        )
    }
}
