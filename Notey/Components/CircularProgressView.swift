//
//  CircularProgressView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let used: Int
    let total: Int
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .trim(from: 0, to: 1)
                .stroke(.white.opacity(0.2), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .frame(width: 256, height: 256)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(
                    LinearGradient(
                        colors: [Color(red: 0.53, green: 0.81, blue: 0.92), Color(red: 0.20, green: 0.60, blue: 0.86)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .frame(width: 256, height: 256)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            
            // Center content
            VStack(spacing: 8) {
                Text("\(used) / \(total)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                
                Text("今日已用")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
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
        
        CircularProgressView(
            progress: 0.6,
            used: 3,
            total: 5
        )
    }
}
