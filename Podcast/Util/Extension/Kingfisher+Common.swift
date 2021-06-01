//
//  Kingfisher+Common.swift
//  Podcast
//
//  Created by liuliu on 2021/6/1.
//

import UIKit
import Kingfisher

extension KingfisherWrapper where Base: UIImageView {
    func setImage(_ string: String?, placeholder: UIImage? = nil) {
        self.setImage(with: URL(string: string ?? ""), placeholder: placeholder, options: [.transition(.fade(0.2))])
    }
}

extension KingfisherWrapper where Base: UIButton {
    func setImage(_ string: String?, for state: UIControl.State = .normal,
                  placeholder: UIImage? = nil) {
        self.setImage(with: URL(string: string ?? ""), for: state, placeholder: placeholder, options: [.transition(.fade(0.2))])
    }
}
