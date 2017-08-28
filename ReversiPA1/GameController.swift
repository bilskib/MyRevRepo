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
    
    fileprivate func makeMove(_ x: Int,_ y: Int) {
        
        //if gameModel.gameBoard[x,y] == .valid {
            gameModel.scanActivePlayer(activePlayer: gameModel.activePlayer!, gameboard: gameModel.gameBoard)
            view.resetCurrent(gameboard: gameModel.gameBoard)
            view.printBoard()
            if gameModel.gameBoard[x,y] == .valid {
                //gameModel.gameBoard[x,y] = .whiteLast
                //view.resetValid(gameboard: gameModel.gameBoard)
                gameModel.flipDisk(activePlayer: gameModel.activePlayer, gameBoard: gameModel.gameBoard, x: x, y: y)
                view.drawBoard()
                view.printBoard()
                gameModel.switchPlayer()
                gameModel.currentPlayer = gameModel.currentPlayer.oppositePlayer
        }
        //}
        
//        addChip(gameModel.currentPlayer.chip, x, y)
//        flipUIDiscs(x, y)
//        updateBoard()
//        gameView.showGameInfo(-1)
//        
//        let white = numberOfDiscs(gameModel.board, .white)
//        let black = numberOfDiscs(gameModel.board, .black)
//        
//        gameModel.currentPlayer = gameModel.currentPlayer.opponent
//    
    }
    
    func aiMove2() {
        let move = self.strategist.bestMoveForActivePlayer() as! Move
        self.makeMove(move.x, move.y)
    }
    
    func aiMove()
    {
        let delay = 1.0
        let time = DispatchTime.now() + Double(Int64(delay*Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        let mQueue = DispatchQueue.main
        let cQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        cQueue.asyncAfter(deadline: time,
                          execute: {
//                            switch numberOfEmptySquares(self.gameModel.board) {
//                            case 45...60: //openning game
//                                self.strategist.maxLookAheadDepth = self.aiLevels[self.aiCurrentLevel][GameStage.Openning]
//                            case 20...44: //middle game
//                                self.strategist.maxLookAheadDepth = self.aiLevels[self.aiCurrentLevel][GameStage.Middle]
//                            case 0...19:
//                                self.strategist.maxLookAheadDepth = self.aiLevels[self.aiCurrentLevel][GameStage.End]
//                            default:
//                                break;
//                            }
                            
                            let move = self.strategist.bestMoveForActivePlayer() as! Move
                            mQueue.async(execute: {
                                self.makeMove(move.x, move.y)
                            } )
        })
    }
    
}

