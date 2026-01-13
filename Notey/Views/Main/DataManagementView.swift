//
//  DataManagementView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct DataManagementView: View {
    @State private var showShareSheet = false
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
                    
                    Text("数据管理")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 64)
                .padding(.bottom, 16)
                
                // Storage Info
                Text("已用存储空间：12.5 MB")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                
                ScrollView {
                    GlassCard {
                        Button(action: {
                            showShareSheet = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.down.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("导出所有笔记")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Text("导出 JSON/Markdown")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.5))
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
        .sheet(isPresented: $showShareSheet) {
            ShareSheetView()
        }
    }
}

#Preview {
    DataManagementView(onBack: {})
}
