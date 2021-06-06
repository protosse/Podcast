//
//  AudioPlayerManager.swift
//  Podcast
//
//  Created by liuliu on 2021/6/2.
//

import ACBAVPlayer
import Combine
import Kingfisher
import UIKit

enum AudioPlayMode: Int, CaseIterable {
    case normal
    case `repeat`
    case repeatAll
    case shuffle

    var imageName: String {
        switch self {
        case .normal:
            return "arrow.clockwise"
        case .repeat:
            return "repeat.1"
        case .repeatAll:
            return "repeat"
        case .shuffle:
            return "shuffle"
        }
    }

    func next() -> AudioPlayMode {
        return self == .shuffle ? .normal : AudioPlayMode(rawValue: rawValue + 1)!
    }
}

class AudioPlayerManager: ObservableObject, HasSubscriptions {
    static let share = AudioPlayerManager()

    lazy var player = AudioPlayer().then {
        $0.delegate = self
    }

    lazy var analyzer = RealtimeAnalyzer()

    @Published var spectra: [[Float]] = []

    @Published var isPlaying = false
    @Published var currentItemDuration: TimeInterval = 0
    @Published var currentPlayTime: TimeInterval = 0
    @Published var currentProgress: Double = 0 // 0~100
    @Published var mode: AudioPlayMode = .normal

    @Published var currentEpisode: Episode?
    var episodesQueue: [Episode] = []

    var episodeLastPlay: EpisodeLastPlay = EpisodeLastPlay.default()
    
    init() {
        if !episodeLastPlay.episodeStreamUrl.isNilOrEmpty {
            currentEpisode = episodeLastPlay.episode
        }
        
        $currentEpisode
            .dropFirst()
            .sink { episode in
                guard let episode = episode, let lastPlay = self.episodeLastPlay.replace(episode: episode) else { return }
                self.episodeLastPlay = lastPlay
            }
            .store(in: &subscriptions)
    }

    func play(episode: Episode) {
        if player.state == .playing, let current = currentEpisode, current.streamUrl == episode.streamUrl {
            return
        }

        if let url = episode.playUrl, let item = play(url: url, seekToTime: episode.playedTime) {
            episodesQueue.append(episode)
            item.title = episode.title
            item.artist = episode.author
            if let imageUrl = episode.imageUrl, let imageLink = URL(string: imageUrl) {
                KingfisherManager.shared.downloader.downloadImage(with: imageLink) { result in
                    switch result {
                    case let .success(success):
                        item.artworkImage = success.image
                    default:
                        break
                    }
                }
            }
        }
    }

    @discardableResult
    func play(url: URL, seekToTime: TimeInterval = 0) -> AudioItem? {
        guard let item = AudioItem(mediumQualitySoundURL: url) else { return nil }
        player.player?.isMeteringEnabled = false
        player.player?.stop()
        delay(0.1) {
            self.player.play(item: item)
            if seekToTime > 0 {
                self.player.seek(to: seekToTime)
            }

            self.player.player?.isMeteringEnabled = true
            self.player.player?.audioPCMBufferFetched(callbackBlock: { [weak self] buffer, _ in
                guard let self = self, let buffer = buffer else { return }
                self.analyzer.config(fftSize: Int(buffer.frameLength))
                DispatchQueue.main.async {
                    self.spectra = self.analyzer.analyse(with: buffer)
                }
            })
        }
        return item
    }

    func pauseOrResume() {
        if player.state == .playing {
            player.pause()
        } else if player.state == .paused {
            player.resume()
        } else if let currentEpisode = currentEpisode {
            play(episode: currentEpisode)
        }
    }

    func next() {
        if player.hasNext {
            player.next()
        }
    }

    func previous() {
        if player.hasPrevious {
            player.previous()
        }
    }

    func modeLoop() {
        mode = mode.next()
        switch mode {
        case .normal:
            player.mode = .normal
        case .repeat:
            player.mode = .repeat
        case .repeatAll:
            player.mode = .repeatAll
        case .shuffle:
            player.mode = .shuffle
        }
    }

    func seek(timeOffset: TimeInterval) {
        player.seek(to: timeOffset + currentPlayTime)
    }

    func seek(progress: Double) {
        if currentItemDuration > 0 {
            player.seek(to: currentItemDuration * progress / 100)
        }
    }

    func add(episodes: [Episode]) {
        let items = episodes.compactMap { AudioItem(mediumQualitySoundURL: $0.playUrl) }
        player.add(items: items)
        episodesQueue.append(contentsOf: episodes)
    }

    func delete(episodes: [Episode]) {
        for episode in episodes {
            if let index = player.items?.firstIndex(where: { $0.mediumQualityURL.url == episode.playUrl }) {
                player.removeItem(at: index)
            }
            episodesQueue.removeFirst(where: { $0.streamUrl == episode.streamUrl })
        }
    }

    func clear() {
        guard let items = player.items, !items.isEmpty else {
            return
        }
        let range: [Int] = Array(0 ..< items.count).reversed()
        for i in range {
            player.removeItem(at: i)
        }
        episodesQueue.removeAll()
    }

    func remoteControlReceived(with event: UIEvent) {
        player.remoteControlReceived(with: event)
    }
}

extension AudioPlayerManager: AudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayer, willStartPlaying item: AudioItem) {
        currentEpisode = episodesQueue.first(where: { $0.playUrl == item.mediumQualityURL.url })
    }

    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState) {
        isPlaying = state == .playing
    }

    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
        currentPlayTime = time
        currentProgress = Double(percentageRead)
    }

    func audioPlayer(_ audioPlayer: AudioPlayer, didFindDuration duration: TimeInterval, for item: AudioItem) {
        currentItemDuration = duration
    }
}
