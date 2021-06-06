//
//  MiniPlayerView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import SwiftUI
import Combine
import Kingfisher

struct MiniPlayerView: View {
    private let buttonWidth: CGFloat = 54
    @State private var progress: CGFloat = 0
    @ObservedObject var audioPlayerManager = AudioPlayerManager.share

    var body: some View {
        GeometryReader { g in
            VStack {
                Spacer()
                VStack {
                    HStack {
                        KFImage(URL(string: audioPlayerManager.currentEpisode?.imageUrl ?? ""))
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text(audioPlayerManager.currentEpisode?.title ?? "")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Spacer()
                    }
                    .visualEffect()
                    .frame(height: 80)
                    .overlay({
                        PlayButton(width: buttonWidth, progress: $progress,
                                   isPlaying: $audioPlayerManager.isPlaying)
                            .offset(x: -50, y: -buttonWidth / 2)
                    }(), alignment: .topTrailing)
                    .onTapGesture {
                    }
                    Spacer().frame(height: g.safeAreaInsets.bottom)
                }
                .background(Color(.white).opacity(0.1))
            }
            .edgesIgnoringSafeArea(.bottom)
        }.onLoad(perform: onLoad)
    }
    
    func onLoad() {
        progress = CGFloat(audioPlayerManager.currentProgress) / 100.0
    }
}

struct PlayButton: View {
    var width: CGFloat = 54
    @Binding var progress: CGFloat
    @Binding var isPlaying: Bool

    private let lineWidth: CGFloat = 5

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: min(self.progress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                           lineCap: .round,
                                           lineJoin: .round))
                .foregroundColor(.accentColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Button(action: {}) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }
            .frame(width: width - lineWidth, height: width - lineWidth)
            .background(Color.white)
            .clipShape(Circle())
        }
        .frame(width: width, height: width)
    }
}

struct MiniPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(R.color.defaultBackground.name).ignoresSafeArea()
            MiniPlayerView()
                .previewLayout(.sizeThatFits)
        }
    }
}
