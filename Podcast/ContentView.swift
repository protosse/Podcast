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
            }
            .environmentObject(audioPlayerManager)
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AudioPlayerManager.share)
    }
}
