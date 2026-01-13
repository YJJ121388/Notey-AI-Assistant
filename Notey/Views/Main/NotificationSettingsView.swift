//
//  NotificationSettingsView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var recordComplete = true
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
                    
                    Text("通知")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 64)
                .padding(.bottom, 16)
                
                ScrollView {
                    GlassCard {
                        VStack(spacing: 0) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("记录完成")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Text("当notey完成笔记生成时通知我")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white.opacity(0.6))
                                        .lineSpacing(2)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $recordComplete)
                                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.20, green: 0.78, blue: 0.35)))
                            }
                            .padding(16)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 150) // 为 TabBar 留出足够空间，防止遮挡
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    NotificationSettingsView(onBack: {})
}
