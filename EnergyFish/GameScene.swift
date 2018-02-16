//
//  GameScene.swift
//  EnergyFish
//
//  Created by Sergey on 12.02.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    let noCategory:UInt32 = 0
    let hookCategory:UInt32 = 0b1
    let fishCategory:UInt32 = 0b1 << 1
    let coinCategory:UInt32 = 0b1 << 2
    let borderCategory:UInt32 = 0b1 << 3
    
    var fish:SKSpriteNode?
    
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        fish = self.childNode(withName: "fish") as? SKSpriteNode
        fish?.physicsBody?.categoryBitMask = fishCategory
        fish?.physicsBody?.collisionBitMask = borderCategory
        fish?.physicsBody?.contactTestBitMask = hookCategory | coinCategory | borderCategory
        
        let coin = self.childNode(withName: "coin") as? SKSpriteNode
        coin?.physicsBody?.categoryBitMask = coinCategory
        coin?.physicsBody?.collisionBitMask = noCategory
        coin?.physicsBody?.contactTestBitMask = fishCategory
        
        let hook = self.childNode(withName: "hook") as? SKSpriteNode
        hook?.physicsBody?.categoryBitMask = hookCategory
        hook?.physicsBody?.collisionBitMask = noCategory
        hook?.physicsBody?.contactTestBitMask = fishCategory
        
        let border = self.childNode(withName: "border") as? SKSpriteNode
        border?.physicsBody?.categoryBitMask = borderCategory
        border?.physicsBody?.collisionBitMask = borderCategory
        border?.physicsBody?.contactTestBitMask = fishCategory
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let cA:UInt32 = contact.bodyA.categoryBitMask
        let cB:UInt32 = contact.bodyB.categoryBitMask
        
        if cA == fishCategory || cB == fishCategory {
            let otherNode:SKNode = (cA == fishCategory) ? contact.bodyB.node! : contact.bodyA.node!
            playerDidCollide(with: otherNode)
        }
    
    }
    
    func playerDidCollide(with other:SKNode) {
        let otherCategory = other.physicsBody?.categoryBitMask
        if otherCategory == coinCategory {
            other.removeFromParent()
        }
        else if otherCategory == hookCategory {
            other.removeFromParent()
            fish?.removeFromParent()
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
   
    }
    
    func touchUp(atPoint pos : CGPoint) {
fish?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
     
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func moveBackground() {
        enumerateChildNodes(withName: "background", using: ({
            (node, error) in
            let bg = node as! SKSpriteNode
            bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
            if bg.position.x <= -bg.size.width {
                bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
            }
        }))
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackground()
        
    }
}
