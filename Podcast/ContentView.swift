//
//  ContentView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import SwiftUI
import SwifterSwift

struct ContentView: View {
    init() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = R.color.defaultBackground()
    }

    var body: some View {
        let miniPlayerHeight: CGFloat = 120
        return
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
                            .frame(height: miniPlayerHeight)
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
