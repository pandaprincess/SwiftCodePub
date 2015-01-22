//
//  FlappyBeerScene.swift
//  CodePub
//
//  Created by Susanne Moseby on 22/01/15.
//  Copyright (c) 2015 codepub. All rights reserved.
//

import SpriteKit

class FlappyBeerScene: SKScene, SKPhysicsContactDelegate {
    let verticalPipeGap = 150.0
    let skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    let pipeUpTexture = SKTexture(imageNamed: "PipeUp")
    let pipeDownTexture = SKTexture(imageNamed: "PipeDown")
    let scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
    let moving = SKNode()
    let pipes = SKNode()
    
    var beer:SKSpriteNode!
    var movePipesAndRemove:SKAction!
    var flap:SKAction!
    var canRestart = false
    var score = 0
    
    let beerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.position = CGPointZero
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        // setup physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        self.physicsWorld.contactDelegate = self
        self.addChild(moving)
        
        // setup background color
        self.backgroundColor = skyColor
        
        // ground
        self.setupGround()

        // skyline
        self.setupSky()
        
        // spawn the pipes
        self.setupPipes()
        
        // setup our beer
        self.setupbeer()
        
        // setup score
        self.setupScore()
    }
    
    func setupSky() {
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .Nearest
        let moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveByX(skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatActionForever(moveSkySprite)
        
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / (skyTexture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0 + skyTexture.size().height * 2.0)
            sprite.runAction(moveSkySpritesForever)
            moving.addChild(sprite)
        }
    }
    
    
    func setupPipes() {
        pipeDownTexture.filteringMode = .Nearest
        pipeUpTexture.filteringMode = .Nearest
        let spawn = SKAction.runBlock(self.spawnPipes)
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        moving.addChild(pipes)
        
    }
    
    func setupGround() {
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .Nearest
        let moveGroundSprite = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: NSTimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveByX(groundTexture.size().width, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
        
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( groundTexture.size().width); ++i {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0)
            sprite.runAction(moveGroundSpritesForever)
            moving.addChild(sprite)
        }
        
        // create the ground
        var ground = SKSpriteNode(texture: groundTexture)
        ground.position = CGPointMake(0, groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 2.0))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)
    }
    
    func setupbeer() {
        let beerTexture1 = SKTexture(imageNamed: "beer01")
        let beerTexture2 = SKTexture(imageNamed: "beer02")
        let beerTexture3 = SKTexture(imageNamed: "beer03")
        let beerTexture4 = SKTexture(imageNamed: "beer04")
        beerTexture1.filteringMode = .Nearest
        beerTexture2.filteringMode = .Nearest

        beer = SKSpriteNode(texture: beerTexture1)
        beer.setScale(2.0)
        beer.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        
        let anim = SKAction.animateWithTextures([beerTexture1, beerTexture2, beerTexture3, beerTexture4], timePerFrame: 0.2)
        flap = SKAction.repeatActionForever(anim)
        beer.runAction(flap)
        
        beer.physicsBody = SKPhysicsBody(circleOfRadius: beer.size.height / 2.0)
        beer.physicsBody?.dynamic = true
        beer.physicsBody?.allowsRotation = false
        
        beer.physicsBody?.categoryBitMask = beerCategory
        beer.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        beer.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(beer)
    }
    
    func setupScore() {
        scoreLabelNode.position = CGPointMake( CGRectGetMidX( self.frame ), 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        beer.zRotation = self.clamp( -1, max: 0.5, value: beer.physicsBody!.velocity.dy * ( beer.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 ) )
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if moving.speed > 0  {
            for touch: AnyObject in touches {
                beer.physicsBody?.velocity = CGVectorMake(0, 0)
                beer.physicsBody?.applyImpulse(CGVectorMake(0, 30))
            }
        } else if canRestart {
            self.resetScene()
        }
    }
    
    func resetScene() {
        // Move beer to original position and reset velocity
        beer.position = CGPointMake(self.frame.size.width / 2.5, CGRectGetMidY(self.frame))
        beer.physicsBody?.velocity = CGVectorMake( 0, 0 )
        beer.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        beer.speed = 2.0
        beer.zRotation = 0.0
        
        // Remove all existing pipes
        pipes.removeAllChildren()
        
        // Reset _canRestart
        canRestart = false
        
        // Reset score
        score = 0
        scoreLabelNode.text = String(score)
        
        // Restart animation
        moving.speed = 2
    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPointMake( self.frame.size.width + pipeUpTexture.size().width * 2, 0 )
        pipePair.zPosition = -10
        
        let height = UInt32( UInt(self.frame.size.height / 4) )
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0.0, CGFloat(Double(y)) + pipeDown.size.height + CGFloat(verticalPipeGap))
        
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = beerCategory
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(Double(y)))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = beerCategory
        pipePair.addChild(pipeUp)
        
        var contactNode = SKNode()
        contactNode.position = CGPointMake( pipeDown.size.width + beer.size.width / 2, CGRectGetMidY( self.frame ) )
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake( pipeUp.size.width, self.frame.size.height ))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = beerCategory
        pipePair.addChild(contactNode)
        
        pipePair.runAction(movePipesAndRemove)
        pipes.addChild(pipePair)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if moving.speed > 0 {
            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                // beer has contact with score entity
                score++
                scoreLabelNode.text = String(score)
                
                // Add a little visual feedback for the score increment
                scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
            } else {
                moving.speed = 0
                
                beer.physicsBody?.collisionBitMask = worldCategory
                beer.runAction(  SKAction.rotateByAngle(CGFloat(M_PI) * CGFloat(beer.position.y) * 0.01, duration:1), completion:{self.beer.speed = 0 })
                
                let flashBackground = SKAction.sequence([
                    SKAction.runBlock({ self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)}),
                    SKAction.waitForDuration(NSTimeInterval(0.05)),
                    SKAction.runBlock({ self.backgroundColor = self.skyColor}),
                    SKAction.waitForDuration(NSTimeInterval(0.05))
                    ])
                
                self.runAction(SKAction.repeatAction(flashBackground, count: 4), completion: {self.canRestart = true})
            }
        }
    }
    
    func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if ( value > max ) {
            return max
        } else if ( value < min ) {
            return min
        } else {
            return value
        }
    }
}
