//
//  Podcast.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import HandyJSON

class Podcast: HandyJSON, Identifiable {
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

    func mapping(mapper: HelpingMapper) {
        mapper <<< trackId <-- ["id", "trackId"]
        mapper <<< trackName <-- ["trackName", "name"]
    }
    
    func didFinishMapping() {
        
    }

    required init() {}
}
