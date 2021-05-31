//
//  SwiftUI+Common.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import SwiftUI

extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
    init(values: Data, content: @escaping (Data.Element) -> Content) {
        self.init(values, id: \.self, content: content)
    }
}

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        var actionPerformed = false
        return onAppear {
            guard !actionPerformed else {
                return
            }
            actionPerformed = true
            action?()
        }
    }
}
