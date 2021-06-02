//
//  GameScene.swift
//  Bamboo Breakout

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let BallCategoryName = "ball"
    let PaddleCategoryName = "paddle"
    let BlockCategoryName = "block"
    let GameMessageName = "message"

    let BallCategory   : UInt32 = 0x1 << 0
    let BottomCategory : UInt32 = 0x1 << 1
    let BlockCategory  : UInt32 = 0x1 << 2
    let PaddleCategory : UInt32 = 0x1 << 3
    let BorderCategory : UInt32 = 0x1 << 4

    let blocksColor = [#colorLiteral(red: 1, green: 0.7843137255, blue: 0.2509803922, alpha: 1), #colorLiteral(red: 0.937254902, green: 0.43921568627451, blue: 0.38823529411765, alpha: 1.0), #colorLiteral(red: 0.95686274509804, green: 0.67843137254902, blue: 0.37254901960784, alpha: 1.0), #colorLiteral(red: 0.97647058823529, green: 0.83921568627451, blue: 0.41960784313725, alpha: 1.0), #colorLiteral(red: 0.6078431372549, green: 0.87058823529412, blue: 0.46274509803922, alpha: 1.0), #colorLiteral(red: 0.43921568627451, green: 0.73725490196078, blue: 0.95686274509804, alpha: 1.0), #colorLiteral(red: 0.8, green: 0.58039215686275, blue: 0.88627450980392, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]

    var isFingerOnPaddle = false

    lazy var gameState = GKStateMachine(states: [
        WaitingForTap(scene: self), Playing(scene: self), GameOver(scene: self)
    ])

    var gameWon = false {
        didSet {
            let text = gameWon ? "You Win" : "Game Over"
            messageNode.text = text
            let actionSequence = SKAction.sequence([.scale(to: 1.0, duration: 0.25)])
            messageNode.run(actionSequence)
        }
    }

    lazy var paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode

    lazy var ball = SKShapeNode(circleOfRadius: 6).then {
        $0.fillColor = SKColor.white
        $0.name = BallCategoryName
        $0.physicsBody = SKPhysicsBody(circleOfRadius: 6)
        $0.physicsBody?.linearDamping = 0
        $0.physicsBody?.angularDamping = 0
        $0.physicsBody?.friction = 0
        $0.physicsBody?.restitution = 1
        $0.zPosition = 2
    }

    lazy var messageNode = childNode(withName: GameMessageName) as! SKLabelNode

    var blocks = [SKSpriteNode]()

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        paddle.do { node in
            if let image = UIImage(color: #colorLiteral(red: 0.31372549019608, green: 0.66666666666667, blue: 0.83921568627451, alpha: 1.0), size: node.size).withRoundedCorners() {
                let texture = SKTexture(image: image)
                node.texture = texture
            }
        }

        addChild(ball)

        physicsWorld.contactDelegate = self

        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody

        self.physicsWorld.gravity = .zero

        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)

        bottom.physicsBody?.categoryBitMask = BottomCategory
        ball.physicsBody?.categoryBitMask = BallCategory
        paddle.physicsBody?.categoryBitMask = PaddleCategory
        borderBody.categoryBitMask = BorderCategory

        ball.physicsBody?.contactTestBitMask = BottomCategory | BlockCategory | BorderCategory | PaddleCategory

        let trailNode = SKNode()
        trailNode.zPosition = 1
        addChild(trailNode)
        let trail = SKEmitterNode(fileNamed: "BallTrail")!
        trail.targetNode = trailNode
        ball.addChild(trail)

        placeBlocks()

        messageNode.setScale(0.0)
        gameState.enter(WaitingForTap.self)
    }

    override func update(_ currentTime: TimeInterval) {
        gameState.update(deltaTime: currentTime)
    }

    // MARK: action

    func placeBlocks() {
        let row = 8
        let column = 8
        let totalBlocksWidth = frame.width - 80
        let blockWidth: CGFloat = totalBlocksWidth / 8
        let blockHeight: CGFloat = blockWidth / 3.75

        let xOffset = (frame.width - totalBlocksWidth) / 2
        let yOffset = frame.height * 0.9
        let colors = blocksColor.shuffled()
        blocks.removeAll()
        for i in 0..<row {
            for j in 0..<column {
                let block = SKSpriteNode(color: colors[(i + j + 1) % column], //blocksColor' count is equal to column
                    size: CGSize(width: blockWidth, height: blockHeight))
                block.position = CGPoint(x: xOffset + CGFloat(CGFloat(j) + 0.5) * blockWidth,
                                         y: yOffset - CGFloat(CGFloat(i) + 0.5) * blockHeight)
                block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
                block.physicsBody!.allowsRotation = false
                block.physicsBody!.friction = 0.0
                block.physicsBody!.affectedByGravity = false
                block.physicsBody!.isDynamic = false
                block.name = BlockCategoryName
                block.physicsBody!.categoryBitMask = BlockCategory
                block.zPosition = 2
                addChild(block)
                blocks.append(block)
            }
        }
    }

    func breakBlock(node: SKNode) {
        if let particles = SKEmitterNode(fileNamed: "BrokenPlatform") {
            particles.position = node.position
            particles.zPosition = 3
            addChild(particles)
            particles.run(.sequence([.wait(forDuration: 1.0), .removeFromParent()]))
        }
        node.removeFromParent()
    }

    func isGameWon() -> Bool {
        var numberOfBricks = 0
        self.enumerateChildNodes(withName: BlockCategoryName) { (_, _) in
            numberOfBricks += 1
        }
        return numberOfBricks == 0
    }

    // MARK: touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enter(Playing.self)
            isFingerOnPaddle = true
        case is Playing:
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            if let body = physicsWorld.body(at: location) {
                if body.node?.name == PaddleCategoryName {
                    isFingerOnPaddle = true
                }
            }
        case is GameOver:
            blocks.forEach {
                if !self.children.contains($0) {
                    self.addChild($0)
                }
            }
            gameState.enter(WaitingForTap.self)
        default:
            break
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if isFingerOnPaddle {
            let touchLocation = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)

            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            paddle.position.x = paddleX
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
    }

}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if gameState.currentState is Playing {
            var firstBody: SKPhysicsBody
            var secondBody: SKPhysicsBody
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }

            if firstBody.categoryBitMask == BallCategory {
                switch secondBody.categoryBitMask {
                case BottomCategory:
                    gameState.enter(GameOver.self)
                    gameWon = false
                case BlockCategory:
                    breakBlock(node: secondBody.node!)
                    if isGameWon() {
                        gameState.enter(GameOver.self)
                        gameWon = true
                    }
                default:
                    break
                }
            }
        }
    }
}
