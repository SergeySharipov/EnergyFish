//
//  GameScene.swift
//  EnergyFish
//
//  Created by Sergey on 12.02.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
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
    
    
    override func update(_ currentTime: TimeInterval) {
        enumerateChildNodes(withName: "background", using: ({
            (node, error) in
            let bg = node as! SKSpriteNode
            bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
            if bg.position.x <= -bg.size.width {
                bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
            }
        }))
        
    }
}
