//
//  GameScene.swift
//  SpriteKitDemo
//
//  Created by Tsering Lama on 5/1/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import SpriteKit

// didMove - You can use this method to implement any custom behavior for your scene when it is about to be presented by a view. For example, you might use this method to create the scene’s contents.

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background") // like UIImage
        background.position = CGPoint(x: 512, y: 384) // center of the screen of the iPad
        
        // blend mode (how a node is drawn)
        background.blendMode = .replace // draw ignoring alpha
        background.zPosition = -1 // place it behind everything else
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // SKScene , whole scene
        
        makeBouncer(position: CGPoint(x: 0, y: 0))
        makeBouncer(position: CGPoint(x: 256, y: 0))
        makeBouncer(position: CGPoint(x: 512, y: 0))
        makeBouncer(position: CGPoint(x: 768, y: 0))
        makeBouncer(position: CGPoint(x: 1024, y: 0))
        
        makeSlot(position: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(position: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(position: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(position: CGPoint(x: 896, y: 0), isGood: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return} // first touch that came in
        
        let location = touch.location(in: self) // where the touch happened
        
        //        let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64)) // create a box in touch location
        //        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64)) // give a physic body matching the size of the box
        //        box.position = location
        //        addChild(box)
        
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0) // circle rather than box
        ball.physicsBody?.restitution = 0.4 // bounce (0 - 1)
        ball.position = location
        addChild(ball)
    }
    
    func makeBouncer(position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false // fixed in place
        addChild(bouncer)
    }
    
    func makeSlot(position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        addChild(slotGlow)
        addChild(slotBase)
        
        /* SKAction - fade in or out , added functionality to SKSpriteNode
         angles are written in radian
         CGFloat.pi (double, float)
         when create action it runs once by default, need to do more to run forever
         */
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10) // half a circle
        let spinForever = SKAction.repeatForever(spin) // run forever 
        slotGlow.run(spinForever) // apply
    }
}
