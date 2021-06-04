//
//  Episode.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import FeedKit

struct Episode: Identifiable {
    var id: Int64 = 0
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

    init() {}

    init(feedItem: RSSFeedItem) {
        title = feedItem.title
        pubDate = feedItem.pubDate ?? Date()
        desc = feedItem.content?.contentEncoded ?? feedItem.iTunes?.iTunesSummary
        author = feedItem.iTunes?.iTunesAuthor
        imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
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
