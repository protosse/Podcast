//
//  EqualWidth.swift
//  Podcast
//
//  Created by liuliu on 2021/6/3.
//

import SwiftUI

// https://augmentedcode.io/2020/05/10/setting-an-equal-width-to-text-views-in-swiftui/
struct EqualWidthPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct EqualWidth: ViewModifier {
    let width: Binding<CGFloat?>

    func body(content: Content) -> some View {
        content.frame(width: width.wrappedValue, alignment: .leading)
            .background(GeometryReader { proxy in
                Color.clear.preference(key: EqualWidthPreferenceKey.self, value: proxy.size.width)
            }).onPreferenceChange(EqualWidthPreferenceKey.self) { value in
                self.width.wrappedValue = max(self.width.wrappedValue ?? 0, value)
            }
    }
}

extension View {
    func equalWidth(_ width: Binding<CGFloat?>) -> some View {
        return modifier(EqualWidth(width: width))
    }
}
