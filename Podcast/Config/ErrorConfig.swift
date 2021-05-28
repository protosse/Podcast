//
//  ErrorConfig.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import Foundation

enum NetError: Error {
    case tip(String)
    case none
}

extension NetError {
    init(_ error: Error) {
        if let e = error as? NetError {
            self = e
        } else {
            self = NetError.tip(error.localizedDescription)
        }
    }
}

extension NetError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .tip(let string):
            return string
        default:
            return""
        }
    }
}
