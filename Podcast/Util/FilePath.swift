//
//  FilePath.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import FileKit

class FilePath {
    static let share = FilePath()
    static let rootPath = Path.userDocuments
    
    enum Directory: String, CaseIterable {
        case podcast, cache
        
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
}
