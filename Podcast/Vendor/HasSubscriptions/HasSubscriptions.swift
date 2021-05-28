//
//  HasSubscriptions.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import Combine
import Foundation
import ObjectiveC

fileprivate var subscriptionsContext: UInt8 = 0

public protocol HasSubscriptions: AnyObject {
    var subscriptions: [AnyCancellable] { get set }
}

extension HasSubscriptions {
    fileprivate func synchronizedSubscriptions<T>(_ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }

    public var subscriptions: [AnyCancellable] {
        get {
            return synchronizedSubscriptions {
                if let disposeObject = objc_getAssociatedObject(self, &subscriptionsContext) as? [AnyCancellable] {
                    return disposeObject
                }
                let disposeObject: [AnyCancellable] = []
                objc_setAssociatedObject(self, &subscriptionsContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }

        set {
            synchronizedSubscriptions {
                objc_setAssociatedObject(self, &subscriptionsContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
