//
//  NoteyApp.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI
import SwiftData

@main
struct NoteyApp: App {
    @State private var isLoading = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if isLoading {
                SplashView()
                    .onAppear {
                        // 模拟加载时间，可根据实际需要调整
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeOut(duration: 0.3)) {
                                isLoading = false
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}
