//
//  PlayerViewModel.swift
//  Podcast
//
//  Created by liuliu on 2021/6/2.
//

import Combine
import Foundation

class PlayerViewModel: ObservableObject, HasSubscriptions {
    var episode: Episode
    
    init(episode: Episode) {
        self.episode = episode
    }
}
