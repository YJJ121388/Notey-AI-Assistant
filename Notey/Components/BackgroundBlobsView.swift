//
//  BackgroundBlobsView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct BackgroundBlobsView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.noteyBlob1.opacity(0.5))
                .frame(width: 384, height: 384)
                .blur(radius: 100)
                .offset(x: -150, y: -150)
            
            Circle()
                .fill(Color.noteyBlob2.opacity(0.5))
                .frame(width: 384, height: 384)
                .blur(radius: 100)
                .offset(x: 150, y: -150)
            
            Circle()
                .fill(Color.noteyBlob3.opacity(0.7))
                .frame(width: 384, height: 384)
                .blur(radius: 100)
                .offset(x: 0, y: 300)
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
    }
}
