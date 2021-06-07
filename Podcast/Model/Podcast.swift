//
//  Podcast.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import Combine
import GRDB
import HandyJSON

enum ArtworkQuality: Int, CaseIterable {
    case Large
    case High
    case Medium
    case Low

    func next() -> ArtworkQuality {
        return self == .Low ? .Large : ArtworkQuality(rawValue: rawValue + 1)!
    }
}

final class Podcast: HandyJSON, Identifiable {
    var id = UUID()

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

    func mapping(mapper: HelpingMapper) {
        mapper <<< trackId <-- ["id", "trackId"]
        mapper <<< trackName <-- ["trackName", "name"]
    }

    func artworkUrl(_ artworkQuality: ArtworkQuality = .High) -> String {
        let artworkUrls: [ArtworkQuality: String?] = [.High: artworkUrl100, .Medium: artworkUrl60, .Low: artworkUrl30, .Large: artworkUrl600]
        var url = artworkUrls[artworkQuality] ?? nil
        if url.isNilOrEmpty {
            var quality = artworkQuality.next()
            while quality != artworkQuality && url.isNilOrEmpty {
                url = artworkUrls[quality] ?? nil
                quality = quality.next()
            }
        }
        return url ?? ""
    }
    
    required init() {}
}

extension Podcast: FetchableRecord, PersistableRecord {
    static var databaseTableName = "podcast"
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: .replace)

    enum Columns: String, ColumnExpression {
        case id, artistName, trackName, feedUrl, artworkUrl30, artworkUrl60, artworkUrl100, artworkUrl600, releaseDate, isCollected, summary
    }

    convenience init(row: Row) {
        self.init()
        trackId = row[Columns.id]
        artistName = row[Columns.artistName]
        trackName = row[Columns.trackName]
        feedUrl = row[Columns.feedUrl]
        artworkUrl30 = row[Columns.artworkUrl30]
        artworkUrl60 = row[Columns.artworkUrl60]
        artworkUrl100 = row[Columns.artworkUrl100]
        artworkUrl600 = row[Columns.artworkUrl600]
        releaseDate = row[Columns.releaseDate]
        isCollected = row[Columns.isCollected]
        summary = row[Columns.summary]
    }

    func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = trackId
        container[Columns.artistName] = artistName
        container[Columns.trackName] = trackName
        container[Columns.feedUrl] = feedUrl
        container[Columns.artworkUrl30] = artworkUrl30
        container[Columns.artworkUrl60] = artworkUrl60
        container[Columns.artworkUrl100] = artworkUrl100
        container[Columns.artworkUrl600] = artworkUrl600
        container[Columns.releaseDate] = releaseDate
        container[Columns.isCollected] = isCollected
        container[Columns.summary] = summary
    }
}

extension Podcast {
    static let episodes = hasMany(Episode.self)

    var episodes: [Episode]? {
        return try? DB.share.dbQueue?.read({ db in
            let data = try self.request(for: Podcast.episodes).fetchAll(db)
            return data
        })
    }

    static func collectedPodcast() -> [Podcast]? {
        return try? DB.share.dbQueue?.read({ db in
            let data = try Podcast.filter(Columns.isCollected == true).fetchAll(db)
            return data
        })
    }

    static func fetch(id: String) -> Podcast? {
        return try? DB.share.dbQueue?.read({ db in
            try Podcast.fetchOne(db, key: id)
        })
    }

    func updateDB() {
        do {
            try DB.share.dbQueue?.write({ db in
                try self.update(db)
            })
        } catch let e {
            log.error(e.localizedDescription)
        }
    }

    func updateDB(episodes: [Episode]) {
        DB.share.dbQueue?.asyncWrite({ [weak self] db in
            try self?.insert(db)
            for episode in episodes {
                try episode.insert(db)
            }
        }, completion: { _, _ in

        })
    }
}
