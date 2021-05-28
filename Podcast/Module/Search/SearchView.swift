//
//  SearchView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import Introspect
import SwiftUI
import Kingfisher

struct SearchView: View {
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var searchViewModel = SearchViewModel()

    var body: some View {
        ZStack {
            Color(R.color.defaultBackground.name).ignoresSafeArea()
            VStack(spacing: 0) {
                searchHeader()
                    .padding(.horizontal, 15)
                    .padding(.bottom, 5)

                Color.accentColor.frame(height: 2)

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(searchViewModel.dataSource) { model in
                            KFImage(URL(string: model.artworkUrl100))
                        }
                    }
                }
            }
        }
        .onLoad(perform: load)
    }

    func load() {
        searchViewModel.request()
    }

    fileprivate func searchHeader() -> some View {
        return HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 12, height: 20)
            }
            .padding(.trailing, 15)

            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("Podcast", text: $searchText)
                .foregroundColor(.white)
                .introspectTextField {
                    $0.attributedPlaceholder = NSAttributedString(string: $0.placeholder ?? "", attributes: [.foregroundColor: UIColor.gray])
                }

            Button(action: {
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
