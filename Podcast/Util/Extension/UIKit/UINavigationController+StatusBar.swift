//
//  UINavigationController+StatusBar.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import UIKit

// https://stackoverflow.com/questions/19022210/preferredstatusbarstyle-isnt-called
extension UINavigationController {

    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }

    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }

}
