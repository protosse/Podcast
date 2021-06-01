//
//  BaseViewController.swift
//  Podcast
//
//  Created by liuliu on 2021/5/31.
//

import UIKit

class BaseViewController: UIViewController {
    deinit {
        log.debug("\(self) deinit")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var isHideNavigationWhenWillAppear: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.color.defaultBackground()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if navigationController?.isNavigationBarHidden != isHideNavigationWhenWillAppear {
            navigationController?.setNavigationBarHidden(isHideNavigationWhenWillAppear, animated: animated)
        }
    }
}
