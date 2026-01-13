//
//  FolderRow.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct FolderRow: View {
    let folder: Folder
    let isExpanded: Bool
    let isFavorited: Bool
    let onTap: () -> Void
    let onFavorite: () -> Void
    let onMore: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            GlassCard {
                HStack(spacing: 12) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(folder.icon)
                        .font(.system(size: 18))
                    
                    Text(folder.title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: onFavorite) {
                            Image(systemName: isFavorited ? "star.fill" : "star")
                                .font(.system(size: 14))
                                .foregroundColor(isFavorited ? .yellow : .white.opacity(0.7))
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
        
        FolderRow(
            folder: Folder(title: "示例文件夹", icon: "📁"),
            isExpanded: false,
            isFavorited: false,
            onTap: {},
            onFavorite: {},
            onMore: {}
        )
        .padding()
    }
}
