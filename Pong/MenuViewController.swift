//
//  MenuViewController.swift
//  Pong
//
//  Created by Thomas De Lange on 22-04-18.
//  Copyright © 2018 Thomas De Lange. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

enum gameType{
    case easy
    case medium
    case hard
    case twoPlayer
    case AI
}

class MenuViewController: UIViewController {
    
    @IBAction func setTwoPlayerMode(_ sender: Any) {
        moveToGame(game: .twoPlayer)

    }
    @IBAction func setEasyMode(_ sender: Any) {
        moveToGame(game: .easy)
    }
    
    @IBAction func setMediumMode(_ sender: Any) {
        moveToGame(game: .medium)
    }
    
    @IBAction func setHardMode(_ sender: Any) {
        moveToGame(game: .hard)

    }
    @IBAction func aiMode(_ sender: Any) {
        moveToGame(game: .AI)
    }
    
    func moveToGame(game : gameType){
        let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
        currentGameType = game
        print("gamemode : \(game)")
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
}
