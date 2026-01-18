//
//  Note.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import Foundation

struct Note: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var icon: String
    var content: String?
    var timestamp: Date?
    var createdAt: Date?
    var lastEdited: Date?
    var videoUrl: String?
    
    init(id: String = UUID().uuidString, title: String, icon: String, content: String? = nil, timestamp: Date? = nil, createdAt: Date? = nil, lastEdited: Date? = nil, videoUrl: String? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.content = content
        self.timestamp = timestamp
        self.createdAt = createdAt ?? Date()
        self.lastEdited = lastEdited ?? Date()
        self.videoUrl = videoUrl
    }
}
