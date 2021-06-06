//
//  DBManager.swift
//  Podcast
//
//  Created by liuliu on 2021/6/3.
//

import GRDB

class DB {
    static let share = DB()

    var dbQueue: DatabaseQueue?

    init() {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            log.warning("get documentPath failed.")
            return
        }
        let dbPath = documentPath.appendingPathComponent("database.sqlite")
        log.debug("dbPath: \(dbPath)")
        let config = Configuration()
        dbQueue = try? DatabaseQueue(path: dbPath, configuration: config)

        Database.logError = { resultCode, message in
            log.debug("%@", "SQLite error \(resultCode): \(message)")
        }

        migrate()
    }

    func migrate() {
        do {
            guard let queue = dbQueue else {
                log.error("get dbQueue error")
                return
            }
            var migrator = DatabaseMigrator()
            migrator.registerMigration("init") { db in
                try db.create(table: "podcast") { t in
                    t.column("id", .text).unique().primaryKey()
                    t.column("artistName", .text)
                    t.column("trackName", .text)
                    t.column("feedUrl", .text)
                    t.column("artworkUrl30", .text)
                    t.column("artworkUrl60", .text)
                    t.column("artworkUrl100", .text)
                    t.column("artworkUrl600", .text)
                    t.column("releaseDate", .text)
                    t.column("isCollected", .boolean)
                    t.column("summary", .text)
                }

                try db.create(table: "episode") { t in
                    t.column("streamUrl", .text).unique().primaryKey()
                    t.column("link", .text)
                    t.column("title", .text)
                    t.column("pubDate", .date)
                    t.column("desc", .text)
                    t.column("author", .text)
                    t.column("imageUrl", .text)
                    t.column("duration", .double)
                    t.column("playedTime", .double)
                    t.column("fileUrl", .text)
                    t.column("podcastId", .integer)
                        .notNull()
                        .indexed()
                        .references("podcast", onDelete: .cascade)
                }
            }

            migrator.registerMigration("lastPlay") { db in
                try db.create(table: "episodeLastPlay") { t in
                    t.autoIncrementedPrimaryKey("id")
                    t.column("episodeStreamUrl", .text)
                        .notNull()
                        .references("episode", onDelete: .cascade)
                }
            }

            try migrator.migrate(queue)
        } catch {
            log.debug("migrate error")
        }
    }

    func clearUnImportant() {
        dbQueue?.asyncWrite({ db in
            let podcasts = Podcast.filter(Podcast.Columns.isCollected != true)
            try podcasts.fetchAll(db).forEach { try $0.request(for: Podcast.episodes).deleteAll(db) }
            try podcasts.deleteAll(db)
        }, completion: { _, _ in

        })
    }
}
