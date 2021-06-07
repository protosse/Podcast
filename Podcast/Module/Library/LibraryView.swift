//
//  LibraryView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel = LibraryViewModel()
    @State private var isPresentPlay = false
    
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.dataSource) { model in
                    EpisodeCellRepresentable(model: model)
                        .frame(height: 100)
                        .onTapGesture {
                            viewModel.selectedModel = model
                            self.isPresentPlay.toggle()
                        }
                }
            }
        }
        .sheet(isPresented: $isPresentPlay, content: {
            PlayerView(episode: viewModel.selectedModel).environmentObject(audioPlayerManager)
        })
        .onAppear(perform: onAppear)
    }

    func onAppear() {
        viewModel.request()
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        let view = LibraryView()
        var model = Episode()
        model.title = "1256399960"
        model.imageUrl = "https://static.gcores.com/assets/52fcb59ad1e09abecec58d39da6731cb.jpg"
        view.viewModel.dataSource = [model]
        return ZStack {
            Color(R.color.defaultBackground.name).ignoresSafeArea()
            view
        }
    }
}
