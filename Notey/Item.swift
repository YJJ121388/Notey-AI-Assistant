//
//  Item.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
