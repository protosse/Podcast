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

    @Published var searchText = ""

    var tapSubject = PassthroughSubject<String, Never>()
    var searchSubject = PassthroughSubject<String, Never>()
    
    func bind() {
        tapSubject
            .dropFirst()
            .sink { [weak self] str in
                self?.searchText = str
                self?.search()
            }
            .store(in: &subscriptions)
    }

    func requestTopPodcasts() {
        guard topDataSource.isEmpty else {
            dataSource = topDataSource
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

    func search(loadMore: Bool = false) {
        if loadMore {
            page += 1
        } else {
            page = 1
        }

        searchSubject.send(searchText)
        ITunesService.share
            .search(searchText, page: page)
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
