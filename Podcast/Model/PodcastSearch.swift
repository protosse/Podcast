//
//  PodcastSearch.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import Foundation

struct PodcastSearch: Codable {
    let resultCount: Int?
    let results: [Podcast]?
}
