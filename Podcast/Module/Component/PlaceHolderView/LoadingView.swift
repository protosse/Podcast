//
//  LoadingView.swift
//  Podcast
//
//  Created by doom on 2019/3/28.
//  Copyright © 2019 doom. All rights reserved.
//

import UIKit
import SwifterSwift
import Lottie

class LoadingView: UIView, StatefulPlaceholderView {

    var isPlayGame = false

    lazy var animationView = AnimationView()
    lazy var animation = Animation.named("empty_list", subdirectory: "Animation")

    lazy var percentLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 13)
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.textColor = .white
    }

    lazy var playButton = UIButton(type: .custom).then {
        $0.titleLabel?.font = UIFont(name: "MarkerFelt-Thin", size: 12)
        $0.setTitle("Wait too long, let's play a game", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }

    var configAnimationLayout: ((UIView) -> Void)?

    convenience init(isPlayGame: Bool) {
        self.init(frame: .zero)
        self.isPlayGame = isPlayGame
        if isPlayGame {
            addSubview(playButton)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubviews([animationView, percentLabel])
    }

    override func layoutSubviews() {
        animationView.pin.center().width(160).height(80)
        percentLabel.pin.below(of: animationView, aligned: .center).sizeToFit()

        if isPlayGame {
            playButton.pin.bottom(self.pin.safeArea.bottom + 20).hCenter().sizeToFit()
        }

        configAnimationLayout?(animationView)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        animationView.animation = animation
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)

        if isPlayGame {
            playButton.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 3, options: .curveEaseOut, animations: {
                self.playButton.alpha = 1
            })
        }
    }

    override func removeFromSuperview() {
        animationView.stop()
        super.removeFromSuperview()
    }

}
