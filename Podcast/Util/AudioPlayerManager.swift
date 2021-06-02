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

class AudioPlayerManager: ObservableObject {
    static let share = AudioPlayerManager()

    lazy var player = AudioPlayer().then {
        $0.delegate = self
    }

    lazy var analyzer = RealtimeAnalyzer()

    var isPrepared: Bool {
        return player.currentItem != nil
    }

    @Published var spectra: [[Float]] = []

    var currentEpisode: Episode?

    func play(episode: Episode) {
        if player.state == .playing, let current = currentEpisode, current.streamUrl == episode.streamUrl {
            return
        }

        var url: URL?
        if let fileUrl = episode.fileUrl {
            let link = URL(fileURLWithPath: fileUrl)
            url = link
        } else if let streamUrl = episode.streamUrl, let link = URL(string: streamUrl) {
            url = link
        }
        if let url = url, let item = play(url: url, seekToTime: episode.playedTime) {
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
        }
    }

    func seek(timeOffset: TimeInterval) {
    }

    func remoteControlReceived(with event: UIEvent) {
    }
}

extension AudioPlayerManager: AudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState) {
    }

    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
    }

    func audioPlayer(_ audioPlayer: AudioPlayer, didFindDuration duration: TimeInterval, for item: AudioItem) {
    }
}
