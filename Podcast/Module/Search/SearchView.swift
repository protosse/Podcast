//
//  SearchView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import Introspect
import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel = SearchViewModel()

    var body: some View {
        ZStack {
            Color(R.color.defaultBackground.name).ignoresSafeArea()
            VStack(spacing: 0) {
                searchHeader()
                    .padding(.horizontal, 15)
                    .padding(.bottom, 5)

                Color.accentColor.frame(height: 2)
                
                SearchHistory(tapText: $searchText)

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.dataSource) { model in
                            PodcastCell(model: model)
                        }
                    }
                }
            }
        }
        .onLoad(perform: load)
    }

    func load() {
        viewModel.requestTopPodcasts()
    }

    fileprivate func searchHeader() -> some View {
        return HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("Podcast", text: $searchText, onCommit: {
                viewModel.search(text: searchText)
            })
                .foregroundColor(.white)
                .introspectTextField {
                    $0.attributedPlaceholder = NSAttributedString(string: $0.placeholder ?? "", attributes: [.foregroundColor: UIColor.gray])
                }

            Button(action: {
                searchText = ""
                viewModel.requestTopPodcasts()
            }) {
                Image(systemName: "xmark.circle.fill")
            }
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
