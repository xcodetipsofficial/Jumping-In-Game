//
//  GameScene.swift
//  JumpSonicGame
//
//  Created by Kyle Wilson on 2019-12-18.
//  Copyright © 2019 Xcode Tips. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sonic: SKSpriteNode!
    var platform: SKSpriteNode!
    
    var idleFlag = false
    
    var runningFrames: [SKTexture] = []
    var jumpingFrames: [SKTexture] = []

    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        self.physicsWorld.contactDelegate = self
        
        createRunAnimation()
        createJumpAnimation()
        createPlatform()
        createSonic()
        animateSonicRunning()
    }
    
    func createPlatform() {
        let platformTexture = SKTexture(imageNamed: "land")
        platformTexture.filteringMode = .nearest
        platform = SKSpriteNode(texture: platformTexture)
        platform.size = CGSize(width: frame.width, height: 150)
        platform.position = CGPoint(x: frame.midX, y: frame.midY - 150)
        platform.name = "platform"
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.categoryBitMask = 2
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.usesPreciseCollisionDetection = true
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.restitution = 0
        addChild(platform)
    }
    
    func createSonic() {
        let firstFrameTexture = runningFrames[0]
        sonic = SKSpriteNode(texture: firstFrameTexture)
        sonic.size = CGSize(width: 50, height: 50)
        sonic.position = CGPoint(x: frame.midX, y: frame.midY)
        sonic.zPosition = 2
        sonic.name = "sonic"
        sonic.physicsBody = SKPhysicsBody(rectangleOf: sonic.frame.size)
        sonic.physicsBody?.categoryBitMask = 1
        sonic.physicsBody?.isDynamic = true
        sonic.physicsBody?.usesPreciseCollisionDetection = true
        sonic.physicsBody?.contactTestBitMask = 2
        sonic.physicsBody?.affectedByGravity = true
        sonic.physicsBody?.restitution = 0
        addChild(sonic)
    }
    
    func createRunAnimation() {
        let runAnimation = SKTextureAtlas(named: "sonic-run")
        var runFrames: [SKTexture] = []
        
        let numImages = runAnimation.textureNames.count
        for i in 1...numImages {
            let sonicRunTextureName = "sonic-run\(i)"
            runFrames.append(runAnimation.textureNamed(sonicRunTextureName))
        }
        runningFrames = runFrames
    }
    
    func createJumpAnimation() {
        let jumpAnimation = SKTextureAtlas(named: "sonic-jump")
        var jumpFrames: [SKTexture] = []
        
        let numImages = jumpAnimation.textureNames.count
        for i in 1...numImages {
            let sonicJumpTextureName = "sonic-jump\(i)"
            jumpFrames.append(jumpAnimation.textureNamed(sonicJumpTextureName))
        }
        jumpingFrames = jumpFrames
    }
    
    func animateSonicRunning() {
        sonic.run(SKAction.repeatForever(SKAction.animate(with: runningFrames, timePerFrame: 0.1, resize: false, restore: true)))
    }
    
    func animateSonicJumping() {
        sonic.run(SKAction.repeatForever(SKAction.animate(with: jumpingFrames, timePerFrame: 0.1)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sonic = childNode(withName: "sonic") as? SKSpriteNode
        if idleFlag {
            sonic?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            animateSonicJumping()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        idleFlag = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        idleFlag = true
        print("collision")
        animateSonicRunning()
    }
    
}
