//
//  EmptyView.swift
//  Podcast
//
//  Created by doom on 2019/3/29.
//  Copyright © 2019 doom. All rights reserved.
//

import UIKit
import SwifterSwift
import Lottie

class EmptyView: UIView, StatefulPlaceholderView {

    lazy var animationView = AnimationView()
    lazy var animation = Animation.named("empty_list", subdirectory: "Animation")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        addSubview(animationView)
    }

    override func layoutSubviews() {
        animationView.pin.all()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        animationView.animation = animation
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
    }

    override func removeFromSuperview() {
        animationView.stop()
        super.removeFromSuperview()
    }

}
