//
//  HomeView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import Kingfisher
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager

    @State private var isPresentSearch = false
    @State private var isPresentSet = false
    
    @State private var isHideMiniPlayer = false

    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    Spacer()
                    Button(action: {
                        self.isPresentSet.toggle()
                    }) {
                        Image(systemName: "gear")
                    }

                    Button(action: {
                        self.isPresentSearch.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    .padding(.trailing, 15)
                }
                .frame(height: 44)

                GeometryReader { g in
                    let s: CGFloat = 10
                    let w: CGFloat = (g.size.width - 20 - s * 2) / 3
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: w))], spacing: s) {
                            ForEach(viewModel.dataSource) { model in
                                NavigationLink(destination: PodcastView(podcast: model)) {
                                    VStack {
                                        KFImage(URL(string: model.artworkUrl(.Large)))
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fill)
                                            .frame(width: w)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            
            if !isHideMiniPlayer {
                VStack {
                    Spacer()
                    MiniPlayerView()
                        .environmentObject(audioPlayerManager)
                        .frame(height: 120)
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentSet, content: {
            SetView()
        })
        .fullScreenCover(isPresented: $isPresentSearch, content: {
            SearchView()
        })
        .onAppear(perform: onAppear)
    }

    func onAppear() {
        viewModel.request()
        isHideMiniPlayer = audioPlayerManager.currentEpisode == nil
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let view = HomeView()
        var model = Podcast()
        model.trackId = "1256399960"
        model.artworkUrl100 = "https://static.gcores.com/assets/52fcb59ad1e09abecec58d39da6731cb.jpg"
        view.viewModel.dataSource = [model]
        return ZStack {
            Color(R.color.defaultBackground.name).ignoresSafeArea()
            view
        }
    }
}
