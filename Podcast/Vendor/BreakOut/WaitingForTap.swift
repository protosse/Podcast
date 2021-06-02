//
//  WaitingForTap.swift
//  BreakoutSpriteKitTutorial
//
//  Created by Michael Briscoe on 1/16/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class WaitingForTap: GKState {
    unowned let scene: GameScene

    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        let scale = SKAction.scale(to: 1.0, duration: 0.25)
        scene.messageNode.text = "Tap To Play"
        scene.messageNode.run(scale)

        scene.ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        scene.ball.position = CGPoint(x: scene.paddle.position.x, y: scene.paddle.frame.maxY + scene.ball.frame.width / 2)
    }

    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            let scale = SKAction.scale(to: 0, duration: 0.4)
            scene.messageNode.run(scale)
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }

}
