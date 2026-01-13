//
//  AddFolderSheetView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct AddFolderSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var folderName: String = ""
    @FocusState private var isTextFieldFocused: Bool
    let onAddFolder: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Drag Indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(.white.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            // Content
            VStack(spacing: 16) {
                // Text Field Card - 更深的背景，更明显的文字
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.5))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.15))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.7), lineWidth: 2)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    TextField("", text: $folderName, prompt: Text("输入文件夹名称").foregroundColor(.white.opacity(0.7)))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .tint(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .focused($isTextFieldFocused)
                }
                .frame(height: 56)
                
                // Buttons - 更深的背景，更明显的对比
                HStack(spacing: 12) {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.opacity(0.2))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white.opacity(0.4), lineWidth: 1.5)
                                }
                                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                            
                            Text("取消")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                    }
                    
                    Button(action: {
                        if !folderName.trimmingCharacters(in: .whitespaces).isEmpty {
                            onAddFolder(folderName.trimmingCharacters(in: .whitespaces))
                            dismiss()
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(folderName.trimmingCharacters(in: .whitespaces).isEmpty ? 
                                      .white.opacity(0.15) : .white.opacity(0.4))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white.opacity(0.5), lineWidth: 1.5)
                                }
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            
                            Text("创建")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                    }
                    .disabled(folderName.trimmingCharacters(in: .whitespaces).isEmpty)
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
        .onAppear {
            // 自动聚焦到文本框
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
    }
    
    // 动态计算 sheet 高度
    private func calculateSheetHeight() -> CGFloat {
        let dragIndicatorHeight: CGFloat = 28 // 拖动指示器高度
        let textFieldHeight: CGFloat = 56 // 文本输入框高度
        let buttonHeight: CGFloat = 56 // 按钮高度
        let spacing: CGFloat = 16 // 间距
        let bottomPadding: CGFloat = 20 // 底部内边距
        
        let totalHeight = dragIndicatorHeight + textFieldHeight + spacing + buttonHeight + bottomPadding
        
        return totalHeight
    }
}

// 自定义 placeholder 修饰符
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
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
        
        AddFolderSheetView(onAddFolder: { _ in })
    }
}
