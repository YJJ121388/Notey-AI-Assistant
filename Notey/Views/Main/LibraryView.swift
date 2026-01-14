//
//  LibraryView.swift
//  Notey
//
//  Created by 盐焗鸡 on 12/1/2026.
//

import SwiftUI

struct LibraryView: View {
    @Binding var personalLibrary: [Folder]
    @Binding var uncategorizedNotes: [Note]
    @Binding var recentlyClassifiedNotes: [Note] // 最近分类的笔记
    let onMoveNoteToFolder: (String, String) -> Void  // (noteId, folderId) -> Void
    let onDeleteNote: (String) -> Void  // 删除笔记的回调
    @State private var expandedFolders: Set<String> = []
    @State private var expandedFavoriteFolders: Set<String> = [] // 用于"我的收藏"区域的展开状态
    @State private var favorites: Set<String> = ["11", "11-1"]
    @State private var isFavoritesExpanded = true
    @State private var isUncategorizedExpanded = true
    @State private var isMyNotesExpanded = true
    @State private var actionSheetId: String? = nil
    @State private var addFolderSheetId: String? = nil
    @State private var categorySheetNoteId: String? = nil
    @Namespace private var scrollNamespace
    
    let onLibraryNoteClick: (String) -> Void
    let onUncategorizedNoteClick: (String) -> Void
    
    var favoritedNotes: [Note] {
        var notes: [Note] = []
        for folder in personalLibrary {
            // 如果文件夹被收藏，添加其所有子笔记
            if favorites.contains(folder.id) {
                if let children = folder.children {
                    notes.append(contentsOf: children)
                }
            } else {
                // 如果文件夹未被收藏，只添加被单独收藏的笔记
                if let children = folder.children {
                    for child in children {
                        if favorites.contains(child.id) {
                            notes.append(child)
                        }
                    }
                }
            }
        }
        return notes
    }
    
    // 显示的最近笔记（最多8个）
    var displayedRecentNotes: [Note] {
        Array(recentlyClassifiedNotes.prefix(8))
    }
    
    // 获取包含收藏笔记的文件夹
    var foldersWithFavorites: [Folder] {
        personalLibrary.filter { folder in
            // 文件夹被收藏，或者其中有笔记被收藏
            if favorites.contains(folder.id) {
                return true
            }
            if let children = folder.children {
                return children.contains { favorites.contains($0.id) }
            }
            return false
        }
    }
    
    // 判断文件夹星标是否应该点亮
    func isFolderFavorited(_ folder: Folder) -> Bool {
        // 如果文件夹本身被收藏
        if favorites.contains(folder.id) {
            return true
        }
        // 如果文件夹中所有笔记都被收藏
        if let children = folder.children, !children.isEmpty {
            return children.allSatisfy { favorites.contains($0.id) }
        }
        return false
    }
    
    // 获取文件夹中被收藏的笔记
    func getFavoritedNotes(in folder: Folder) -> [Note] {
        guard let children = folder.children else { return [] }
        return children.filter { favorites.contains($0.id) }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header - Notey Logo
                    HStack {
                        Text("Notey")
                            .font(.aclonica(size: 64))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 20)
                    .padding(.bottom, 8)
                    
                    // Recent Notes Section (最近笔记)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("最近笔记")
                            .font(.aclonica(size: 20))
                            .foregroundColor(.white.opacity(0.6))
                            .textCase(.uppercase)
                            .tracking(0.5)
                            .padding(.horizontal, 4)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(displayedRecentNotes) { note in
                                    FavoriteGridItem(note: note) {
                                        onLibraryNoteClick(note.id)
                                    }
                                }
                                
                                // "查看更多"卡片
                                if recentlyClassifiedNotes.count > 0 {
                                    Button(action: {
                                        withAnimation {
                                            isMyNotesExpanded = true
                                            // 使用 DispatchQueue 确保展开动画完成后再滚动
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                withAnimation {
                                                    proxy.scrollTo("myNotesSection", anchor: .top)
                                                }
                                            }
                                        }
                                    }) {
                                        GlassCard {
                                            VStack(spacing: 12) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .fill(.white.opacity(0.25))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 30)
                                                                .stroke(.white.opacity(0.4), lineWidth: 1)
                                                        }
                                                        .shadow(color: .black.opacity(0.1), radius: 8)
                                                    
                                                    Image(systemName: "chevron.right")
                                                        .font(.system(size: 24))
                                                        .foregroundColor(.white)
                                                }
                                                .frame(width: 48, height: 48)
                                                
