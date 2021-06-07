//
//  MiniPlayerView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import Combine
import Kingfisher
import SwiftUI

struct MiniPlayerView: View {
    private let buttonWidth: CGFloat = 54
    @State private var isPresentPlay = false
    @State private var progress: CGFloat = 0
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager

    var body: some View {
        GeometryReader { g in
            VStack {
                Spacer()
                VStack {
                    HStack {
                        KFImage(URL(string: "https://static.gcores.com/assets/52fcb59ad1e09abecec58d39da6731cb.jpg"))
                            .resizable()
                            .cornerRadius(10)
                            .frame(width: 40, height: 40)
                        Text(audioPlayerManager.currentEpisode?.title ?? "")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .visualEffect()
                    .frame(height: 80)
                    .overlay({
                        PlayButton(width: buttonWidth, progress: $progress,
                                   isPlaying: $audioPlayerManager.isPlaying, action: {
                                    AudioPlayerManager.share.pauseOrResume()
                                   })
                            .offset(x: -50, y: -buttonWidth / 2)
                    }(), alignment: .topTrailing)
                    .onTapGesture {
                        isPresentPlay.toggle()
                    }
                    Spacer().frame(height: g.safeAreaInsets.bottom)
                }
                .background(Color(.white).opacity(0.1))
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onLoad(perform: onLoad)
        .sheet(isPresented: $isPresentPlay) {
            PlayerView(episode: audioPlayerManager.currentEpisode!)
                .environmentObject(audioPlayerManager)
        }
    }

    func onLoad() {
        progress = CGFloat(audioPlayerManager.currentProgress) / 100.0
    }
}

struct PlayButton: View {
    var width: CGFloat = 54
    @Binding var progress: CGFloat
    @Binding var isPlaying: Bool
    var action: VoidBlock

    private let lineWidth: CGFloat = 5

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: min(self.progress, 1.0))
                    .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                               lineCap: .round,
                                               lineJoin: .round))
                    .foregroundColor(.accentColor)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear)

                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .frame(width: width - lineWidth, height: width - lineWidth)
                    .background(Color.white)
                    .clipShape(Circle())
            }
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
