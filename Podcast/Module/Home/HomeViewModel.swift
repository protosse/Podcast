//
//  HomeViewModel.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import Combine
import Foundation
import GRDB

class HomeViewModel: HasSubscriptions, ObservableObject {
    @Published var dataSource: [Podcast] = []
    
    func request() {
        self.dataSource = Podcast.collectedPodcast() ?? []
    }
}
