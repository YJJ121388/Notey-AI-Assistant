//
//  ToastView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack {
            if isVisible {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    
                    Text(message)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background {
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
                        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 4)
                }
                .padding(.top, 60)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .allowsHitTesting(false)
        .onChange(of: isVisible) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isVisible = false
                    }
                }
            }
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
        
        ToastView(message: "笔记「项目想法」已删除", isVisible: .constant(true))
    }
}
