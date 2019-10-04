//
//  GameScene.swift
//  Pong
//
//  Created by Andy Dymond on 10/4/19.
//  Copyright © 2019 Andy Dymond. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
  var ball = SKSpriteNode()
  var enemyPaddle = SKSpriteNode()
  var mainPaddle = SKSpriteNode()
  var ballStartYPosition = CGFloat(0)

  var mainScoreLabel = SKLabelNode()
  var enemyScoreLabel = SKLabelNode()

  var score = [Int]()

  override func didMove(to view: SKView) {
    layoutScene()
    startGame()
  }

  func startGame() {
    score = [0, 0]
    ball.physicsBody?.applyImpulse(CGVector(dx: -20, dy: -20))
  }

  func layoutScene() {
    self.scaleMode = .aspectFit
    mainScoreLabel = self.childNode(withName: "mainScoreLabel") as! SKLabelNode
    enemyScoreLabel = self.childNode(withName: "enemyScoreLabel") as! SKLabelNode
    ball = self.childNode(withName: "ball") as! SKSpriteNode
    enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode

    mainPaddle = self.childNode(withName: "mainPaddle") as! SKSpriteNode

    ballStartYPosition = ball.position.y
    let border = SKPhysicsBody(edgeLoopFrom: self.frame)
    border.friction = 0
    border.restitution = 1
    self.physicsBody = border
  }

  func addScore(_ player: SKSpriteNode) {
    ball.position = CGPoint(x: 0, y: 0)
    ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    if player == mainPaddle {
      score[0] += 1
      mainScoreLabel.text = "\(score[0])"
      ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
    } else if player == enemyPaddle {
      score[1] += 1
      enemyScoreLabel.text = "\(score[1])"
      ball.physicsBody?.applyImpulse(CGVector(dx: -20, dy: -20))
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      if currentGameType == .twoPlayer {
        if location.y > 0 {
          enemyPaddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }

        if location.y < 0 {
          mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }

      } else {
        mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
      }
    }
  }

  override func update(_ currentTime: TimeInterval) {
    if ball.position.y <= mainPaddle.position.y - 25 {
      addScore(enemyPaddle)
    } else if ball.position.y >= enemyPaddle.position.y + 25 {
      addScore(mainPaddle)
    }

    if ball.position.y == ballStartYPosition {
      let yForce = ballStartYPosition > 0 ? -1 : 1
      ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: yForce))
    }
    ballStartYPosition = ball.position.y

    configureEnemy()
  }

  func configureEnemy() {
    switch currentGameType {
    case .easy:
      enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.5))
    case .medium:
      enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.25))
    case .hard:
      enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.01))
    case .twoPlayer:
      enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.5))
    }
  }
}
