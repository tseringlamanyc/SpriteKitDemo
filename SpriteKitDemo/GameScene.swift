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
        
        // blend mode (how a node is drawn)
        background.blendMode = .replace // draw ignoring alpha
        background.zPosition = -1 // place it behind everything else
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // SKScene , whole scene
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return} // first touch that came in
        
        let location = touch.location(in: self) // where the touch happened
        
        let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64)) // create a box in touch location
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64)) // give a physic body matching the size of the box
        box.position = location
        addChild(box)
    }
}
