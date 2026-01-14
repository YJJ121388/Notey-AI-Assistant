//
//  NoteDetailView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct NoteDetailView: View {
    @State private var note: Note
    @State private var isEditing = false
    @State private var editedTitle: String
    @State private var editedContent: String
    
    private let maxTitleCharacters = 30
    
    // 计算标题字符数
    private var titleCharacterCount: Int {
        editedTitle.count
    }
    
    // 判断标题是否达到上限
    private var isTitleAtLimit: Bool {
        titleCharacterCount >= maxTitleCharacters
    }
    
    let onBack: () -> Void
    let onSave: (String, String, String) -> Void
    
    init(note: Note, onBack: @escaping () -> Void, onSave: @escaping (String, String, String) -> Void) {
        self._note = State(initialValue: note)
        self._editedTitle = State(initialValue: note.title)
        self._editedContent = State(initialValue: note.content ?? "这是笔记的详细内容。您可以在这里记录更多信息、想法和细节。\n\n点击右上角的铅笔图标开始编辑。")
        self.onBack = onBack
        self.onSave = onSave
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.noteyBackgroundStart, Color.noteyBackgroundEnd],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Decorative blobs
            BackgroundBlobsView()
            
            if isEditing {
                editingView
            } else {
                readingView
            }
        }
    }
    
    private var readingView: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                
                Text("笔记详情")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    isEditing = true
                }) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "pencil")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 64)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(.white.opacity(0.35))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(.white.opacity(0.5), lineWidth: 1)
                                        }
                                        .shadow(color: .black.opacity(0.1), radius: 8)
                                        .frame(width: 48, height: 48)
                                    
                                    Text(note.icon)
                                        .font(.system(size: 24))
                                }
                                
                                Text(note.title)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            Divider()
                                .background(.white.opacity(0.2))
                            
                            Text(editedContent)
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(4)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("笔记信息")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                HStack {
                                    Text("创建时间")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    Spacer()
                                    
                                    Text("2024年1月10日")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                HStack {
                                    Text("最后编辑")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    Spacer()
                                    
                                    Text("今天")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                HStack {
                                    Text("字数统计")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    Spacer()
                                    
                                    Text("\(editedContent.count) 字")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            .padding(.top, 24)
                        }
                        .padding(24)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40) // 为底部安全区域留出空间
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private var editingView: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    isEditing = false
                    editedTitle = note.title
                    editedContent = note.content ?? "这是笔记的详细内容。您可以在这里记录更多信息、想法和细节。\n\n点击右上角的铅笔图标开始编辑。"
                }) {
                    Text("取消")
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Text("编辑笔记")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    onSave(note.id, editedTitle, editedContent)
                    note.title = editedTitle
                    note.content = editedContent
                    isEditing = false
                }) {
                    Text("完成")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 64)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(spacing: 12) {
                    // 标题输入框 - 支持拼音输入
                    GlassCard {
                        ZStack(alignment: .topLeading) {
                            VStack(alignment: .leading, spacing: 0) {
                                // 标题输入 - 使用自定义组件处理拼音
                                TitleTextView(
                                    text: $editedTitle,
                                    placeholder: "标题",
                                    maxLength: maxTitleCharacters
                                )
                                .frame(height: 70)
                                .padding(.top, 16)
                                .padding(.leading, 20)
                                .padding(.trailing, 70)
                                
                                Spacer()
                                
                                // 字数统计 - 固定在右下角
                                HStack {
                                    Spacer()
                                    Text("\(titleCharacterCount)/\(maxTitleCharacters)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(isTitleAtLimit ? .red.opacity(0.9) : .white.opacity(0.6))
                                        .padding(.trailing, 16)
                                        .padding(.bottom, 12)
                                }
                            }
                        }
                        .frame(height: 120)
                    }
                    
                    // 正文输入框
                    GlassCard {
                        TextEditor(text: $editedContent)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 300)
                            .padding(20)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40) // 为底部安全区域留出空间
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    NoteDetailView(
        note: Note(
            id: "preview-1",
            title: "示例笔记",
            icon: "📄",
            content: "这是笔记的详细内容。您可以在这里记录更多信息、想法和细节。\n\n点击右上角的铅笔图标开始编辑。"
        ),
        onBack: {},
        onSave: { _, _, _ in }
    )
}

// 自定义标题输入框，支持拼音输入时不截断
struct TitleTextView: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let maxLength: Int
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.textColor = .white
        textView.tintColor = .white
        textView.font = .systemFont(ofSize: 24, weight: .bold)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byCharWrapping
        
        // 添加 placeholder
        context.coordinator.placeholderLabel = UILabel()
        context.coordinator.placeholderLabel?.text = placeholder
        context.coordinator.placeholderLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        context.coordinator.placeholderLabel?.textColor = UIColor.white.withAlphaComponent(0.5)
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
            
            // 检查是否有未确认的拼音输入（markedText）
            if let markedTextRange = textView.markedTextRange,
               let _ = textView.text(in: markedTextRange) {
                // 正在输入拼音，不进行截断，只更新绑定
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
