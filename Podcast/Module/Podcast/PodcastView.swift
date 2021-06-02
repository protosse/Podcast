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
                PodcastDetailRepresentation(viewModel: viewModel)
            }
        }
        .navigationBarHidden(true)
    }

    func load() {
        viewModel.fetchEpisode()
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        let model = Podcast()
        model.id = "1256399960"
        model.trackName = "直到地狱尽头"
        model.artistName = "doom"
        model.artworkUrl100 = "https://static.gcores.com/assets/52fcb59ad1e09abecec58d39da6731cb.jpg"
        return PodcastView(podcast: model)
    }
}
