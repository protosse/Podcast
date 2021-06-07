//
//  PlayerView.swift
//  Podcast
//
//  Created by liuliu on 2021/6/2.
//

import Kingfisher
import SwiftUI
import UIKit
import WebKit

struct PlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager

    @State private var htmlHeight: CGFloat = 0

    @State private var isShowSet = false
    @State private var isShowPlayList = false

    init(episode: Episode) {
        viewModel = PlayerViewModel(episode: episode)
    }

    var body: some View {
        VStack {
            SpectrumView(spectra: $audioPlayerManager.spectra)
                .frame(height: 50)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    KFImage(URL(string: viewModel.episode.imageUrl))
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                    HStack {
                        Text(viewModel.episode.title ?? "")
                            .font(.system(size: 16))
                        Spacer(minLength: 10)
                        Button(action: play) {
                            Image(systemName: "play.fill")
                        }
                        .frame(width: 35, height: 35)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    }
                    Text(viewModel.episode.author ?? "")
                        .font(.system(size: 12))
                    WebViewRepresentable(htmlString: viewModel.episode.desc ?? "", dynamicHeight: $htmlHeight)
                        .frame(height: htmlHeight)
                }
                .padding(.all, 10)
            }

            PlayControlView {
                isShowSet.toggle()
            } onPlayListTap: {
                isShowPlayList.toggle()
            } onPlayTap: {
                play()
            }
        }
        .bottomSheet(isPresented: $isShowSet, height: 500) {
            PlaySetView()
        }
        .bottomSheet(isPresented: $isShowPlayList, height: 500) {
            PlayListView()
        }
    }

    func play() {
        audioPlayerManager.play(episode: viewModel.episode)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        var episode = Episode()
        episode.title = "25位小朋友眼里的成人世界"
        episode.author = "kouaizhe"
        episode.imageUrl = "https://static.storyfm.cn/media/2020/01/600x600-满.jpg"
        episode.streamUrl = "https://static.storyfm.cn/media/2021/05/beijing-metro-youth-guide-1.mp3"
        episode.duration = 1277
        return PlayerView(episode: episode)
    }
}
