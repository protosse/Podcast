//
//  SearchHistory.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import Combine
import SwiftUI
import WrappingHStack

struct SearchHistory: View {
    @ObservedObject var viewModel: SearchHistoryViewModel

    init(tapText: PassthroughSubject<String, Never>, searchText: AnyPublisher<String, Never>) {
        viewModel = SearchHistoryViewModel(tapText: tapText, searchText: searchText)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("History")
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    viewModel.clear()
                }, label: {
                    Text("Clear")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                })
            }

            WrappingHStack(viewModel.historyDataSource, spacing: .constant(10)) { tag in
                Button(action: {
                    viewModel.tapText.send(tag)
                }) {
                    Text(tag)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color(R.color.defaultBackground.name))
                        .cornerRadius(3.0)
                        .shadow(color: .black, radius: 2)
                }
                .padding(.bottom, 10)
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

struct SearchHistory_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistory(tapText: .init(), searchText: .empty())
            .background(Color(R.color.barTint.name))
    }
}
