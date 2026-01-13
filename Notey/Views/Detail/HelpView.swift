//
//  HelpView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct HelpView: View {
    let onBack: () -> Void
    
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
                    
                    Text("帮助与支持")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 64)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // App Logo
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.white.opacity(0.2))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(.white.opacity(0.4), lineWidth: 1)
                                }
                                .shadow(color: .black.opacity(0.2), radius: 20)
                                .frame(width: 112, height: 112)
                            
                            Text("📝")
                                .font(.system(size: 48))
                        }
                        
                        Text("Notey v2.0")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        GlassCard {
                            VStack(spacing: 0) {
                                HelpItem(
                                    icon: "book",
                                    title: "指南与文档",
                                    onTap: {}
                                )
                                
                                Divider()
                                    .background(.white.opacity(0.2))
                                
                                HelpItem(
                                    icon: "questionmark.circle",
                                    title: "常见问题",
                                    onTap: {}
                                )
                                
                                Divider()
                                    .background(.white.opacity(0.2))
                                
                                HelpItem(
                                    icon: "message",
                                    title: "反馈与联系",
                                    subtitle: "报告问题或提出建议",
                                    onTap: {}
                                )
                            }
                        }
                        
                        GlassCard {
                            HStack {
                                Text("开发者")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Spacer()
                                
                                Text("Notey Team")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding(16)
                        }
                        
                        Text("© 2026 Notey Team")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.top, 32)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40) // 为底部安全区域留出空间
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

struct HelpItem: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white.opacity(0.35))
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white.opacity(0.5), lineWidth: 1)
                        }
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    HelpView(onBack: {})
}
