//
//  GameScene.swift
//  FlappyBird
//
//  Created by Yang Li on 22/08/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
  let verticalPipeGap = 150.0
  
  var bird: SKSpriteNode!
  var skyColor: SKColor!
  var pipeTextureUp: SKTexture!
  var pipeTextureDown: SKTexture!
  var movePipesAndRemove: SKAction!
  var moving: SKNode!
  var pipes: SKNode!
  var canRestart = Bool()
  var scoreLabelNode: SKLabelNode!
  var score = NSInteger()
  
  let birdCategory: UInt32 = 1 << 0
  let worldCategory: UInt32 = 1 << 1
  let pipeCategory: UInt32 = 1 << 2
  let scoreCategory: UInt32 = 1 << 3
  
  override func didMove(to view: SKView) {
    canRestart = false
    
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
    physicsWorld.contactDelegate = self
    
    skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    self.backgroundColor = skyColor
    
    moving = SKNode()
    self.addChild(moving)
    pipes = SKNode()
    moving.addChild(pipes)
    
    let groundTexture = SKTexture(imageNamed: "land")
    groundTexture.filteringMode = .nearest
    
    let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.02 * groundTexture.size().width * 2.0))
    let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
    let moveGroundSpritesForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
    
    for i in 0 ..< 2 + Int(self.frame.size.width / (groundTexture.size().width * 2)) {
      let sprite = SKSpriteNode(texture: groundTexture)
      sprite.setScale(2.0)
      sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: sprite.size.height / 2.0)
      sprite.run(moveGroundSpritesForever)
      moving.addChild(sprite)
    }
    
    let skyTexture = SKTexture(imageNamed: "sky")
    skyTexture.filteringMode = .nearest
    
    let moveSkySprite = SKAction.moveBy(x: -skyTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.1 * skyTexture.size().width * 2.0))
    let resetSkySprite = SKAction.moveBy(x: skyTexture.size().width * 2.0, y: 0, duration: 0.0)
    let moveSkySpritesForever = SKAction.repeatForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
    
    for i in 0 ..< 2 + Int(self.frame.size.width / (skyTexture.size().width * 2)) {
      let sprite = SKSpriteNode(texture: skyTexture)
      sprite.setScale(2.0)
      sprite.zPosition = -20
      sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
      sprite.run(moveSkySpritesForever)
      moving.addChild(sprite)
    }
    
    pipeTextureUp = SKTexture(imageNamed: "pipeup")
    pipeTextureUp.filteringMode = .nearest
    pipeTextureDown = SKTexture(imageNamed: "pipedown")
    pipeTextureDown.filteringMode = .nearest
    
    let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
    let movePipes = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(0.01 * distanceToMove))
    let removePipes = SKAction.removeFromParent()
    movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
    
    let spawn = SKAction.run(spawnPipes)
    let delay = SKAction.wait(forDuration: TimeInterval(2.0))
    let spawnThenDelay = SKAction.sequence([spawn, delay])
    let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
    self.run(spawnThenDelayForever)
    
    let birdTexture1 = SKTexture(imageNamed: "bird-1")
    birdTexture1.filteringMode = .nearest
    let birdTexture2 = SKTexture(imageNamed: "bird-2")
    birdTexture2.filteringMode = .nearest
    
    let animation = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.2)
    let flap = SKAction.repeatForever(animation)
    
    bird = SKSpriteNode(texture: birdTexture1)
    bird.setScale(2.0)
    bird.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.6)
    bird.run(flap)
    
    bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
    bird.physicsBody?.isDynamic = true
    bird.physicsBody?.allowsRotation = false
    
    bird.physicsBody?.categoryBitMask = birdCategory
    bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
    bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
    
    self.addChild(bird)
    
    let ground = SKNode()
    ground.position = CGPoint(x: 0, y: groundTexture.size().height)
    ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: groundTexture.size().height * 2.0))
    ground.physicsBody?.isDynamic = false
    ground.physicsBody?.categoryBitMask = worldCategory
    self.addChild(ground)
    
    score = 0
    scoreLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    scoreLabelNode.position = CGPoint(x: self.frame.midX, y: 3 * self.frame.size.height / 4)
    scoreLabelNode.zPosition = 100
    scoreLabelNode.text = String(score)
    self.addChild(scoreLabelNode)
    
  }
  
  func spawnPipes() {
    let pipePair = SKNode()
    pipePair.position = CGPoint(x: self.frame.size.width + pipeTextureUp.size().width * 2, y: 0)
    pipePair.zPosition = -10
    
    let height = UInt32(self.frame.size.height / 4)
    let y = Double(arc4random_uniform(height) + height)
    
    let pipeDown = SKSpriteNode(texture: pipeTextureDown)
    pipeDown.setScale(2.0)
    pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + verticalPipeGap)
    
    pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
    pipeDown.physicsBody?.isDynamic = false
    pipeDown.physicsBody?.categoryBitMask = pipeCategory
    pipeDown.physicsBody?.contactTestBitMask = birdCategory
    pipePair.addChild(pipeDown)
    
    let pipeUp = SKSpriteNode(texture: pipeTextureUp)
    pipeUp.setScale(2.0)
    pipeUp.position = CGPoint(x: 0.0, y: y)
    
    pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
    pipeUp.physicsBody?.isDynamic = false
    pipeUp.physicsBody?.categoryBitMask = pipeCategory
    pipeUp.physicsBody?.contactTestBitMask = birdCategory
    pipePair.addChild(pipeUp)
    
    let contactNode = SKNode()
    contactNode.position = CGPoint(x: pipeDown.size.width + bird.size.width / 2, y: self.frame.midY)
    contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeUp.size.width, height: self.frame.size.height))
    contactNode.physicsBody?.isDynamic = false
    contactNode.physicsBody?.categoryBitMask = scoreCategory
    contactNode.physicsBody?.contactTestBitMask = birdCategory
    pipePair.addChild(contactNode)
    
    pipePair.run(movePipesAndRemove)
    pipes.addChild(pipePair)
  }
  
  func resetScene() {
    bird.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.midY)
    bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
    bird.speed = 1.0
    bird.zRotation = 0.0
    
    pipes.removeAllChildren()
    
    canRestart = false
    
    score = 0
    scoreLabelNode.text = String(score)
    
    moving.speed = 1
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if moving.speed > 0 {
      for _ in touches {
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
      }
    } else if canRestart {
      self.resetScene()
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    let value = bird.physicsBody!.velocity.dy * (bird.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001)
    bird.zRotation = min(max(-1, value), 0.5)
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    if moving.speed > 0 {
      if (contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory || (contact.bodyB.categoryBitMask & scoreCategory) == scoreCategory {
        score += 1
        scoreLabelNode.text = String(score)
        
        scoreLabelNode.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.1)), SKAction.scale(to: 1.0, duration:TimeInterval(0.1))]))
      } else {
        moving.speed = 0
        
        bird.physicsBody?.collisionBitMask = worldCategory
        bird.run(SKAction.rotate(byAngle: CGFloat(Double.pi) * CGFloat(bird.position.y) * 0.01, duration: 1), completion: {
          self.bird.speed = 0
        })
        self.removeAction(forKey: "flash")
        self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
          self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        }),SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
          self.backgroundColor = self.skyColor
        }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({
          self.canRestart = true
        })]), withKey: "flash")
      }
    }
  }
}

