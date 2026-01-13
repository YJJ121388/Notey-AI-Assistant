//
//  Font+Extensions.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

extension Font {
    static func aclonica(size: CGFloat) -> Font {
        // 尝试使用自定义字体，如果不存在则回退到系统字体
        if let font = UIFont(name: "Aclonica", size: size) {
            return Font(font)
        } else {
            // 回退到系统粗体字体
            return .system(size: size, weight: .bold, design: .rounded)
        }
    }
}
