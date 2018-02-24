//
//  Blowfish.swift
//  EnergyFish
//
//  Created by Sergey on 21.02.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import SpriteKit

class BlowfishStarCreater {
    static let NAME = "BlowfishStarCreater"
    
    let blowfishAtlas:SKTextureAtlas
    var blowfishSprites = Array<SKTexture>()
    let gameObjectsGroup = SKNode()
    var width=CGFloat()
    var height=CGFloat()
    var y=CGFloat()
    let repeatActionblowfish:SKAction
    
    init() {
        self.blowfishAtlas = SKTextureAtlas(named: "blowfish")
        blowfishSprites.append(blowfishAtlas.textureNamed("blowfish_1"))
        blowfishSprites.append(blowfishAtlas.textureNamed("blowfish_2"))
        blowfishSprites.append(blowfishAtlas.textureNamed("blowfish_3"))
        blowfishSprites.append(blowfishAtlas.textureNamed("blowfish_4"))
        blowfishSprites.append(blowfishAtlas.textureNamed("blowfish_4"))
        blowfishSprites.append(blowfishAtlas.textureNamed("blowfish_1"))
        blowfishSprites.append(blowfishAtlas.textureNamed("blowfish_1"))
        blowfishSprites.append(blowfishAtlas.textureNamed("blowfish_1"))
        
        let animateblowfish = SKAction.animate(with: blowfishSprites, timePerFrame: 0.1)
        repeatActionblowfish = SKAction.repeatForever(animateblowfish)
    }
    
    private func create(){
        if gameObjectsGroup.name != BlowfishStarCreater.NAME {
            y = gameObjectsGroup.position.y
            
            gameObjectsGroup.name = BlowfishStarCreater.NAME
            
            gameObjectsGroup.addChild(createBlowfish(top: true))
            gameObjectsGroup.addChild(createBlowfish(top: false))
            gameObjectsGroup.addChild(self.createStar())
            
            gameObjectsGroup.zPosition = 1
        }
    }
    
    func getSKNode(width:CGFloat, height:CGFloat) -> SKNode  {
        self.width = width;
        self.height = height;
        
        create()
        
        let randomPosition = random(min: -150, max: 150)
        gameObjectsGroup.position.y = y + randomPosition
        
        return gameObjectsGroup.copy() as! SKNode
    }
    
    private func createBlowfish(top:Bool) -> SKSpriteNode  {
        let blowfish = SKSpriteNode(texture: SKTextureAtlas(named:"blowfish").textureNamed("blowfish_1"))
        
        var distanseFromCenter:CGFloat = 110
        if(!top){
            distanseFromCenter = -distanseFromCenter
        }
        
        blowfish.position = CGPoint(x: width + 50, y: height / 2 + distanseFromCenter)
        blowfish.setScale(0.2)
        
        blowfish.physicsBody = SKPhysicsBody(texture: blowfish.texture!, size: blowfish.size)
        blowfish.physicsBody?.categoryBitMask = CollisionBitMask.blowfishCategory
        blowfish.physicsBody?.collisionBitMask = CollisionBitMask.fishCategory
        blowfish.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        blowfish.physicsBody?.isDynamic = false
        blowfish.physicsBody?.affectedByGravity = false
        
        blowfish.run(repeatActionblowfish)
        
        return blowfish
    }
    
    private func createStar() -> SKSpriteNode{
        let starNode = SKSpriteNode(imageNamed: "star")
        starNode.size = CGSize(width: 40, height: 40)
        starNode.position = CGPoint(x: width + 25, y: height / 2)
        starNode.physicsBody = SKPhysicsBody(rectangleOf: starNode.size)
        starNode.physicsBody?.affectedByGravity = false
        starNode.physicsBody?.isDynamic = false
        starNode.physicsBody?.categoryBitMask = CollisionBitMask.starCategory
        starNode.physicsBody?.collisionBitMask = 0
        starNode.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        starNode.color = SKColor.blue
        return starNode
    }
    
    private func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    private func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
}
