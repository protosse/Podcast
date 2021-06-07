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

    @Published var isCollected = false

    init(podcast: Podcast) {
        self.podcast = podcast
    }

    func fetchEpisode() {
        guard let id = podcast.trackId else {
            refreshState = .content
            return
        }

        if let podcastInDB = Podcast.fetch(id: id), let episodes = podcastInDB.episodes, !episodes.isEmpty {
            isCollected = podcastInDB.isCollected
            podcast = podcastInDB
            dataSource = episodes
        } else {
            refreshState = .loading
        }

        var tempPodcast: Podcast!
        let fetch = ITunesService.share.lookUp(id)
            .handleEvents(receiveOutput: {
                tempPodcast = $0
            }, receiveCompletion: { [weak self] completion in
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
                tempPodcast.summary = summary
                tempPodcast.isCollected = self.isCollected
                self.podcast = tempPodcast
                for episode in data {
                    episode.podcastId = self.podcast.trackId
                }
                tempPodcast.updateDB(episodes: data)
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

    func collectToggle() {
        podcast.isCollected.toggle()
        isCollected = podcast.isCollected
        podcast.updateDB()
    }
}
