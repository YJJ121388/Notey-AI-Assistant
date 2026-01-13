//
//  ToastManager.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI
import Combine

class ToastManager: ObservableObject {
    @Published var message: String = ""
    @Published var isVisible: Bool = false
    
    func show(_ message: String) {
        self.message = message
        withAnimation {
            self.isVisible = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.isVisible = false
            }
        }
    }
}
