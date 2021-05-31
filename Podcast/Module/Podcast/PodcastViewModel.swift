//
//  PodcastViewModel.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import Combine
import Foundation

class PodcastViewModel: ObservableObject, HasSubscriptions {
    var podcast: Podcast

    @Published var searchText = ""
    @Published var dataSource: [Episode] = []

    init(podcast: Podcast) {
        self.podcast = podcast
    }

    func fetchEpisode() {
        guard let id = podcast.id else {
            return
        }

        let fetch = (podcast.feedUrl.isNilOrEmpty ? ITunesService.share.lookUp(id) : Just(podcast).mapNetError())
            .flatMap { Just(ITunesService.share.fetchEpisodes(podcast: $0)) }
            .share()

        fetch
            .flatMap { $0.0 }
            .sink { completeion in
                switch completeion {
                case .finished:
                    print(#function, "finished")
                case let .failure(error):
                    print(#function, error)
                }
            } receiveValue: { data in
                self.dataSource = data
            }
            .store(in: &subscriptions)
    }
}
