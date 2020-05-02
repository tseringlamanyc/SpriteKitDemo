//
//  GameScene.swift
//  SpriteKitDemo
//
//  Created by Tsering Lama on 5/1/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import SpriteKit

// didMove - You can use this method to implement any custom behavior for your scene when it is about to be presented by a view. For example, you might use this method to create the scene’s contents.

// MARK: TODO
/*
 give players limit of 5 balls, then remove obstacles when they are hit
 give more balls if they hit the green slot 
 */

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background") // like UIImage
        background.position = CGPoint(x: 512, y: 384) // center of the screen of the iPad
        
        // blend mode (how a node is drawn)
        background.blendMode = .replace // draw ignoring alpha
        background.zPosition = -1 // place it behind everything else
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // SKScene , whole scene
        physicsWorld.contactDelegate = self
        
        makeSlot(position: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(position: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(position: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(position: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(position: CGPoint(x: 0, y: 0))
        makeBouncer(position: CGPoint(x: 256, y: 0))
        makeBouncer(position: CGPoint(x: 512, y: 0))
        makeBouncer(position: CGPoint(x: 768, y: 0))
        makeBouncer(position: CGPoint(x: 1024, y: 0))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return} // first touch that came in
        
        let location = touch.location(in: self) // where the touch happened
        
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                // create box
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                
                box.zRotation = CGFloat.random(in: 0...3) // random rotation in radiant
                box.position = location // where it was tapped 
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "box"
                addChild(box)
            } else {
                
                //  let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64)) // create a box in touch location
                //        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64)) // give a physic body matching the size of the box
                //  box.position = location
                //  addChild(box)
                let topOfSceneAtPosition = CGPoint(x: location.x, y: frame.maxY)
                makeBall(position: topOfSceneAtPosition)
                
            }
        }
    }
    
    func makeBall(position: CGPoint) {
        let names = ["ballRed", "ballBlue", "ballCyan", "ballGreen", "ballPurple", "ballRed", "ballYellow"]
        let randomName = names.randomElement()!
        let ball = SKSpriteNode(imageNamed: randomName)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0) // circle rather than box
        ball.physicsBody?.restitution = 0.4 // bounce (0 - 1)
        
        // collisionBitMask = which node to bump into (everything by default)
        // contactTestBitMask = which contact u wanna know (nothing by default)
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0 // tell us about all contact
        
        ball.position = position
        ball.name = "ball"
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
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
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
    
    func collisionBetweenBall(ball: SKNode, object: SKNode) {
        // SKNode - parent class of SKSpriteNode
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        // SKEmitterNode - visual effects 
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        // removes from game
        ball.removeFromParent()
    }
    
    func destroyObstacle(obstacle: SKNode) {
        // SKEmitterNode - visual effects
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = obstacle.position
            addChild(fireParticles)
        }
        
        // removes from game
        obstacle.removeFromParent()
    }
    
    func hitObstacle(obstalce: SKNode, object: SKNode) {
        // SKNode - parent class of SKSpriteNode
        if object.name == "ball" && obstalce.name == "box" {
            destroyObstacle(obstacle: obstalce)
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball" {
            collisionBetweenBall(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetweenBall(ball: nodeB, object: nodeA)
        }
        
        if nodeA.name == "box" {
            hitObstacle(obstalce: nodeA, object: nodeB)
        } else if nodeB.name == "box" {
            hitObstacle(obstalce: nodeB, object: nodeA)
        }
        
    }
}
