//
//  LibraryManager.swift
//  Notey
//
//  Created on 1/13/2026.
//

import Foundation
import Combine

class LibraryManager: ObservableObject {
    @Published var personalLibrary: [Folder] = []
    @Published var uncategorizedNotes: [Note] = []
    
    func moveNoteToFolder(noteId: String, folderId: String) {
        print("🔄 LibraryManager: 移动笔记 \(noteId) 到文件夹 \(folderId)")
        
        // 找到笔记
        guard let noteIndex = uncategorizedNotes.firstIndex(where: { $0.id == noteId }) else {
            print("❌ 未找到笔记")
            return
        }
        
        let note = uncategorizedNotes[noteIndex]
        print("✅ 找到笔记: \(note.title)")
        
        // 找到文件夹
        guard let folderIndex = personalLibrary.firstIndex(where: { $0.id == folderId }) else {
            print("❌ 未找到文件夹")
            return
        }
        
        print("✅ 找到文件夹: \(personalLibrary[folderIndex].title)")
        
        // 添加笔记到文件夹
        if personalLibrary[folderIndex].children == nil {
            personalLibrary[folderIndex].children = []
        }
        personalLibrary[folderIndex].children?.append(note)
        print("✅ 添加成功，文件夹子笔记数: \(personalLibrary[folderIndex].children?.count ?? 0)")
        
        // 从未分类笔记中移除
        uncategorizedNotes.remove(at: noteIndex)
        print("✅ 移除成功，剩余未分类笔记: \(uncategorizedNotes.count)")
    }
}
