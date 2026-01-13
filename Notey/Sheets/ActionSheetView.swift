//
//  ActionSheetView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct ActionSheetView: View {
    @Environment(\.dismiss) var dismiss
    let isFavorited: Bool
    let onFavorite: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Drag Indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(.white.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            // Action Buttons
            VStack(spacing: 12) {
                // Favorite Button
                Button(action: {
                    onFavorite()
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
                        
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.3))
                                    .overlay {
                                        Circle()
                                            .stroke(.white.opacity(0.4), lineWidth: 1)
                                    }
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: isFavorited ? "star.fill" : "star")
                                    .font(.system(size: 20))
                                    .foregroundColor(isFavorited ? .yellow : .white)
                            }
                            
                            Text(isFavorited ? "取消收藏" : "收藏该内容")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                    .frame(height: 64)
                }
                
                // Delete Button
                Button(action: {
                    onDelete()
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
                        
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(.red.opacity(0.3))
                                    .overlay {
                                        Circle()
                                            .stroke(.red.opacity(0.5), lineWidth: 1)
                                    }
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "trash")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red.opacity(0.9))
                            }
                            
                            Text("删除该内容")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.red.opacity(0.9))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                    .frame(height: 64)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
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
    
    // 动态计算 sheet 高度
    private func calculateSheetHeight() -> CGFloat {
        let dragIndicatorHeight: CGFloat = 28 // 拖动指示器高度
        let actionButtonHeight: CGFloat = 64 // 每个操作按钮的高度
        let spacing: CGFloat = 12 // 按钮之间的间距
        let bottomPadding: CGFloat = 20 // 底部内边距
        
        // 拖动指示器 + 2个操作按钮 + 间距 + 底部内边距
        let totalHeight = dragIndicatorHeight + (actionButtonHeight * 2) + spacing + bottomPadding
        
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
        
        ActionSheetView(
            isFavorited: false,
            onFavorite: {},
            onDelete: {}
        )
    }
}
