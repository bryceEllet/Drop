//
//  GameOver.swift
//  Drop
//
//  Created by there#2 on 2/20/24.
//

import UIKit
import SpriteKit

class GameOver: SKScene {

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -2
        background.blendMode = .replace
        addChild(background)
        
        let gameOver = SKLabelNode(fontNamed: "Chalkduster")
        gameOver.text = "Game Over!"
        gameOver.horizontalAlignmentMode = .right
        gameOver.position = CGPoint(x: 980, y: 700)
        gameOver.zPosition = 1
        addChild(gameOver)
    }
}
