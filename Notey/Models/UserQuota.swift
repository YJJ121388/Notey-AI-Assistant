//
//  UserQuota.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import Foundation

struct UserQuota: Codable {
    var usedQuota: Int
    var totalQuota: Int
    
    var percentage: Double {
        guard totalQuota > 0 else { return 0 }
        return Double(usedQuota) / Double(totalQuota)
    }
    
    var status: QuotaStatus {
        if percentage >= 0.8 {
            return .warning
        } else if percentage >= 1.0 {
            return .exceeded
        } else {
            return .sufficient
        }
    }
    
    init(usedQuota: Int = 3, totalQuota: Int = 5) {
        self.usedQuota = usedQuota
        self.totalQuota = totalQuota
    }
}

enum QuotaStatus {
    case sufficient
    case warning
    case exceeded
}
