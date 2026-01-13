//
//  SettingsView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct SettingsView: View {
    let onSettingsItemClick: (String) -> Void
    
    let settingsItems = [
        SettingsItem(id: "1", title: "用户额度", icon: "wallet.pass"),
        SettingsItem(id: "2", title: "通知", icon: "bell"),
        SettingsItem(id: "3", title: "数据管理", icon: "externaldrive"),
        SettingsItem(id: "4", title: "帮助与支持", icon: "questionmark.circle")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header - Notey Logo
                HStack {
                    Text("Notey")
                        .font(.aclonica(size: 64))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    
                    Spacer()
                }
                .padding(.horizontal, 4)
                .padding(.top, 20)
                .padding(.bottom, 8)
                
                Text("设置")
                    .font(.aclonica(size: 20))
                    .foregroundColor(.white.opacity(0.6))
                    .textCase(.uppercase)
                    .tracking(0.5)
                    .padding(.horizontal, 4)
                
                GlassCard {
                    VStack(spacing: 0) {
                        ForEach(settingsItems) { item in
                            Button(action: {
                                onSettingsItemClick(item.id)
                            }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(.white.opacity(0.35))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .stroke(.white.opacity(0.5), lineWidth: 1)
                                            }
                                            .shadow(color: .black.opacity(0.1), radius: 8)
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: item.icon)
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text(item.title)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                            }
                            
                            if item.id != settingsItems.last?.id {
                                Divider()
                                    .background(.white.opacity(0.1))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 150) // 为 TabBar 留出足够空间，防止遮挡
        }
        .scrollIndicators(.hidden)
    }
}

struct SettingsItem: Identifiable {
    let id: String
    let title: String
    let icon: String
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
        
        SettingsView { _ in }
    }
}
