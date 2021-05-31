//
//  PodcastView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import SwiftUI

struct PodcastView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PodcastViewModel

    @State private var selection = 0

    init(podcast: Podcast) {
        viewModel = PodcastViewModel(podcast: podcast)
    }

    var body: some View {
        ZStack {
            Color(R.color.defaultBackground.name).ignoresSafeArea()
            VStack {
                SearchHeader(placeHolder: "Episode", searchText: $viewModel.searchText, onCommit: {}) {
                    presentationMode.wrappedValue.dismiss()
                }
                ScrollView {
                    VStack {
                        HStack {
                            Text("Tab Detail")
                        }
                        TabView(selection: $selection,
                                content: {
                                    Text("Tab Content 1")
                                        .tabItem { Text("Tab Label 1") }.tag(1)

                                    Text("Tab Content 2")
                                        .tabItem { Text("Tab Label 2") }.tag(2)
                                })
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onLoad(perform: load)
    }

    func load() {
        viewModel.fetchEpisode()
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        let model = Podcast()
        model.id = "1256399960"
        return PodcastView(podcast: model)
    }
}
