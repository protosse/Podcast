//
//  Podcast.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import HandyJSON

class Podcast: HandyJSON, Identifiable {
    var artistName: String?
    var trackName: String?
    var feedUrl: String?
    var artworkUrl30: String?
    var artworkUrl60: String?
    var artworkUrl100: String?
    var artworkUrl600: String?
    var releaseDate: String?
    var trackCount = 0
    var primaryGenreName: String?

    var lastUpdateString: String?
    var summary: String?
    var isSaved = false

    func mapping(mapper: HelpingMapper) {
        mapper <<< trackName <-- ["trackName", "name"]
    }

    required init() {}
}
