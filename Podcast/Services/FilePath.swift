//
//  FilePath.swift
//  Podcast
//
//  Created by liuliu on 2021/6/7.
//

import FileKit

class FilePath {
    static let share = FilePath()
    static let rootPath = Path.userDocuments
    
    enum Directory: String, CaseIterable {
        case episode
        
        var path: Path {
            return FilePath.rootPath + self.rawValue
        }
    }
    
    init() {
        Directory.allCases.forEach {
            let path = $0.path
            if !path.exists {
                try? path.createDirectory()
            }
        }
    }
    
    func save(episode fileUrl: String) -> String? {
        let cache = Path(fileUrl)
        guard cache.exists else {
            return nil
        }
        let path = cache.copyFileOverride(toDir: Directory.episode.path)
        return path.standardRawValue
    }
    
    func delete(episode fileUrl: String) {
        let path = Path(fileUrl)
        try? path.deleteFile()
    }
}
