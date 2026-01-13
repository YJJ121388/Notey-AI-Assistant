//
//  DraftDetailView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct DraftDetailView: View {
    let draft: DraftNote
    let onBack: () -> Void
    let onDelete: (String) -> Void
    let onRetry: (String) -> Void
    
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
                }
                .padding(.horizontal, 20)
                .padding(.top, 64)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 16) {
                        GlassCard {
                            VStack(spacing: 24) {
                                ZStack {
                                    Circle()
                                        .fill(.red.opacity(0.2))
                                        .overlay {
                                            Circle()
                                                .stroke(.red.opacity(0.5), lineWidth: 1)
                                        }
                                        .frame(width: 64, height: 64)
                                    
                                    Text("⚠️")
                                        .font(.system(size: 32))
                                }
                                
                                Text("笔记录入失败")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text(draft.timestamp)
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text("您的笔记没有被 Notey 捕捉到，以下是原视频链接，您可以尝试再次发送给 Notey 重新记录")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                
                                GlassCard {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("原视频链接：")
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        if let url = draft.videoUrl {
                                            Link(destination: URL(string: url)!) {
                                                HStack {
                                                    Text(url)
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.blue.opacity(0.8))
                                                        .lineLimit(1)
                                                    
                                                    Image(systemName: "arrow.up.right.square")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(.blue.opacity(0.8))
                                                }
                                            }
                                        }
                                    }
                                    .padding(16)
                                }
                                
                                VStack(spacing: 12) {
                                    Button(action: {
                                        onRetry(draft.id)
                                    }) {
                                        GlassCard {
                                            HStack {
                                                Image(systemName: "arrow.clockwise")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.white)
                                                
                                                Text("重新记录")
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(16)
                                        }
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(.blue.opacity(0.5), lineWidth: 1)
                                        }
                                    }
                                    
                                    Button(action: {
                                        onDelete(draft.id)
                                    }) {
                                        GlassCard {
                                            HStack {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.white)
                                                
                                                Text("删除")
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(16)
                                        }
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(.red.opacity(0.4), lineWidth: 1)
                                        }
                                    }
                                }
                            }
                            .padding(24)
                        }
                        
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("说明")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("由于网络等原因，您的内容并没有被Notey捕捉到")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                    .lineSpacing(4)
                            }
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
}

#Preview {
    DraftDetailView(
        draft: DraftNote(
            id: "preview-draft",
            title: "UX Workshop Notes",
            summary: "Brainstorming session on improving user onboarding experience",
            timestamp: "Yesterday",
            videoUrl: "https://example.com/video/ux-workshop"
        ),
        onBack: {},
        onDelete: { _ in },
        onRetry: { _ in }
    )
}
