//
//  DeleteOnlySheetView.swift
//  Notey
//
//  Created by 盐焗鸡 on 14/1/2026.
//

import SwiftUI

struct DeleteOnlySheetView: View {
    @Environment(\.dismiss) var dismiss
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Drag Indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(.white.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            // Delete Button
            Button(action: {
                onDelete()
                dismiss()
            }) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "trash")
                            .font(.system(size: 18))
                            .foregroundColor(.red.opacity(0.8))
                    }
                    
                    Text("删除该内容")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        }
                )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .presentationBackground {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.black.opacity(0.4))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.2),
                                        .white.opacity(0.05),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.white.opacity(0.5), lineWidth: 1.5)
                    }
                    .shadow(color: .black.opacity(0.3), radius: 25, x: 0, y: 12)
            }
        }
        .presentationDetents([.height(130)])
        .presentationDragIndicator(.hidden)
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
        
        DeleteOnlySheetView(onDelete: {})
    }
}
