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

    var isSaved = false
    var summary: String?

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< trackId <-- ["id", "trackId"]
        mapper <<< trackName <-- ["trackName", "name"]
    }
}

extension Podcast: FetchableRecord, MutablePersistableRecord {
    enum Columns: String, ColumnExpression {
        case id, trackId, artistName, trackName, feedUrl, artworkUrl100, releaseDate, summary
    }

    init(row: Row) {
        trackId = row[Columns.trackId]
        artistName = row[Columns.artistName]
        trackName = row[Columns.trackName]
        feedUrl = row[Columns.feedUrl]
        artworkUrl100 = row[Columns.artworkUrl100]
        releaseDate = row[Columns.releaseDate]
        summary = row[Columns.summary]
    }

    func encode(to container: inout PersistenceContainer) {
        container[Columns.trackId] = trackId
        container[Columns.artistName] = artistName
        container[Columns.trackName] = trackName
        container[Columns.feedUrl] = feedUrl
        container[Columns.artworkUrl100] = artworkUrl100
        container[Columns.releaseDate] = releaseDate
        container[Columns.summary] = summary
    }

    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
