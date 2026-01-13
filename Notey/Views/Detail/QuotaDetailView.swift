//
//  QuotaDetailView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct QuotaDetailView: View {
    @State private var quota = UserQuota()
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
                    
                    Text("用户额度")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 64)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 32) {
                        GlassCard {
                            VStack(spacing: 32) {
                                CircularProgressView(
                                    progress: quota.percentage,
                                    used: quota.usedQuota,
                                    total: quota.totalQuota
                                )
                                
                                Text("额度充足")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(24)
                        }
                        
                        VStack(spacing: 8) {
                            Text("每日 00:00 自动刷新免费额度。")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("为保障服务稳定性，当前限制每日 5 次 AI 总结。")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .multilineTextAlignment(.center)
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
    QuotaDetailView(onBack: {})
}
