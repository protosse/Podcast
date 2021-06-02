//
//  GameViewController.swift
//  Bamboo Breakout

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    deinit {
        log.debug("\(self) deinit")
    }

    lazy var skView = SKView()
    lazy var closeButton = UIButton(type: .custom).then {
        $0.setImage(#imageLiteral(resourceName: "close_32x32"), for: .normal)
        $0.alpha = 0.6
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let scene = GameScene(fileNamed: "GameScene") else { return }
        scene.backgroundColor = R.color.defaultBackground() ?? .black
        view.addSubview(skView)

        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFit

        skView.presentScene(scene)

        view.addSubview(closeButton)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        skView.pin.all()
        closeButton.pin.top(self.view.pin.safeArea.top + 10).right(10).sizeToFit()
    }
}
