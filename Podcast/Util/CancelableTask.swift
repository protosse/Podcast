//
//  CancelableTask.swift
//  Vio
//
//  Created by doom on 2017/4/18.
//  Copyright © 2017年 doom. All rights reserved.
//

import Foundation

public typealias CancelableTask = (_ cancel: Bool) -> Void

@discardableResult public func delay(_ time: TimeInterval, work: @escaping () -> Void) -> CancelableTask? {

    var finalTask: CancelableTask?

    let cancelableTask: CancelableTask = { cancel in
        if cancel {
            finalTask = nil // key

        } else {
            DispatchQueue.main.async(execute: work)
        }
    }

    finalTask = cancelableTask

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
        if let task = finalTask {
            task(false)
        }
    }

    return finalTask
}

public func cancel(_ cancelableTask: CancelableTask?) {
    cancelableTask?(true)
}
