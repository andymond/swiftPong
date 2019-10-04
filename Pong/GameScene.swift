//
//  GameScene.swift
//  Pong
//
//  Created by Andy Dymond on 10/4/19.
//  Copyright © 2019 Andy Dymond. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol TransitionDelegate: SKSceneDelegate {
  func returnToMenu()
}

class GameScene: SKScene {
  let quitLabel = SKLabelNode(text: "Quit")
  var ball = SKSpriteNode()
  var enemyPaddle = SKSpriteNode()
  var mainPaddle = SKSpriteNode()
  var ballStartPosition = CGPoint(x: 0.0, y: 0.0)
  var initialForce = 20.0

  var mainScoreLabel = SKLabelNode()
  var enemyScoreLabel = SKLabelNode()

  var score = [Int]()

  override func sceneDidLoad() {
    super.sceneDidLoad()
    print("SCENE DID LOAD")
  }

  override func didMove(to view: SKView) {
    layoutScene()
    startGame()
  }

  func startGame() {
    score = [0, 0]
    configureDifficulty()
    ball.physicsBody?.applyImpulse(CGVector(dx: -initialForce, dy: -initialForce))
  }

  func layoutScene() {
    configureQuitLabel()
    self.scaleMode = .aspectFit
    mainScoreLabel = self.childNode(withName: "mainScoreLabel") as! SKLabelNode
    enemyScoreLabel = self.childNode(withName: "enemyScoreLabel") as! SKLabelNode
    ball = self.childNode(withName: "ball") as! SKSpriteNode
    enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode

    mainPaddle = self.childNode(withName: "mainPaddle") as! SKSpriteNode

    ballStartPosition = ball.position
    let border = SKPhysicsBody(edgeLoopFrom: self.frame)
    border.friction = 0
    border.restitution = 1
    self.physicsBody = border
  }

  func configureQuitLabel() {
    quitLabel.name = "quit"
    quitLabel.fontName = "PressStart2P"
    quitLabel.position = CGPoint(x: 0, y: 0)
    quitLabel.isHidden = true
    self.addChild(quitLabel)
  }

  func addScore(_ player: SKSpriteNode) {
    ball.position = CGPoint(x: 0, y: 0)
    ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    initialForce += 0.5
    if player == mainPaddle {
      score[0] += 1
      mainScoreLabel.text = "\(score[0])"
      ball.physicsBody?.applyImpulse(CGVector(dx: initialForce, dy: initialForce))
    } else if player == enemyPaddle {
      score[1] += 1
      enemyScoreLabel.text = "\(score[1])"
      ball.physicsBody?.applyImpulse(CGVector(dx: -initialForce, dy: -initialForce))
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)

      if self.isPaused {
        let touched = atPoint(location)
        if touched.name == "quit" {
          guard let delegate = self.delegate else { return }
          self.view?.presentScene(nil)
          (delegate as! TransitionDelegate).returnToMenu()
        }
      }

      if touch.tapCount >= 2 {
        handlePause()
      } else {
        mainPaddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
      }
    }
  }

  func handlePause() {
    if self.isPaused == true {
      quitLabel.isHidden = true
      self.isPaused = false
    } else {
      quitLabel.isHidden = false
      self.isPaused = true
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
    keepScore()
    preventUnidirectionalMotionLoops()
    configureEnemy()
  }

  func keepScore() {
    if ball.position.y <= mainPaddle.position.y - 25 {
      addScore(enemyPaddle)
    } else if ball.position.y >= enemyPaddle.position.y + 25 {
      addScore(mainPaddle)
    }
  }

  func preventUnidirectionalMotionLoops() {
    if abs(ball.position.y - ballStartPosition.y) < 2 {
      let yForce = ballStartPosition.y > 0 ? -1 : 1
      ball.physicsBody?.applyImpulse(CGVector(dx: 1, dy: yForce))
    }

    if ballStartPosition.x == ball.position.x {
      let xForce = ballStartPosition.y > 0 ? -1 : 1
      ball.physicsBody?.applyImpulse(CGVector(dx: xForce, dy: 1))
    }

    ballStartPosition = ball.position
  }

  func configureDifficulty() {
    switch currentGameType {
    case .medium:
      enemyPaddle.physicsBody?.restitution = 1.1
      initialForce += 1
    case .hard:
      ball.physicsBody?.allowsRotation = true
      enemyPaddle.physicsBody?.restitution = 1.4
      initialForce += 5
    case .twoPlayer:
      ball.physicsBody?.restitution = 1.1
      ball.physicsBody?.allowsRotation = true
    default:
      break
    }
  }

  func configureEnemy() {
    switch currentGameType {
    case .easy:
      enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.7))
    case .medium:
      enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.6))
    case .hard:
      enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.4))
    case .twoPlayer:
      break
    }
  }

  deinit {
      print("\n THE SCENE \((type(of: self))) WAS REMOVED FROM MEMORY (DEINIT) \n")
  }
}
