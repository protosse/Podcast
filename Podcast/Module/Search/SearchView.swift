//
//  SearchView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel = SearchViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color(R.color.defaultBackground.name).ignoresSafeArea()
                VStack(spacing: 0) {
                    SearchHeader(placeHolder: "Podcast", searchText: $viewModel.searchText, onCommit: {
                        if viewModel.searchText.isEmpty {
                            viewModel.requestTopPodcasts()
                        } else {
                            viewModel.search()
                        }
                    }) {
                        presentationMode.wrappedValue.dismiss()
                    }

                    ScrollView {
                        SearchHistory(tapText: viewModel.tapSubject,
                                      searchText: viewModel.searchSubject.eraseToAnyPublisher())
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.dataSource) { model in
                                NavigationLink(destination: PodcastView(podcast: model)) {
                                    PodcastCell(model: model)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onLoad(perform: onLoad)
    }

    func onLoad() {
        viewModel.bind()
        viewModel.requestTopPodcasts()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
