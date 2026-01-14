//
//  DefaultFolderRow.swift
//  Notey
//
//  Created by 盐焗鸡 on 14/1/2026.
//

import SwiftUI

/// 默认文件夹行组件
/// 与 FolderRow 类似，但只有收藏星标，没有更多选项按钮
struct DefaultFolderRow: View {
    let folder: Folder
    let isExpanded: Bool
    let isFavorited: Bool
    let onTap: () -> Void
    let onFavorite: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            GlassCard {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 2)
                    
                    Text(folder.icon)
                        .font(.system(size: 18))
                        .padding(.top, 1)
                    
                    Text(folder.title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(isExpanded ? nil : 1)
                        .fixedSize(horizontal: false, vertical: isExpanded)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 只有收藏星标，没有更多选项按钮
                    Button(action: onFavorite) {
                        Image(systemName: isFavorited ? "star.fill" : "star")
                            .font(.system(size: 14))
                            .foregroundColor(isFavorited ? .yellow : .white.opacity(0.7))
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
        
        VStack(spacing: 16) {
            DefaultFolderRow(
                folder: Folder(id: "default", title: "默认文件夹", icon: "📁"),
                isExpanded: false,
                isFavorited: false,
                onTap: {},
                onFavorite: {}
            )
            
            DefaultFolderRow(
                folder: Folder(id: "default", title: "默认文件夹", icon: "📁"),
                isExpanded: true,
                isFavorited: true,
                onTap: {},
                onFavorite: {}
            )
        }
        .padding()
    }
}
