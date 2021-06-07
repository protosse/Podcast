//
//  PathExtensions.swift
//  Podcast
//
//  Created by liuliu on 2021/6/7.
//

import FileKit

extension Path {
    @discardableResult
    func moveFileOverride(toDir path: Path) -> Path {
        let p = path + fileName
        if self != p {
            if p.exists {
                try? p.deleteFile()
            }
            try? moveFile(to: p)
        }
        return p
    }

    @discardableResult
    func copyFileOverride(toDir path: Path) -> Path {
        let p = path + fileName
        if self != p {
            if p.exists {
                try? p.deleteFile()
            }
            try? copyFile(to: p)
        }
        return p
    }
}
