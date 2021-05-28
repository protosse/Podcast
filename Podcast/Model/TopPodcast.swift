//
//  TopPodcast.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import Foundation

class TopPodcast: Codable, Identifiable {
    var index: Int = 0
    var artistName, id, releaseDate, name: String?
    var kind: String?
    var copyright: String?
    var artistID: String?
    var artistURL: String?
    var artworkUrl100 = ""
    var url: String?
    var contentAdvisoryRating: String?

    enum CodingKeys: String, CodingKey {
        case artistName, id, releaseDate, name, kind, copyright
        case artistID = "artistId"
        case artistURL = "artistUrl"
        case artworkUrl100, url, contentAdvisoryRating
    }
}
