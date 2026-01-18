//
//  SplashView.swift
//  Notey
//
//  Created by 盐焗鸡 on 14/1/2026.
//

import SwiftUI

struct SplashView: View {
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
            
            // Notey Logo
            Text("Notey")
                .font(.aclonica(size: 96))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    SplashView()
}
