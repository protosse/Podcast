//
//  LibraryViewModel.swift
//  Podcast
//
//  Created by liuliu on 2021/6/7.
//

import Combine

class LibraryViewModel: ObservableObject, HasSubscriptions {
    @Published var dataSource: [Episode] = []
    var selectedModel: Episode!
    
    func request() {
        dataSource = Episode.allSaved()
    }
}
