//
//  SearchHistory.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import SwiftUI

struct SearchHistory: View {
    @Binding var tapText: String

    @ObservedObject var viewModel = SearchHistoryViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("History")
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {}, label: {
                    Text("Clear")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                })
            }
            .padding(.horizontal, 10)
            
            tagView()
        }
        .padding(.vertical, 10)
    }

    fileprivate func tagView() -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        let tags = viewModel.historyDataSource
        
        return GeometryReader { g in
            ZStack(alignment: .topLeading) {
                ForEach(values: tags) { tag in
                    Button(action: {}) {
                        Text(tag)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color(R.color.defaultBackground.name))
                            .cornerRadius(3.0)
                            .shadow(color: .black, radius: 2)
                    }
                    .padding(.trailing, 10)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > g.size.width {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == tags.last! {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct SearchHistory_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistory(tapText: .constant("123"))
            .previewLayout(.sizeThatFits)
            .frame(width: 320)
            .background(Color(R.color.barTint.name))
    }
}
