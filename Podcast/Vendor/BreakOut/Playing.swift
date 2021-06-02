//
//  Playing.swift
//  BreakoutSpriteKitTutorial
//
//  Created by Michael Briscoe on 1/16/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
    unowned let scene: GameScene

    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }

    private func randomDirection() -> CGFloat {
        let speedFactor: CGFloat = 3.0
        if CGFloat.random(in: 0...100) >= 50 {
            return -speedFactor
        } else {
            return speedFactor
        }
    }

    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingForTap {
            scene.ball.physicsBody?.applyImpulse(CGVector(dx: randomDirection(), dy: randomDirection()))
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let physicsBody = scene.ball.physicsBody else {
            return
        }

        let maxSpeed: CGFloat = 400
        let xSpeed = sqrt(physicsBody.velocity.dx * physicsBody.velocity.dx)
        let ySpeed = sqrt(physicsBody.velocity.dy * physicsBody.velocity.dy)
        let speed = sqrt(physicsBody.velocity.dx * physicsBody.velocity.dx +
            physicsBody.velocity.dy * physicsBody.velocity.dy)

        if xSpeed <= 10.0 {
            physicsBody.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
        }

        if ySpeed <= 10.0 {
            physicsBody.applyImpulse(CGVector(dx: 0.0, dy: randomDirection()))
        }

        if speed > maxSpeed {
            physicsBody.linearDamping = 0.4
        } else {
            physicsBody.linearDamping = 0.0
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
    }

}
