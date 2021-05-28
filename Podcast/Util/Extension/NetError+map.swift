//
//  NetError+map.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AnyPublisher {
    func mapNetError() -> AnyPublisher<Output, NetError> {
        mapError { NetError.tip($0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    func mapNetError() -> AnyPublisher<Output, NetError> {
        mapError { NetError.tip($0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
