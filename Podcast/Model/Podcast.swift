//
//  Podcast.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import GRDB
import HandyJSON

struct Podcast: HandyJSON, Identifiable {
    var id: Int64 = 0

    var trackId: String?
    var artistName: String?
    var trackName: String?
    var feedUrl: String?

    var artworkUrl30: String?
    var artworkUrl60: String?
    var artworkUrl100: String?
    var artworkUrl600: String?
    var releaseDate: String?

    var isCollected = false
    var summary: String?

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< trackId <-- ["id", "trackId"]
        mapper <<< trackName <-- ["trackName", "name"]
    }
}

extension Podcast: FetchableRecord, PersistableRecord {
    static var databaseTableName = "podcast"
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: .ignore)

    enum Columns: String, ColumnExpression {
        case id, artistName, trackName, feedUrl, artworkUrl100, releaseDate, isCollected, summary
    }

    init(row: Row) {
        trackId = row[Columns.id]
        artistName = row[Columns.artistName]
        trackName = row[Columns.trackName]
        feedUrl = row[Columns.feedUrl]
        artworkUrl100 = row[Columns.artworkUrl100]
        releaseDate = row[Columns.releaseDate]
        isCollected = row[Columns.isCollected]
        summary = row[Columns.summary]
    }

    func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = trackId
        container[Columns.artistName] = artistName
        container[Columns.trackName] = trackName
        container[Columns.feedUrl] = feedUrl
        container[Columns.artworkUrl100] = artworkUrl100
        container[Columns.releaseDate] = releaseDate
        container[Columns.isCollected] = isCollected
        container[Columns.summary] = summary
    }
}

extension Podcast {
    static let episodes = hasMany(Episode.self)
    var episodes: QueryInterfaceRequest<Episode> {
        request(for: Podcast.episodes)
    }

    func updateInDB(episodes: [Episode]) {
        DB.share.dbQueue?.asyncWrite({ db in
            try self.insert(db)
            for i in 0 ..< episodes.count {
                var episode = episodes[i]
                episode.podcastId = trackId
                try episode.insert(db)
            }
        }, completion: { _, _ in

        })
    }
}
