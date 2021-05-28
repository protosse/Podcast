//
//  Combine+Common.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import Combine

extension AnyPublisher {
    static func empty() -> AnyPublisher {
        return Empty().eraseToAnyPublisher()
    }
}
