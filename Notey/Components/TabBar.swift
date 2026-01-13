//
//  TabBar.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case recent = "recent"
    case notes = "notes"
    case settings = "settings"
}

struct TabBar: View {
    @Binding var activeTab: Tab
    let onTabChange: (Tab) -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        activeTab = tab
                        onTabChange(tab)
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabIcon(for: tab))
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        
                        Text(tabLabel(for: tab))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background {
                        if activeTab == tab {
                            RoundedRectangle(cornerRadius: 35)
                                .fill(.white.opacity(0.4))
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(8)
        .background {
            ZStack {
                // 1. 物理模糊层：实时采样并模糊背后的内容
                RoundedRectangle(cornerRadius: 35)
                    .fill(.ultraThinMaterial)
                
                // 2. 调色层：叠加半透明黑色，保证图标对比度
                RoundedRectangle(cornerRadius: 35)
                    .fill(Color.black.opacity(0.5))
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10) // 保持悬浮阴影
        .padding(.horizontal, 16)
        .padding(.bottom, 4) // 在 Safe Area 内留出 4pt 小缝隙，坐在 Home Indicator 上方
    }
    
    private func tabIcon(for tab: Tab) -> String {
        switch tab {
        case .recent:
            return "clock"
        case .notes:
            return "doc.text"
        case .settings:
            return "gearshape"
        }
    }
    
    private func tabLabel(for tab: Tab) -> String {
        switch tab {
        case .recent:
            return "最近内容"
        case .notes:
            return "我的笔记"
        case .settings:
            return "设置"
        }
    }
}

#Preview {
    struct TabBarPreview: View {
        @State private var activeTab: Tab = .recent
        
        var body: some View {
            ZStack {
                LinearGradient(
                    colors: [Color.noteyBackgroundStart, Color.noteyBackgroundEnd],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    TabBar(activeTab: $activeTab) { tab in
                        activeTab = tab
                    }
                }
            }
        }
    }
    
    return TabBarPreview()
}
