//
//  GameScene.swift
//  SpriteKitDemo
//
//  Created by Tsering Lama on 5/1/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background") // like UIImage
        background.position = CGPoint(x: 512, y: 384) // center of the screen of the iPad
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
