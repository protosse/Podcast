//
//  Config.swift
//  Podcast
//
//  Created by liuliu on 2021/5/28.
//

import UIKit
import SwiftyBeaver
import SwiftyUserDefaults

typealias IntBlock = (_ index: Int) -> Void
typealias StringBlock = (_ text: String) -> Void
typealias VoidBlock = () -> Void

public struct Config {

    static let countryCode = Locale.current.regionCode ?? ""
    static let limitValue = 20
    static let schemaVersion: UInt64 = 5
}

let log: SwiftyBeaver.Type = {
    let log = SwiftyBeaver.self
    let console = ConsoleDestination()
    log.addDestination(console)
    return log
}()

extension DefaultsKeys {
    var historyTags: DefaultsKey<[String]> {
        return .init("historyTags", defaultValue: [])
    }
}
