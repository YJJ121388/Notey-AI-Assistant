//
//  GlassCard.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Glass effect background
            RoundedRectangle(cornerRadius: 30)
                .fill(.white.opacity(0.15))
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.3),
                                    .white.opacity(0.1),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.white.opacity(0.4), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            
            content
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
        
        GlassCard {
            VStack(spacing: 16) {
                Image(systemName: "star.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                Text("Glass Card Preview")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("这是一个玻璃态卡片组件示例")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(32)
        }
        .padding()
    }
}
