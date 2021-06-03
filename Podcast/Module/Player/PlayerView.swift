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
    @ObservedObject var audioPlayerManager = AudioPlayerManager.share

    @State var htmlHeight: CGFloat = 0

    init(episode: Episode) {
        viewModel = PlayerViewModel(episode: episode)
    }

    var body: some View {
        let url = URL(string: viewModel.episode.imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        return VStack {
            SpectrumView(spectra: $audioPlayerManager.spectra)
                .frame(height: 50)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    KFImage(url)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                    HStack {
                        Text(viewModel.episode.title ?? "")
                            .font(.system(size: 16))
                        Spacer(minLength: 10)
                        Button(action: {}) {
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
        }
        .onLoad(perform: load)
    }

    func load() {
//        audioPlayerManager.play(episode: viewModel.episode)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let episode = Episode()
        episode.title = "25位小朋友眼里的成人世界"
        episode.author = "kouaizhe"
        episode.imageUrl = "https://static.storyfm.cn/media/2020/01/600x600-满.jpg"
        episode.streamUrl = "https://static.storyfm.cn/media/2021/05/beijing-metro-youth-guide-1.mp3"
        episode.duration = 1277
        return PlayerView(episode: episode)
    }
}
