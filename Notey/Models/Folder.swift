//
//  Folder.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import Foundation

struct Folder: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var icon: String
    var type: FolderType
    var children: [Note]?
    
    init(id: String = UUID().uuidString, title: String, icon: String, type: FolderType = .folder, children: [Note]? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.type = type
        self.children = children
    }
}

enum FolderType: String, Codable {
    case folder
    case file
}

struct DraftNote: Identifiable, Codable {
    var id: String
    var title: String
    var summary: String
    var timestamp: String
    var videoUrl: String?
    
    init(id: String = UUID().uuidString, title: String, summary: String, timestamp: String, videoUrl: String? = nil) {
        self.id = id
        self.title = title
        self.summary = summary
        self.timestamp = timestamp
        self.videoUrl = videoUrl
    }
}
