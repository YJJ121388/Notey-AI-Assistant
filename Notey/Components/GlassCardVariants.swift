//
//  GlassCardVariants.swift
//  Notey
//
//  玻璃卡片设计变体 - 基于 SwiftUI Material 效果
//

import SwiftUI

// MARK: - 变体 1: Ultra Thin Material (极薄材质)
struct GlassCardUltraThin<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
    }
}

// MARK: - 变体 2: Thin Material (薄材质)
struct GlassCardThin<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.thinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
            }
    }
}

// MARK: - 变体 3: Regular Material (常规材质)
struct GlassCardRegular<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.regularMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.4), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
            }
    }
}

// MARK: - 变体 4: Thick Material (厚材质)
struct GlassCardThick<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.thickMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.5), lineWidth: 1.5)
                    }
                    .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 10)
            }
    }
}

// MARK: - 变体 5: Ultra Thick Material (极厚材质)
struct GlassCardUltraThick<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThickMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.6), lineWidth: 2)
                    }
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 12)
            }
    }
}


#Preview("所有玻璃卡片变体对比") {
    ScrollView {
        VStack(spacing: 32) {
            Text("玻璃卡片材质对比")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("变体 1: Ultra Thin Material")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                GlassCardUltraThin {
                    VStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                        Text("极薄材质")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Text("最透明，背景内容清晰可见")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                }
                .padding(.horizontal, 20)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("变体 2: Thin Material")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                GlassCardThin {
                    VStack(spacing: 12) {
                        Image(systemName: "cloud")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                        Text("薄材质")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Text("轻微模糊，保持通透感")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                }
                .padding(.horizontal, 20)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("变体 3: Regular Material")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                GlassCardRegular {
                    VStack(spacing: 12) {
                        Image(systemName: "square.on.square")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                        Text("常规材质")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Text("平衡的模糊效果，适合大多数场景")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                }
                .padding(.horizontal, 20)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("变体 4: Thick Material")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                GlassCardThick {
                    VStack(spacing: 12) {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                        Text("厚材质")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Text("明显模糊，背景内容不易干扰")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                }
                .padding(.horizontal, 20)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("变体 5: Ultra Thick Material")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                GlassCardUltraThick {
                    VStack(spacing: 12) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                        Text("极厚材质")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Text("最强模糊，完全隔离背景")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 40)
    }
    .background {
        ZStack {
            LinearGradient(
                colors: [Color.noteyBackgroundStart, Color.noteyBackgroundEnd],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            BackgroundBlobsView()
        }
    }
    .scrollIndicators(.hidden)
}
