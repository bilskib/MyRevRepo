//
//  GameController.swift
//  ReversiPA1
//
//  Created by Bartosz on 27.08.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import UIKit
import GameplayKit

class GameController: NSObject {

    var gameModel = GameModel()
    var strategist = GKMinmaxStrategist()
    var view: ViewController!
    
    init(view: ViewController) {
        self.view = view
        strategist.gameModel = gameModel
        strategist.maxLookAheadDepth = 3
    }
    
    func setInitialBoard() {
        gameModel.gameBoard[3,4] = .black
        gameModel.gameBoard[4,3] = .black
        gameModel.gameBoard[3,3] = .white
        gameModel.gameBoard[4,4] = .white
    }
    
}

