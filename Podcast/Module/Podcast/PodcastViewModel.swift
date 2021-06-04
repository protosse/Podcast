//
//  PodcastViewModel.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import Combine
import Foundation

class PodcastViewModel: ObservableObject, HasSubscriptions {
    @Published var podcast: Podcast

    @Published var searchText = ""
    @Published var refreshState: StatefulViewControllerState = .content
    @Published var dataSource: [Episode] = []
    @Published var progress: Double = 0

    init(podcast: Podcast) {
        self.podcast = podcast
    }

    func fetchEpisode() {
        guard let id = podcast.trackId else {
            refreshState = .content
            return
        }

        refreshState = .loading
        let fetch = (podcast.feedUrl.isNilOrEmpty ? ITunesService.share.lookUp(id) : Just(podcast).mapNetError())
            .handleEvents(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.refreshState = .error
                case .finished:
                    break
                }
            })
            .flatMap { Just(ITunesService.share.fetchEpisodes(feedUrl: $0.feedUrl!)) }
            .share()

        fetch
            .flatMap { $0.0 }
            .sink { [weak self] completion in
                switch completion {
                case .failure:
                    self?.refreshState = .error
                case .finished:
                    break
                }
            } receiveValue: { [weak self] data, summary in
                guard let self = self else { return }
                self.podcast.summary = summary
                self.podcast = self.podcast
                self.podcast.updateInDB(episodes: data)
                self.refreshState = data.isEmpty ? .empty : .content
                self.dataSource = data
            }
            .store(in: &subscriptions)

        fetch
            .flatMap { $0.1 }
            .sink { _ in } receiveValue: { [weak self] progress in
                self?.progress = progress
            }
            .store(in: &subscriptions)
    }
}
