//
//  CategorySheetView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct CategorySheetView: View {
    @Environment(\.dismiss) var dismiss
    let categories: [CategoryItem]
    let onSelectCategory: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Drag Indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(.white.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            // Categories List
            if categories.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "folder.badge.plus")
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.4))
                    
                    Text("暂无文件夹")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("请先在「我的笔记」中创建文件夹")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .padding(.bottom, 20)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(categories) { category in
                            Button(action: {
                                onSelectCategory(category.id)
                                dismiss()
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white.opacity(0.25))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.white.opacity(0.5), lineWidth: 1.5)
                                        }
                                        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
                                    
                                    HStack(spacing: 12) {
                                        Text(category.icon)
                                            .font(.system(size: 24))
                                        
                                        Text(category.title)
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .frame(height: 60)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .scrollIndicators(.hidden)
            }
        }
        .presentationBackground {
            ZStack {
                // 更深的背景，增强对比度
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.black.opacity(0.4))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.2),
                                        .white.opacity(0.05),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.white.opacity(0.5), lineWidth: 1.5)
                    }
                    .shadow(color: .black.opacity(0.3), radius: 25, x: 0, y: 12)
            }
        }
        .presentationDetents([.height(calculateSheetHeight())])
        .presentationDragIndicator(.hidden)
    }
    
    // 根据分类数量动态计算 sheet 高度
    private func calculateSheetHeight() -> CGFloat {
        let dragIndicatorHeight: CGFloat = 28 // 拖动指示器高度
        let itemHeight: CGFloat = 60 // 每个分类项的高度
        let spacing: CGFloat = 12 // 项之间的间距
        let bottomPadding: CGFloat = 20 // 底部内边距
        let emptyStateHeight: CGFloat = 176 // 空状态内容高度
        let maxVisibleItems: Int = 4 // 最多显示 4 个文件夹
        
        if categories.isEmpty {
            // 空状态：拖动指示器 + 空状态内容
            return dragIndicatorHeight + emptyStateHeight
        }
        
        // 计算实际显示的项数（最多 4 个）
        let visibleItemCount = min(categories.count, maxVisibleItems)
        
        // 有内容：拖动指示器 + 内容区域（最多 4 个项）
        let itemsHeight = (CGFloat(visibleItemCount) * itemHeight) + (CGFloat(max(0, visibleItemCount - 1)) * spacing)
        let totalHeight = dragIndicatorHeight + itemsHeight + bottomPadding
        
        return totalHeight
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
        
        CategorySheetView(
            categories: [
                CategoryItem(id: "1", title: "Interview", icon: "📁"),
                CategoryItem(id: "2", title: "TERM 2", icon: "📁"),
                CategoryItem(id: "3", title: "神经网络学习", icon: "🧠")
            ],
            onSelectCategory: { _ in }
        )
    }
}
