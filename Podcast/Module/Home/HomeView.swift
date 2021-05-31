//
//  HomeView.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import SwiftUI

struct HomeView: View {
    var homeViewModel = HomeViewModel()

    @State var isPresentSearch = false
    @State var isPresentSet = false

    var body: some View {
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
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], content: {
                })
            }
        }
        .fullScreenCover(isPresented: $isPresentSet, content: {
            SetView()
        })
        .fullScreenCover(isPresented: $isPresentSearch, content: {
            SearchView()
        })
    }

    func load() {
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
