//
//  ShareSheetView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct ShareSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 8) {
                // File Preview Card
                GlassCard {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(red: 0, green: 0.48, blue: 1))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "doc.text")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Notey_Backup_20260110.md")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("Markdown 文档")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(16)
                }
                .background(.white.opacity(0.95))
                
                // Share Actions
                GlassCard {
                    VStack(spacing: 0) {
                        ShareActionItem(icon: "square.and.arrow.up", title: "AirDrop")
                        Divider().background(.gray.opacity(0.2))
                        ShareActionItem(icon: "envelope", title: "邮件")
                        Divider().background(.gray.opacity(0.2))
                        ShareActionItem(icon: "doc.on.doc", title: "拷贝")
                        Divider().background(.gray.opacity(0.2))
                        ShareActionItem(icon: "arrow.down.circle", title: "存储到文件")
                    }
                }
                .background(.white.opacity(0.95))
                
                // Cancel Button
                Button(action: {
                    dismiss()
                }) {
                    GlassCard {
                        Text("取消")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                            .frame(maxWidth: .infinity)
                            .padding(14)
                    }
                }
                .background(.white.opacity(0.95))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color.black.opacity(0.4))
        .ignoresSafeArea()
    }
}

struct ShareActionItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                }
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
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
        
        ShareSheetView()
    }
}
