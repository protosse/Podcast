//
//  SwiftUI+Common.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import SwiftUI

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
