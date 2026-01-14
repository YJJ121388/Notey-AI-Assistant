//
//  CategorySheetView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct CategorySheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var localCategories: [CategoryItem]
    @State private var showAddFolderSheet = false
    let onSelectCategory: (String) -> Void
    let onAddFolder: ((String) -> Void)?
    
    init(categories: [CategoryItem], onSelectCategory: @escaping (String) -> Void, onAddFolder: ((String) -> Void)? = nil) {
        self._localCategories = State(initialValue: categories)
        self.onSelectCategory = onSelectCategory
        self.onAddFolder = onAddFolder
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Drag Indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(.white.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            // Categories List
            ScrollView {
                VStack(spacing: 12) {
                    // 新建文件夹按钮
                    Button(action: {
                        showAddFolderSheet = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.opacity(0.15))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white.opacity(0.4), lineWidth: 1.5)
                                }
                                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
                            
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                
                                Text("新建文件夹")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(height: 60)
                    }
                    
                    // 分隔线
                    if !localCategories.isEmpty {
                        Rectangle()
                            .fill(.white.opacity(0.2))
                            .frame(height: 1)
                            .padding(.vertical, 4)
                    }
                    
                    // 文件夹列表
                    if localCategories.isEmpty {
                        VStack(spacing: 12) {
                            Text("暂无文件夹")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("点击上方按钮创建文件夹")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .padding(.vertical, 20)
                    } else {
                        ForEach(localCategories) { category in
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
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                        
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
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
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
        .sheet(isPresented: $showAddFolderSheet) {
            AddFolderSheetView(onAddFolder: { name in
                // 创建新文件夹并添加到列表最前面
                let newFolder = CategoryItem(id: UUID().uuidString, title: name, icon: "📁")
                localCategories.insert(newFolder, at: 0)
                // 通知外部创建文件夹
                onAddFolder?(name)
            })
        }
    }
    
    // 根据分类数量动态计算 sheet 高度
    private func calculateSheetHeight() -> CGFloat {
        let dragIndicatorHeight: CGFloat = 28 // 拖动指示器高度
        let addButtonHeight: CGFloat = 60 // 新建按钮高度
        let dividerHeight: CGFloat = 9 // 分隔线高度
        let itemHeight: CGFloat = 60 // 每个分类项的高度
        let spacing: CGFloat = 12 // 项之间的间距
        let bottomPadding: CGFloat = 20 // 底部内边距
        let emptyStateHeight: CGFloat = 80 // 空状态提示高度
        let maxVisibleItems: Int = 4 // 最多显示 4 个文件夹
        
        if localCategories.isEmpty {
            // 空状态：拖动指示器 + 新建按钮 + 空状态提示
            return dragIndicatorHeight + addButtonHeight + spacing + emptyStateHeight + bottomPadding
        }
        
        // 计算实际显示的项数（最多 4 个）
        let visibleItemCount = min(localCategories.count, maxVisibleItems)
        
        // 有内容：拖动指示器 + 新建按钮 + 分隔线 + 内容区域
        let itemsHeight = (CGFloat(visibleItemCount) * itemHeight) + (CGFloat(max(0, visibleItemCount - 1)) * spacing)
        let totalHeight = dragIndicatorHeight + addButtonHeight + spacing + dividerHeight + itemsHeight + bottomPadding
        
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
            onSelectCategory: { _ in },
            onAddFolder: { _ in }
        )
    }
}
