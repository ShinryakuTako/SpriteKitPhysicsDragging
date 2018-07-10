//
//  GameScene.swift
//  SpriteKitPhysicsDragging
//
//  Created by ShinryakuTako@InvadingOctopus.io on 2018/07/10.
//  Copyright © 2018 Invading Octopus. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var draggableBlock: SKSpriteNode?
    private var nonDraggableBlock: SKSpriteNode?
    
    private var trackedTouch: UITouch?
    
    override func didMove(to view: SKView) {
        
        // Scene
        
        self.backgroundColor = SKColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // Draggable block
        
        let draggableBlockSize = CGSize(width: 75, height: 75)
        let draggableBlock = SKSpriteNode(color: .red, size: draggableBlockSize)
        let draggableBody = SKPhysicsBody(rectangleOf: draggableBlockSize)
        
        draggableBody.mass = 5 // Lighter
        draggableBlock.physicsBody = draggableBody
        
        self.addChild(draggableBlock)
        self.draggableBlock = draggableBlock
        
        // Non-draggable block
        
        let nonDraggableBlockSize = CGSize(width: 150, height: 150)
        let nonDraggableBlock = SKSpriteNode(color: .lightGray, size: nonDraggableBlockSize)
        let nonDraggableBody = SKPhysicsBody(rectangleOf: nonDraggableBlockSize)
        
        nonDraggableBody.mass = 20 // Heavier
        nonDraggableBody.friction = 1.0
        nonDraggableBody.linearDamping = 0.5
        nonDraggableBody.angularDamping = 0.5
        nonDraggableBody.affectedByGravity = false // Floating
        
        nonDraggableBlock.position.y = 100 // Place it a little higher
        nonDraggableBlock.physicsBody = nonDraggableBody
        
        self.addChild(nonDraggableBlock)
        self.nonDraggableBlock = nonDraggableBlock
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  let draggableBlock = self.draggableBlock,
            let firstTouch = touches.first,
            trackedTouch == nil,
            draggableBlock.contains(firstTouch.location(in: self))
        {
            trackedTouch = firstTouch
            draggableBlock.physicsBody?.affectedByGravity = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  let trackedTouch = self.trackedTouch,
            touches.contains(trackedTouch)
        {
            self.trackedTouch = nil
            draggableBlock?.physicsBody?.affectedByGravity = true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard
            let trackedTouch = trackedTouch,
            let draggableBlock = self.draggableBlock,
            let draggableBody = draggableBlock.physicsBody
            else { return }
        
        let seconds = CGFloat(1.0 / 60.0) // For simplification, we'll just assume that we're getting the full 60 FPS.
        
        let touchLocation = trackedTouch.location(in: self)
        
        let distance = hypot(draggableBlock.position.x - touchLocation.x,
                             draggableBlock.position.y - touchLocation.y)
        
        // Dampen (optional)
        
        // var damping = sqrt(distance / seconds)
        // if (damping < 0) { damping = 0.0 }
        // physicsBody.linearDamping = damping
        // physicsBody.angularDamping = damping
        
        // Fling
        
        let translation = CGPoint(x: touchLocation.x - draggableBlock.position.x,
                                  y: touchLocation.y - draggableBlock.position.y)
        
        draggableBody.velocity = CGVector(dx: translation.x / seconds,
                                          dy: translation.y / seconds)
    }
}
