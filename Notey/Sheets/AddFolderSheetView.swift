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
    @FocusState private var isFocused: Bool
    let onAddFolder: (String) -> Void
    
    private let maxCharacters = 30
    
    // 计算当前字符数
    private var currentCharacterCount: Int {
        folderName.count
    }
    
    // 判断是否达到上限
    private var isAtLimit: Bool {
        currentCharacterCount >= maxCharacters
    }
    
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
                // Text Field Card
                ZStack(alignment: .topLeading) {
                    // 背景
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.5))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.15))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.5), lineWidth: 1.5)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // 输入框
                        TextField("输入文件夹名称", text: $folderName, axis: .vertical)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .tint(.white)
                            .lineLimit(2)
                            .focused($isFocused)
                            .padding(.leading, 20)
                            .padding(.trailing, 70)
                            .padding(.top, 16)
                            .onChange(of: folderName) { oldValue, newValue in
                                // 限制字符数
                                if newValue.count > maxCharacters {
                                    folderName = String(newValue.prefix(maxCharacters))
                                }
                            }
                        
                        Spacer()
                        
                        // 字数统计 - 固定在右下角
                        HStack {
                            Spacer()
                            Text("\(currentCharacterCount)/\(maxCharacters)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(isAtLimit ? .red.opacity(0.9) : .white.opacity(0.6))
                                .padding(.trailing, 16)
                                .padding(.bottom, 12)
                        }
                    }
                }
                .frame(height: 100)
                
                // Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        isFocused = false
                        dismiss()
                    }) {
                        Text("取消")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white.opacity(0.2))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.white.opacity(0.4), lineWidth: 1.5)
                                    }
                                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                            )
                    }
                    
                    Button(action: {
                        if !folderName.trimmingCharacters(in: .whitespaces).isEmpty {
                            isFocused = false
                            onAddFolder(folderName.trimmingCharacters(in: .whitespaces))
                            dismiss()
                        }
                    }) {
                        Text("创建")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(folderName.trimmingCharacters(in: .whitespaces).isEmpty ? 
                                          .white.opacity(0.15) : .white.opacity(0.4))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.white.opacity(0.5), lineWidth: 1.5)
                                    }
                                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            )
                    }
                    .disabled(folderName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .presentationBackground {
            ZStack {
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
        .presentationDetents([.height(220)])
        .presentationDragIndicator(.hidden)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFocused = true
            }
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
