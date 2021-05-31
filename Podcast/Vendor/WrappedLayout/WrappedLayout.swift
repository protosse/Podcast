//
//  WrappedLayout.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import SwiftUI

struct WrappedLayout<T, Item>: View where Item: View {
    typealias Builder = (T) -> Item

    private let dataSource: [T]
    private let item: Builder

    init(dataSource: [T], @ViewBuilder item: @escaping Builder) {
        self.dataSource = dataSource
        self.item = item
    }

    var body: some View {
        generateBody()
    }

    func generateBody() -> some View {
        Text("Must Override")
    }
}

extension WrappedLayout where T: Identifiable & Equatable {
    func generateBody() -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        return GeometryReader { g in
            ZStack {
                ForEach(dataSource) { data in
                    self.item(data)
                        .alignmentGuide(.leading, computeValue: { d in
                            if abs(width - d.width) > g.size.width {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if data == dataSource.last! {
                                width = 0
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: { _ in
                            let result = height
                            if data == dataSource.last! {
                                height = 0
                            }
                            return result
                        })
                }
            }
        }
    }
}

extension WrappedLayout where T: Hashable {
    func generateBody() -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        return GeometryReader { g in
            ZStack {
                ForEach(values: dataSource) { data in
                    self.item(data)
                        .alignmentGuide(.leading, computeValue: { d in
                            if abs(width - d.width) > g.size.width {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if data == dataSource.last! {
                                width = 0
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: { _ in
                            let result = height
                            if data == dataSource.last! {
                                height = 0
                            }
                            return result
                        })
                }
            }
        }
    }
}

struct WrappedLayout_Previews: PreviewProvider {
    static var previews: some View {
        WrappedLayout(dataSource: ["机核", "郭德纲", "123", "23", "233", "请问", "撒", "达到打底衫", "自行车奉公守法的", "洒大地", "广告费", "给他舒服"]) { tag in
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
        }
    }
}
