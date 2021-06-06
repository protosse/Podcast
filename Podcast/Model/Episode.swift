//
//  Episode.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import FeedKit
import GRDB

struct Episode: Identifiable {
    var id = UUID()

    var title: String?
    var pubDate: Date?
    var desc: String?
    var author: String?
    var imageUrl: String?
    var link: String?
    var streamUrl: String?
    var duration: TimeInterval = 0

    var playedTime: TimeInterval = 0
    var fileUrl: String?

    var podcastId: String?

    init() {}

    init(feedItem: RSSFeedItem) {
        title = feedItem.title
        pubDate = feedItem.pubDate ?? Date()
        desc = feedItem.content?.contentEncoded ?? feedItem.iTunes?.iTunesSummary
        author = feedItem.iTunes?.iTunesAuthor
        imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        link = feedItem.link
        streamUrl = feedItem.enclosure?.attributes?.url
        duration = feedItem.iTunes?.iTunesDuration ?? 0
    }

    var playUrl: URL? {
        var url: URL?
        if let fileUrl = fileUrl {
            let link = URL(fileURLWithPath: fileUrl)
            url = link
        } else if let streamUrl = streamUrl, let link = URL(string: streamUrl) {
            url = link
        }
        return url
    }
}

extension RSSFeed {
    func toEpisodes() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href

        var episodes: [Episode] = []
        items?.forEach({ feedItem in
            var episode = Episode(feedItem: feedItem)

            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }

            episodes.append(episode)
        })

        if episodes.count > 1, let firstDate = episodes[0].pubDate, let secondDate = episodes[1].pubDate, firstDate < secondDate {
            return episodes.reversed()
        } else {
            return episodes
        }
    }
}

extension Episode: FetchableRecord, PersistableRecord {
    static var databaseTableName = "episode"
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: .ignore)

    enum Columns: String, ColumnExpression {
        case title, pubDate, desc, author, imageUrl, link, streamUrl, duration, playedTime, fileUrl, podcastId
    }

    init(row: Row) {
        title = row[Columns.title]
        pubDate = row[Columns.pubDate]
        desc = row[Columns.desc]
        author = row[Columns.author]
        imageUrl = row[Columns.imageUrl]
        link = row[Columns.link]
        streamUrl = row[Columns.streamUrl]
        duration = row[Columns.duration]
        playedTime = row[Columns.playedTime]
        fileUrl = row[Columns.fileUrl]
        podcastId = row[Columns.podcastId]
    }

    func encode(to container: inout PersistenceContainer) {
        container[Columns.title] = title
        container[Columns.pubDate] = pubDate
        container[Columns.desc] = desc
        container[Columns.author] = author
        container[Columns.imageUrl] = imageUrl
        container[Columns.link] = link
        container[Columns.streamUrl] = streamUrl
        container[Columns.duration] = duration
        container[Columns.playedTime] = playedTime
        container[Columns.fileUrl] = fileUrl
        container[Columns.podcastId] = podcastId
    }
}

extension Episode {
    static let podcast = belongsTo(Podcast.self)
    var podcast: QueryInterfaceRequest<Podcast> {
        request(for: Episode.podcast)
    }
}
