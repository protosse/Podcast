//
//  SearchHistoryViewModel.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import Combine
import Foundation

class SearchHistoryViewModel: ObservableObject, HasSubscriptions {
    @Published var historyDataSource: [String] = ["机核", "郭德纲", "123", "23", "233", "请问", "撒", "达到打底衫", "自行车奉公守法的", "洒大地", "广告费", "给他舒服"]
}
