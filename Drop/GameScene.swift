//
//  GameScene.swift
//  Drop
//
//  Created by there#2 on 2/7/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var scoreLabel: SKLabelNode!
    var ballsLabel: SKLabelNode!
    var boxes: [SKSpriteNode?] = []
    var balls: Int = 5 {
        didSet {
            ballsLabel.text = "Balls: \(balls)"
        }
    }
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var resetLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var editMode: Bool = false {
        didSet {
            if editMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -2
        background.blendMode = .replace
        addChild(background)
        if let fireFly = SKEmitterNode(fileNamed: "FireFly") {
            fireFly.position = background.position
            background.zPosition = -1
            addChild(fireFly)
        }
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
        
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls: 5"
        ballsLabel.horizontalAlignmentMode = .right
        ballsLabel.position = CGPoint(x: 980, y: 660)
        ballsLabel.zPosition = 1
        addChild(ballsLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.horizontalAlignmentMode = .left
        editLabel.position = CGPoint(x: 50, y: 700)
        editLabel.zPosition = 1
        addChild(editLabel)
        
        resetLabel = SKLabelNode(fontNamed: "Chalkduster")
        resetLabel.text = "Reset"
        resetLabel.horizontalAlignmentMode = .left
        resetLabel.position = CGPoint(x: 50, y: 660)
        resetLabel.zPosition = 1
        addChild(resetLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if score >= 10 {
                let scene = GameScene(fileNamed: "GameOver")!
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 200)
                scene.scaleMode = .fill
                self.view?.presentScene(scene, transition: transition)
            }
            var location = touch.location(in: self)
            let objects = nodes(at: location)
            if objects.contains(resetLabel) {
                score = 0
                balls = 5
            } else if objects.contains(editLabel) {
                editMode = !editMode
            } else {
                if editMode {
                    let box = SKSpriteNode(color: randomColor(), size: CGSize(width: Int.random(in: 42...142), height: 16))
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.zRotation = CGFloat.random(in: 0...2 * CGFloat.pi)
                    box.physicsBody?.isDynamic = false
                    box.physicsBody!.restitution = 0.8
                    box.position = location
                    box.name = "box"
                    addChild(box)
                    boxes.append(box)
                } else {
                    if balls > 0 {
                        balls -= 1
                        location.y = 720
                        var name = ""
                        switch Int.random(in: 1...7) {
                        case 1:
                            name = "ballBlue"
                        case 2:
                            name = "ballCyan"
                        case 3:
                            name = "ballGreen"
                        case 4:
                            name = "ballGrey"
                        case 5:
                            name = "ballPurple"
                        case 6:
                            name = "ballYellow"
                        default:
                            name = "ballRed"
                        }
                        let ball = SKSpriteNode(imageNamed: name)
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
                        ball.physicsBody!.restitution = 0.4
                        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                        ball.position = location
                        ball.name = "ball"
                        addChild(ball)
                    }
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2.0)
        bouncer.physicsBody!.isDynamic = false
        bouncer.physicsBody!.restitution = 1
        addChild(bouncer)
    }
 
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotBase.name = "good"
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotBase.name = "bad"
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        slotGlow.zPosition = 0
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody!.isDynamic = false
        slotGlow.position = position
        addChild(slotGlow)
        addChild(slotBase)
        
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 12)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }

    func collisionBetween(ball: SKNode, object: SKNode?) {
        if object?.name == "good" {
            destroy(ball: ball)
            score += 1
            balls += 1
        } else if object?.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object?.name == "box" {
            object?.removeFromParent()
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ball" {
            collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node ?? contact.bodyA.node!)
        } else if contact.bodyB.node?.name == "ball" {
            collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node ?? contact.bodyB.node!)
        }
    }
    
    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0.2...1)
        let green = CGFloat.random(in: 0.2...1)
        let blue = CGFloat.random(in: 0.2...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}