                                                VStack(spacing: 4) {
                                                    Text("前往我的笔记中")
                                                        .font(.system(size: 13, weight: .medium))
                                                        .foregroundColor(.white.opacity(0.8))
                                                        .multilineTextAlignment(.center)
                                                    
                                                    Text("查看更多笔记")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.white.opacity(0.6))
                                                        .multilineTextAlignment(.center)
                                                }
                                            }
                                            .padding(16)
                                        }
                                        .frame(width: 160, height: 160)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // Personal Library Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("个人笔记库")
                            .font(.aclonica(size: 20))
                            .foregroundColor(.white.opacity(0.6))
                            .textCase(.uppercase)
                            .tracking(0.5)
                            .padding(.horizontal, 4)
                        
                        // My Favorites Card
                        GlassCard {
                            VStack(spacing: 0) {
                                Button(action: {
                                    withAnimation {
                                        isFavoritesExpanded.toggle()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: isFavoritesExpanded ? "chevron.down" : "chevron.right")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        Text("我的收藏")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .padding(16)
                                }
                                
                                if isFavoritesExpanded {
                                    Divider()
                                        .background(.white.opacity(0.2))
                                    
                                    if foldersWithFavorites.isEmpty {
                                        VStack(spacing: 12) {
                                            Image(systemName: "star")
                                                .font(.system(size: 48))
                                                .foregroundColor(.white.opacity(0.3))
                                            
                                            Text("暂无收藏的笔记")
                                                .font(.system(size: 14))
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .padding(.vertical, 32)
                                    } else {
                                        VStack(spacing: 12) {
                                            ForEach(foldersWithFavorites) { folder in
                                                // 文件夹行
                                                Button(action: {
                                                    withAnimation {
                                                        if expandedFavoriteFolders.contains(folder.id) {
                                                            expandedFavoriteFolders.remove(folder.id)
                                                        } else {
                                                            expandedFavoriteFolders.insert(folder.id)
                                                        }
                                                    }
                                                }) {
                                                    GlassCard {
                                                        HStack(spacing: 12) {
                                                            Image(systemName: expandedFavoriteFolders.contains(folder.id) ? "chevron.down" : "chevron.right")
                                                                .font(.system(size: 16))
                                                                .foregroundColor(.white.opacity(0.7))
                                                            
                                                            Text(folder.icon)
                                                                .font(.system(size: 18))
                                                            
                                                            Text(folder.title)
                                                                .font(.system(size: 15, weight: .medium))
                                                                .foregroundColor(.white)
                                                            
                                                            Spacer()
                                                            
                                                            Button(action: {
                                                                toggleFavorite(folder.id)
                                                            }) {
                                                                Image(systemName: isFolderFavorited(folder) ? "star.fill" : "star")
                                                                    .font(.system(size: 14))
                                                                    .foregroundColor(isFolderFavorited(folder) ? .yellow : .white.opacity(0.7))
                                                            }
                                                        }
                                                        .padding(12)
                                                    }
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                
                                                // 展开后显示收藏的笔记
                                                if expandedFavoriteFolders.contains(folder.id) {
                                                    ForEach(getFavoritedNotes(in: folder)) { note in
                                                        NoteRow(
                                                            note: note,
                                                            isFavorited: true,
                                                            onTap: { onLibraryNoteClick(note.id) },
                                                            onFavorite: { toggleFavorite(note.id) },
                                                            onMore: { actionSheetId = note.id }
                                                        )
                                                        .padding(.leading, 24)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(12)
                                    }
                                }
                            }
                        }
                        
                        // My Notes Card
                        GlassCard {
                            VStack(spacing: 0) {
                                HStack {
                                    Button(action: {
                                        withAnimation {
                                            isMyNotesExpanded.toggle()
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: isMyNotesExpanded ? "chevron.down" : "chevron.right")
                                                .font(.system(size: 20))
                                                .foregroundColor(.white.opacity(0.7))
                                            
                                            Text("我的笔记")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        addFolderSheetId = "my-notes"
                                    }) {
                                        Text("+")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                            .frame(width: 32, height: 32)
                                            .background(.white.opacity(0.2))
                                            .clipShape(Circle())
                                    }
                                }
                                .padding(16)
                                
                                if isMyNotesExpanded {
                                    Divider()
                                        .background(.white.opacity(0.2))
                                    
                                    VStack(spacing: 12) {
                                        ForEach(personalLibrary) { folder in
                                            FolderRow(
                                                folder: folder,
                                                isExpanded: expandedFolders.contains(folder.id),
                                                isFavorited: favorites.contains(folder.id),
                                                onTap: { toggleFolder(folder.id) },
                                                onFavorite: { toggleFavorite(folder.id) },
                                                onMore: { actionSheetId = folder.id }
                                            )
                                            
                                            if expandedFolders.contains(folder.id), let children = folder.children {
                                                ForEach(children) { child in
                                                    NoteRow(
                                                        note: child,
                                                        isFavorited: favorites.contains(child.id),
                                                        onTap: { onLibraryNoteClick(child.id) },
                                                        onFavorite: { toggleFavorite(child.id) },
                                                        onMore: { actionSheetId = child.id }
                                                    )
                                                    .padding(.leading, 24)
                                                }
                                            }
                                        }
                                    }
                                    .padding(12)
                                }
                            }
                        }
                        .id("myNotesSection") // 将ID放在"我的笔记"卡片上
                        
                        // Uncategorized Notes Card
                        GlassCard {
                            VStack(spacing: 0) {
                                Button(action: {
                                    withAnimation {
                                        isUncategorizedExpanded.toggle()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: isUncategorizedExpanded ? "chevron.down" : "chevron.right")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        Text("未分类笔记")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .padding(16)
                                }
                                
                                if isUncategorizedExpanded {
                                    Divider()
                                        .background(.white.opacity(0.2))
                                    
                                    VStack(spacing: 12) {
                                        ForEach(uncategorizedNotes) { note in
                                            NoteRow(
                                                note: note,
                                                isFavorited: false,
                                                showFavoriteButton: false,
                                                onTap: { categorySheetNoteId = note.id },
                                                onFavorite: { },
                                                onMore: { actionSheetId = note.id }
                                            )
                                        }
                                    }
                                    .padding(12)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 150) // 为 TabBar 留出足够空间，防止遮挡
            }
            .scrollIndicators(.hidden)
        }
        .sheet(item: Binding(
            get: { actionSheetId.map { ActionSheetItem(id: $0) } },
            set: { actionSheetId = $0?.id }
        )) { item in
            ActionSheetView(
                isFavorited: favorites.contains(item.id),
                onFavorite: { toggleFavorite(item.id) },
                onDelete: { 
                    print("🗑️ 删除笔记: \(item.id)")
                    onDeleteNote(item.id)
                    actionSheetId = nil
                }
            )
        }
        .sheet(item: Binding(
            get: { addFolderSheetId.map { AddFolderSheetItem(id: $0) } },
            set: { addFolderSheetId = $0?.id }
        )) { _ in
            AddFolderSheetView(onAddFolder: { name in
                let newFolder = Folder(
                    title: name,
                    icon: "📁",
                    children: []
                )
                personalLibrary.append(newFolder)
                addFolderSheetId = nil
            })
        }
        .sheet(item: Binding(
            get: { categorySheetNoteId.map { CategorySheetItem(id: $0) } },
            set: { categorySheetNoteId = $0?.id }
        )) { item in
            CategorySheetView(
                categories: personalLibrary.map { CategoryItem(id: $0.id, title: $0.title, icon: $0.icon) },
                onSelectCategory: { categoryId in
                    print("🔍 选择分类，调用回调")
                    onMoveNoteToFolder(item.id, categoryId)
                    categorySheetNoteId = nil
                }
            )
        }
    }
    
    private func toggleFolder(_ id: String) {
        withAnimation {
            if expandedFolders.contains(id) {
                expandedFolders.remove(id)
            } else {
                expandedFolders.insert(id)
            }
        }
    }
    
    private func toggleFavorite(_ id: String) {
        withAnimation {
            // 检查是否是文件夹
            if let folder = personalLibrary.first(where: { $0.id == id }) {
                // 这是一个文件夹
                if favorites.contains(id) {
                    // 取消收藏文件夹：移除文件夹和其所有子笔记的收藏
                    favorites.remove(id)
                    if let children = folder.children {
                        for child in children {
                            favorites.remove(child.id)
                        }
                    }
                } else {
                    // 收藏文件夹：添加文件夹和其所有子笔记到收藏
                    favorites.insert(id)
                    if let children = folder.children {
                        for child in children {
                            favorites.insert(child.id)
                        }
                    }
                }
            } else {
                // 这是一个笔记，单独切换收藏状态
                if favorites.contains(id) {
                    favorites.remove(id)
                } else {
                    favorites.insert(id)
                }
            }
        }
    }
}

struct ActionSheetItem: Identifiable {
    let id: String
}

struct AddFolderSheetItem: Identifiable {
    let id: String
}

struct CategorySheetItem: Identifiable {
    let id: String
}

struct CategoryItem: Identifiable {
    let id: String
    let title: String
    let icon: String
}

#Preview {
    struct PreviewWrapper: View {
        @State var library = [
            Folder(id: "1", title: "Interview", icon: "📁", children: [
                Note(id: "1-1", title: "Technical Interview Notes", icon: "📄"),
                Note(id: "1-2", title: "Behavioral Questions", icon: "📄")
            ]),
            Folder(id: "11", title: "神经网络学习", icon: "🧠", children: [
                Note(id: "11-1", title: "yolo模型与cnn", icon: "📄")
            ])
        ]
        @State var uncategorized = [
            Note(id: "unc-1", title: "随手记录 - 项目想法", icon: "📝"),
            Note(id: "unc-2", title: "临时笔记", icon: "📝")
        ]
        @State var recentNotes = [
            Note(id: "1-1", title: "Technical Interview Notes", icon: "📄"),
            Note(id: "11-1", title: "yolo模型与cnn", icon: "📄")
        ]
        
        var body: some View {
            ZStack {
                LinearGradient(
                    colors: [Color.noteyBackgroundStart, Color.noteyBackgroundEnd],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                BackgroundBlobsView()
                
                LibraryView(
                    personalLibrary: $library,
                    uncategorizedNotes: $uncategorized,
                    recentlyClassifiedNotes: $recentNotes,
                    onMoveNoteToFolder: { noteId, folderId in
                        print("📦 Preview: 移动笔记 \(noteId) 到文件夹 \(folderId)")
                        
                        // 在预览中也实现真实的移动逻辑
                        guard let noteIndex = uncategorized.firstIndex(where: { $0.id == noteId }) else {
                            print("❌ Preview: 未找到笔记")
                            return
                        }
                        
                        let note = uncategorized[noteIndex]
                        print("✅ Preview: 找到笔记 \(note.title)")
                        
                        guard let folderIndex = library.firstIndex(where: { $0.id == folderId }) else {
                            print("❌ Preview: 未找到文件夹")
                            return
                        }
                        
                        print("✅ Preview: 找到文件夹 \(library[folderIndex].title)")
                        
                        if library[folderIndex].children == nil {
                            library[folderIndex].children = []
                        }
                        library[folderIndex].children?.append(note)
                        uncategorized.remove(at: noteIndex)
                        
                        // 添加到最近笔记
                        recentNotes.insert(note, at: 0)
                        if recentNotes.count > 8 {
                            recentNotes = Array(recentNotes.prefix(8))
                        }
                        
                        print("✅ Preview: 移动完成，剩余未分类: \(uncategorized.count)")
                    },
                    onDeleteNote: { noteId in
                        print("🗑️ Preview: 删除笔记 \(noteId)")
                        
                        // 检查是否是文件夹
                        if let folderIndex = library.firstIndex(where: { $0.id == noteId }) {
                            library.remove(at: folderIndex)
                            print("✅ Preview: 删除文件夹")
                            return
                        }
                        
                        // 在文件夹中查找并删除笔记
                        for (folderIndex, folder) in library.enumerated() {
                            if let children = folder.children,
                               let noteIndex = children.firstIndex(where: { $0.id == noteId }) {
                                library[folderIndex].children?.remove(at: noteIndex)
                                print("✅ Preview: 删除笔记")
                                return
                            }
                        }
                    },
                    onLibraryNoteClick: { _ in },
                    onUncategorizedNoteClick: { _ in }
                )
            }
        }
    }
    
    return PreviewWrapper()
}
