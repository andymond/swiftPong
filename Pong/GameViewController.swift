//
//  GameViewController.swift
//  Pong
//
//  Created by Andy Dymond on 10/4/19.
//  Copyright © 2019 Andy Dymond. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var currentGameType = gameType.easy

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    if let view = self.view as! SKView? {
      if let scene = SKScene(fileNamed: "GameScene") {
        scene.scaleMode = .aspectFit
        scene.delegate = self as TransitionDelegate
        view.presentScene(scene)
      }

      view.ignoresSiblingOrder = true
    }
  }

  override var shouldAutorotate: Bool {
      return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      if UIDevice.current.userInterfaceIdiom == .phone {
          return .allButUpsideDown
      } else {
          return .all
      }
  }

  override var prefersStatusBarHidden: Bool {
      return true
  }
}

extension GameViewController: TransitionDelegate {
  func returnToMenu() {
    self.navigationController?.popViewController(animated: true)
  }
}
