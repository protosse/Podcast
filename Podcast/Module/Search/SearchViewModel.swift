//
//  SearchViewModel.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject, HasSubscriptions {
    @Published var dataSource: [TopPodcast] = []

    func request() {
        ITunesService.share
            .topPodcasts(limit: 50, country: .cn)
            .sink { _ in } receiveValue: { [weak self] data in
                self?.dataSource = data
            }
            .store(in: &subscriptions)
    }
}
