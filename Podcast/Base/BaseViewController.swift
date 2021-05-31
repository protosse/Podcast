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

        view.backgroundColor = UIColor.vio.Shark
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.navigationController?.isNavigationBarHidden != isHideNavigationWhenWillAppear {
            self.navigationController?.setNavigationBarHidden(isHideNavigationWhenWillAppear, animated: animated)
        }
    }

}

