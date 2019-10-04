//
//  MenuViewController.swift
//  Pong
//
//  Created by Andy Dymond on 10/4/19.
//  Copyright © 2019 Andy Dymond. All rights reserved.
//

import Foundation
import UIKit

enum gameType {
  case easy
  case medium
  case hard
  case twoPlayer
}

class MenuViewController: UIViewController {
  
  @IBAction func easy(_ sender: Any) {
    moveToGame(.easy)
  }

  @IBAction func medium(_ sender: Any) {
    moveToGame(.medium)
  }

  @IBAction func hard(_ sender: Any) {
    moveToGame(.hard)
  }

  @IBAction func twoPlayer(_ sender: Any) {
    moveToGame(.twoPlayer)
  }

  func moveToGame(_ type: gameType) {
    let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
    print("MOVE TO GAME")
    currentGameType = type

    self.navigationController?.pushViewController(gameVC, animated: true)
  }
}
