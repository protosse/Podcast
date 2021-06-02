//
//  GameOver.swift
//  BreakoutSpriteKitTutorial
//
//  Created by Michael Briscoe on 1/16/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: GKState {
    unowned let scene: GameScene

    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        if previousState is Playing {
            scene.ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }

    override func willExit(to nextState: GKState) {
        if nextState is WaitingForTap {
            scene.messageNode.setScale(0.0)
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingForTap.Type
    }

}
