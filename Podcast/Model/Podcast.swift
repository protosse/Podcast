//
//  Podcast.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import Foundation

class Podcast: Codable {
    var artistName: String?
    var trackName: String?
    var feedURL: String?
    var artworkUrl30: String?
    var artworkUrl60: String?
    var artworkUrl100: String?
    var artworkUrl600: String?
    var releaseDate: Date?
    var trackCount = 0
    var primaryGenreName: String?

    var lastUpdateString: String?
    var summary: String?
    var isSaved = false

    enum CodingKeys: String, CodingKey {
        case artistName = "artistName"
        case trackName = "trackName"
        case feedURL = "feedUrl"
        case artworkUrl30 = "artworkUrl30"
        case artworkUrl60 = "artworkUrl60"
        case artworkUrl100 = "artworkUrl100"
        case artworkUrl600 = "artworkUrl600"
        case releaseDate = "releaseDate"
        case trackCount = "trackCount"
        case primaryGenreName = "primaryGenreName"
    }
}
