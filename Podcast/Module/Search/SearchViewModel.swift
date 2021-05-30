//
//  SearchViewModel.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject, HasSubscriptions {
    var topDataSource: [Podcast] = []
    @Published var dataSource: [Podcast] = []
    var page = 1

    func requestTopPodcasts() {
        guard topDataSource.isEmpty else {
            self.dataSource = topDataSource
            return
        }
        ITunesService.share
            .topPodcasts(limit: 20, country: .cn)
            .sink { completeion in
                switch completeion {
                case .finished:
                    print(#function, "finished")
                case let .failure(error):
                    print(#function, error)
                }
            } receiveValue: { [weak self] data in
                self?.topDataSource = data
                self?.dataSource = data
            }
            .store(in: &subscriptions)
    }

    func search(text: String, loadMore: Bool = false) {
        if loadMore {
            page += 1
        } else {
            page = 1
        }

        ITunesService.share
            .search(text, page: page)
            .sink { completeion in
                switch completeion {
                case .finished:
                    print(#function, "finished")
                case let .failure(error):
                    print(#function, error)
                }
            } receiveValue: { [weak self] data in
                self?.dataSource = data
            }
            .store(in: &subscriptions)
    }
}
