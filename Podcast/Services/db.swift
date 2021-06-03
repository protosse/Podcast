//
//  db.swift
//  Podcast
//
//  Created by liuliu on 2021/6/3.
//

import GRDB

class DB {
    static let share = DB()

    private var dbQueue: DatabaseQueue?

    init() {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            log.warning("get documentPath failed.")
            return
        }
        let dbPath = documentPath.appendingPathComponent("database.sqlite")
        log.debug("dbPath: \(dbPath)")
        dbQueue = try? DatabaseQueue(path: dbPath)

        try? dbQueue?.write({ db in
            try db.create(table: "podcast", body: { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("trackId", .text)
                t.column("artistName", .text)
                t.column("trackName", .text)
                t.column("feedUrl", .text)
                t.column("artworkUrl100", .text)
                t.column("releaseDate", .text)
                t.column("summary", .text)
            })
        })
    }
}

extension Podcast {
}
