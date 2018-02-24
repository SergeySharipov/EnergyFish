//
//  Fish.swift
//  EnergyFish
//
//  Created by Sergey on 21.02.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import SpriteKit

class FishCreater {
    static let NAME = "FishCreater"
    
    var fish:SKSpriteNode
    let fishAtlas:SKTextureAtlas
    var fishSprites = Array<SKTexture>()
    
    var width=CGFloat()
    var height=CGFloat()
    let repeatActionFish:SKAction
    
    init() {
        self.fishAtlas = SKTextureAtlas(named: "fish")
        fishSprites.append(fishAtlas.textureNamed("frame_1"))
        fishSprites.append(fishAtlas.textureNamed("frame_2"))
        fishSprites.append(fishAtlas.textureNamed("frame_3"))
        fishSprites.append(fishAtlas.textureNamed("frame_4"))
        fishSprites.append(fishAtlas.textureNamed("frame_5"))
        fishSprites.append(fishAtlas.textureNamed("frame_6"))
        fishSprites.append(fishAtlas.textureNamed("frame_7"))
        fishSprites.append(fishAtlas.textureNamed("frame_8"))
        
        fish = SKSpriteNode(texture: fishAtlas.textureNamed("frame_1"))
        
        let animateFish = SKAction.animate(with: fishSprites, timePerFrame: 0.1)
        repeatActionFish = SKAction.repeatForever(animateFish)
    }
    
    private func create(){
        if fish.name != FishCreater.NAME {
            fish.name = FishCreater.NAME
            
            fish.size = CGSize(width: 50, height: 50)
            fish.position = CGPoint(x:width/2, y:height/2)
            
            fish.physicsBody = SKPhysicsBody(circleOfRadius: fish.size.width / 2)
            fish.physicsBody?.linearDamping = 1.1
            fish.physicsBody?.restitution = 0
            fish.physicsBody?.categoryBitMask = CollisionBitMask.fishCategory
            fish.physicsBody?.collisionBitMask = CollisionBitMask.blowfishCategory | CollisionBitMask.groundCategory
            fish.physicsBody?.contactTestBitMask = CollisionBitMask.blowfishCategory | CollisionBitMask.starCategory | CollisionBitMask.groundCategory
            fish.physicsBody?.affectedByGravity = false
            fish.physicsBody?.isDynamic = true
        }
    }
    
    func getSKSpriteNode(width:CGFloat, height:CGFloat) -> SKSpriteNode  {
        self.width = width;
        self.height = height;
        
        create()
        
        let newFish = fish.copy() as! SKSpriteNode
        newFish.run(repeatActionFish)
        
        return newFish
    }
    
}

