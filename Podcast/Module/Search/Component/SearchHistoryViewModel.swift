//
//  SearchHistoryViewModel.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import Combine
import Foundation
import SwiftyUserDefaults

class SearchHistoryViewModel: ObservableObject, HasSubscriptions {
    var tapText: PassthroughSubject<String, Never>
    var searchText: AnyPublisher<String, Never>

    @Published var historyDataSource: [String]

    init(tapText: PassthroughSubject<String, Never>, searchText: AnyPublisher<String, Never>) {
        self.tapText = tapText
        self.searchText = searchText
        historyDataSource = Defaults[\.historyTags]

        searchText
            .filter { !$0.isEmpty && !Defaults[\.historyTags].contains($0) }
            .sink { [weak self] str in
                Defaults[\.historyTags].insert(str, at: 0)
                self?.historyDataSource = Defaults[\.historyTags]
            }
            .store(in: &subscriptions)
    }

    func clear() {
        Defaults[\.historyTags].removeAll()
        historyDataSource = Defaults[\.historyTags]
    }
}
