//
//  VideoTooLongDetailView.swift
//  Notey
//
//  Created by 盐焗鸡 on 14/1/2026.
//

import SwiftUI

struct VideoTooLongDetailView: View {
    let draft: DraftNote
    let onBack: () -> Void
    let onDelete: (String) -> Void
    
    @State private var showCopiedToast = false
    
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
                                        .fill(.orange.opacity(0.2))
                                        .overlay {
                                            Circle()
                                                .stroke(.orange.opacity(0.5), lineWidth: 1)
                                        }
                                        .frame(width: 64, height: 64)
                                    
                                    Text("⏱️")
                                        .font(.system(size: 32))
                                }
                                
                                Text("视频时长过长")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text(draft.timestamp)
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text("您选择的视频时长太长，Notey 暂时无法为您捕捉。为了避免错失这个内容，Notey 为您记录下了这个视频的地址")
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
                                            HStack(spacing: 12) {
                                                Text(url)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.blue.opacity(0.8))
                                                    .lineLimit(1)
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    UIPasteboard.general.string = url
                                                    showCopiedToast = true
                                                    
                                                    // 2秒后自动隐藏提示
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                        showCopiedToast = false
                                                    }
                                                }) {
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .fill(.white.opacity(0.2))
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                                                            }
                                                            .frame(width: 44, height: 44)
                                                        
                                                        Image(systemName: "doc.on.doc")
                                                            .font(.system(size: 18))
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(16)
                                }
                                
                                // 只有删除按钮，没有重新记录
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
                                }
                            }
                            .padding(24)
                        }
                        
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("说明")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("Notey 现在只支持 30min 以内的视频内容捕捉哦")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                    .lineSpacing(4)
                            }
                            .padding(20)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            }
            
            // 复制成功提示
            if showCopiedToast {
                VStack {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.green)
                        
                        Text("已复制到剪贴板")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay {
                                Capsule()
                                    .fill(Color.black.opacity(0.5))
                            }
                            .overlay {
                                Capsule()
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            }
                    )
                    .padding(.top, 60)
                    
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: showCopiedToast)
            }
        }
    }
}

#Preview {
    VideoTooLongDetailView(
        draft: DraftNote(
            id: "preview-draft",
            title: "长视频笔记",
            summary: "视频时长过长无法处理",
            timestamp: "Yesterday",
            videoUrl: "https://example.com/video/long-video"
        ),
        onBack: {},
        onDelete: { _ in }
    )
}
