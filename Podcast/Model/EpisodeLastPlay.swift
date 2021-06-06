//
//  EpisodeLastPlay.swift
//  Podcast
//
//  Created by liuliu on 2021/6/6.
//

import GRDB

struct EpisodeLastPlay {
    var id: Int64 = 0
    var episodeStreamUrl: String?

    static func `default`() -> EpisodeLastPlay {
        do {
            return try DB.share.dbQueue?.read({ db in
                let data = try EpisodeLastPlay.fetchOne(db)
                return data ?? EpisodeLastPlay()
            }) ?? EpisodeLastPlay()
        } catch {
            return EpisodeLastPlay()
        }
    }
}

extension EpisodeLastPlay: FetchableRecord, PersistableRecord {
    static var databaseTableName = "episodeLastPlay"
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: .replace)

    enum Columns: String, ColumnExpression {
        case id, episodeStreamUrl
    }

    init(row: Row) {
        id = row[Columns.id]
        episodeStreamUrl = row[Columns.episodeStreamUrl]
    }

    func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.episodeStreamUrl] = episodeStreamUrl
    }
}

extension EpisodeLastPlay {
    static let episode = belongsTo(Episode.self)
    var episodeRequest: QueryInterfaceRequest<Episode> {
        request(for: EpisodeLastPlay.episode)
    }

    var episode: Episode? {
        return try? DB.share.dbQueue?.read({ db in
            let data = try self.episodeRequest.fetchOne(db)
            return data
        })
    }

    func replace(episode: Episode) -> EpisodeLastPlay? {
        return try? DB.share.dbQueue?.write({ db in
            let lastPlay = EpisodeLastPlay(id: 0, episodeStreamUrl: episode.streamUrl)
            try lastPlay.insert(db)
            return lastPlay
        })
    }
}
