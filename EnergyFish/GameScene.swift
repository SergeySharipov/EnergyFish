//
//  GameScene.swift
//  EnergyFish
//
//  Created by Sergey on 21.02.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameStarted = Bool(false)
    var died = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var closeBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var blowfishStar = SKNode()
    var moveAndRemove = SKAction()
    
    var blowfishStarCreater = BlowfishStarCreater()
    var fishCreater = FishCreater()
    
    var fish = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            gameStarted =  true
            fish.physicsBody?.affectedByGravity = true
            createPauseBtn()
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            taptoplayLbl.removeFromParent()
            
            let spawn = SKAction.run({
                () in
                self.blowfishStar = self.createBlowfishStar()
                self.blowfishStar.run(self.moveAndRemove)
                self.addChild(self.blowfishStar)
            })
            
            let delay = SKAction.wait(forDuration: 2)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + blowfishStar.frame.width)
            let moveBlowfishStar = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removeBlowfishStar = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([moveBlowfishStar, removeBlowfishStar])
            
            fish.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            fish.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            
        } else if died == false {
            fish.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            fish.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        }
        
        for touch in touches{
            let location = touch.location(in: self)
            if died == true{
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!{
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                } else if closeBtn.contains(location){
                    closeScene()
                }
            } else {
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
    }
    
    func closeScene(){
        let viewController = self.view?.window?.rootViewController
        viewController?.reloadViewFromNib()
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
    }
    
    func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.fishCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 130.0/255.0, green: 215.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "background")
            background.setScale(0.7)
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * background.size.width, y:0)
            background.name = "background"
            self.addChild(background)
        }
        
        self.addChild(createBubbles())
        
        self.fish = createFish()
        self.addChild(fish)
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        createLogo()
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if (firstBody.categoryBitMask == CollisionBitMask.fishCategory && secondBody.categoryBitMask == CollisionBitMask.blowfishCategory) || (firstBody.categoryBitMask == CollisionBitMask.blowfishCategory && secondBody.categoryBitMask == CollisionBitMask.fishCategory) || (firstBody.categoryBitMask == CollisionBitMask.fishCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory) || (firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.fishCategory) {
            enumerateChildNodes(withName: BlowfishStarCreater.NAME, using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                died = true
                createGameOverBtns()
                pauseBtn.removeFromParent()
                self.fish.removeAllActions()
            }
        } else if (firstBody.categoryBitMask == CollisionBitMask.fishCategory && secondBody.categoryBitMask == CollisionBitMask.starCategory) || (firstBody.categoryBitMask == CollisionBitMask.starCategory && secondBody.categoryBitMask == CollisionBitMask.fishCategory) {
            run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
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
        if gameStarted == true && died == false{
            moveBackground()
        }
    }
}
