//
//  ContentView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import SwifterSwift
import SwiftUI

struct ContentView: View {
    init() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = R.color.defaultBackground()
    }

    @State var isHideMiniPlayerView = false
    var audioPlayerManager = AudioPlayerManager.share

    var body: some View {
        NavigationView {
            ZStack {
                Color(R.color.defaultBackground.name).ignoresSafeArea()
                TabView {
                    HomeView()
                    LibraryView()
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                VStack {
                    Spacer()
                    MiniPlayerView()
                        .frame(height: 120)
                }
            }
            .environmentObject(audioPlayerManager)
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onLoad(perform: onload)
    }

    func onload() {
//        self.isHideMiniPlayerView = audioPlayerManager.currentEpisode == nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AudioPlayerManager.share)
    }
}
