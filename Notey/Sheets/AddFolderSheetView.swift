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
    @State private var shouldFocusTextField = false
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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Drag Indicator
                RoundedRectangle(cornerRadius: 3)
                    .fill(.white.opacity(0.5))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                
                // Content
                VStack(spacing: 16) {
                    // Text Field Card - 固定两行高度
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
                            // 多行文本输入区域
                            LimitedTextView(
                                text: $folderName,
                                placeholder: "输入文件夹名称",
                                maxLength: maxCharacters,
                                shouldFocus: $shouldFocusTextField
                            )
                            .frame(height: 70) // 固定高度，足够显示两行
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .padding(.top, 12)
                            
                            // 字数统计 - 固定在底部
                            HStack {
                                Spacer()
                                Text("\(currentCharacterCount)/\(maxCharacters)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(isAtLimit ? .red.opacity(0.9) : .white.opacity(0.6))
                                    .padding(.trailing, 16)
                                    .padding(.bottom, 8)
                            }
                        }
                    }
                    .frame(width: geometry.size.width - 40, height: 100) // 固定整体高度
                    
                    // Buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("取消")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: (geometry.size.width - 64) / 2, height: 56)
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
                                onAddFolder(folderName.trimmingCharacters(in: .whitespaces))
                                dismiss()
                            }
                        }) {
                            Text("创建")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: (geometry.size.width - 64) / 2, height: 56)
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
                    .frame(width: geometry.size.width - 40)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .frame(width: geometry.size.width)
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
        .presentationDetents([.height(calculateSheetHeight())])
        .presentationDragIndicator(.hidden)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                shouldFocusTextField = true
            }
        }
    }
    
    private func calculateSheetHeight() -> CGFloat {
        let dragIndicatorHeight: CGFloat = 28
        let textFieldHeight: CGFloat = 100 // 输入框固定高度
        let buttonHeight: CGFloat = 56
        let spacing: CGFloat = 16
        let bottomPadding: CGFloat = 20
        
        return dragIndicatorHeight + textFieldHeight + spacing + buttonHeight + bottomPadding
    }
}

// 自定义多行 TextView，支持固定宽度和拼音输入
struct LimitedTextView: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let maxLength: Int
    @Binding var shouldFocus: Bool
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.textColor = .white
        textView.tintColor = .white
        textView.font = .systemFont(ofSize: 17, weight: .semibold)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true // 允许滚动
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byCharWrapping // 按字符换行
        
        // 添加 placeholder
        context.coordinator.placeholderLabel = UILabel()
        context.coordinator.placeholderLabel?.text = placeholder
        context.coordinator.placeholderLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        context.coordinator.placeholderLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
        context.coordinator.placeholderLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if let placeholderLabel = context.coordinator.placeholderLabel {
            textView.addSubview(placeholderLabel)
            NSLayoutConstraint.activate([
                placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
                placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor)
            ])
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        // 更新 placeholder 可见性
        context.coordinator.placeholderLabel?.isHidden = !text.isEmpty
        
        // 处理自动聚焦
        if shouldFocus && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, maxLength: maxLength)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let maxLength: Int
        var placeholderLabel: UILabel?
        
        init(text: Binding<String>, maxLength: Int) {
            _text = text
            self.maxLength = maxLength
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let currentText = textView.text ?? ""
            
            // 检查是否有未确认的拼音输入
            if let markedTextRange = textView.markedTextRange,
               let _ = textView.text(in: markedTextRange) {
                // 正在输入拼音，不进行截断
                text = currentText
            } else {
                // 拼音已确认，进行长度限制
                if currentText.count > maxLength {
                    let limitedText = String(currentText.prefix(maxLength))
                    textView.text = limitedText
                    text = limitedText
                } else {
                    text = currentText
                }
            }
            
            // 更新 placeholder 可见性
            placeholderLabel?.isHidden = !textView.text.isEmpty
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // 处理回车键 - 收起键盘
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
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
