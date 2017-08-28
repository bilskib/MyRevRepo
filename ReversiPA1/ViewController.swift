//
//  ViewController.swift
//  ReversiPA1
//
//  Created by Bartosz on 12.08.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var gameC: GameController!
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var blackScoreLabel: UILabel!
    @IBOutlet weak var whiteScoreLabel: UILabel!
    
    func alertGameOver() {
        let gameOverAlert = UIAlertController(title: "Game over", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let blackDisks: Int = gameC.gameModel.gameBoard.countDisk(gameBoard: gameC.gameModel.gameBoard, color: "black")
        let whiteDisks: Int = gameC.gameModel.gameBoard.countDisk(gameBoard: gameC.gameModel.gameBoard, color: "white")
        
        if blackDisks > whiteDisks {
            gameOverAlert.message = "Black has won \(blackDisks):\(whiteDisks)!"
        } else if whiteDisks > blackDisks {
            gameOverAlert.message = "White has won \(whiteDisks):\(blackDisks)!"
        } else {
            gameOverAlert.message = "It was a draw!"
        }
        // add an action (button)
        gameOverAlert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: { action in
            self.newGame(UIButton())
        }))
        gameOverAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        // show the alert
        self.present(gameOverAlert, animated: true, completion: nil)
    }
    
    func alertNoMove() {
        let noMoveAlert = UIAlertController(title: "You have to pass", message: "", preferredStyle: UIAlertControllerStyle.alert)
        if gameC.gameModel.activePlayer!.playerId == allPlayers[0].playerId {
            noMoveAlert.message = "Switching to White"
            noMoveAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(noMoveAlert, animated: true, completion: nil)
        } else if gameC.gameModel.activePlayer!.playerId == allPlayers[1].playerId {
            noMoveAlert.message = "Switching to Black"
            noMoveAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(noMoveAlert, animated: true, completion: nil)
        }
    }
    
    func alertInvalidMove() {
        let invalidMoveAlert = UIAlertController(title: "Invalid move", message: "", preferredStyle: UIAlertControllerStyle.alert)
        invalidMoveAlert.message = "Think again."
        invalidMoveAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(invalidMoveAlert, animated: true, completion: nil)
    }
    
    
    
    // make the whole board filled with "empty" cells
    func resetBoard(gameboard: Board) {
        for i in 0..<8 {
            for j in 0..<8 {
                let tagNumber = 100 + i * 10 + j
                let cellButton = view.viewWithTag(tagNumber) as? UIButton
                    cellButton?.setImage(nil, for: .normal)
                gameC.gameModel.gameBoard[i,j] = .empty
            }
        }
    }
    
    // make "valid" cell an "empty" cell
    func resetValid(gameboard: Board) {
        for i in 0..<8 {
            for j in 0..<8 {
                if gameC.gameModel.gameBoard[i,j] == .valid {
                    gameC.gameModel.gameBoard[i,j] = .empty
                }
            }
        }
    }
    
    func resetCurrent(gameboard: Board) {
        for i in 0..<8 {
            for j in 0..<8 {
                if gameC.gameModel.gameBoard[i,j] == .blackLast {
                    gameC.gameModel.gameBoard[i,j] = .black
                } else if gameC.gameModel.gameBoard[i,j] == .whiteLast {
                    gameC.gameModel.gameBoard[i,j] = .white
                }
            }
        }
    }
    
    // print the actual board to the console output
    func printBoard() {
        print(".................................................................................................")
        print("  0     1     2     3     4     5     6     7  /")
        for i in 0...7 {
            print("-------------------------------------------------")
            for j in 0...7{
                print( gameC.gameModel.gameBoard[i,j], terminator: "|")
            }
            print(i)
        }
        print("-------------------------------------------------")
        print("activePlayer/currentPlayer (0-BLACK):", gameC.gameModel.activePlayer!.playerId)
        
        print("BLACK @: ", gameC.gameModel.locateDisks(color: .black, gameboard: gameC.gameModel.gameBoard))
        //gameC.gameModel.locateDisks(color: .black, gameboard: gameC.gameModel.gameBoard)[0].x
        print("WHITE @: ", gameC.gameModel.locateDisks(color: .white, gameboard: gameC.gameModel.gameBoard))
        print("VALID @: ", gameC.gameModel.locateDisks(color: .valid, gameboard: gameC.gameModel.gameBoard))
        whiteScoreLabel.text = String(gameC.gameModel.gameBoard.countDisk(gameBoard: gameC.gameModel.gameBoard, color: "white"))
        blackScoreLabel.text = String(gameC.gameModel.gameBoard.countDisk(gameBoard: gameC.gameModel.gameBoard, color: "black"))
    }
    
    // draw the board based on cell type
    func drawBoard() {
        for i in 0..<8 {
            for j in 0..<8 {
                // Creating button tags
                let tagNumber = 100 + i * 10 + j
                guard let cellButton = view.viewWithTag(tagNumber) as? UIButton else {
                    print("Error! Can't find button with tag \(tagNumber)")
                    continue
                }
                if gameC!.gameModel.gameBoard[i,j].rawValue == 1 {
                    cellButton.setImage(UIImage(named: "blackPiece.png"), for: .normal)
                } else if gameC!.gameModel.gameBoard[i,j].rawValue == 2 {
                    cellButton.setImage(UIImage(named: "whitePiece.png"), for: .normal)
                } else if gameC!.gameModel.gameBoard[i,j].rawValue == 3 {
                    cellButton.setImage(UIImage(named: "availableMove.png"), for: .normal)
                } else if gameC!.gameModel.gameBoard[i,j].rawValue == 11 {
                    cellButton.setImage(UIImage(named: "blackPieceLast.png"), for: .normal)
                } else if gameC!.gameModel.gameBoard[i,j].rawValue == 22 {
                    cellButton.setImage(UIImage(named: "whitePieceLast.png"), for: .normal)
                } else {
                    cellButton.setImage(nil, for: .normal)
                }
            }
        }
    }
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func action(_ sender: UIButton)
    {
        // Converting button tag into X, Y coordinates on the game board.
        var posX: Int! = sender.tag
        posX = (posX-100)/10
        var posY: Int! = sender.tag
        posY = (posY-100)%10
        
        gameC.gameModel.scanActivePlayer(activePlayer: gameC.gameModel.activePlayer!, gameboard: gameC.gameModel.gameBoard)
        
        if gameC.gameModel.gameBoard[posX,posY] == .valid {
            gameC.gameModel.gameBoard[posX,posY] = .blackLast
        }
        drawBoard()
        printBoard()
        gameC.gameModel.flipDisk(activePlayer: gameC.gameModel.activePlayer, gameBoard: gameC.gameModel.gameBoard, x: posX, y: posY)
        
        drawBoard()
        printBoard()
        resetValid(gameboard: gameC.gameModel.gameBoard)
        resetCurrent(gameboard: gameC.gameModel.gameBoard)
        printBoard()
        //gameC.gameModel.currentPlayer = gameC.gameModel.currentPlayer.oppositePlayer
        gameC.gameModel.scanActivePlayer(activePlayer: gameC.gameModel.activePlayer!, gameboard: gameC.gameModel.gameBoard)
        printBoard()
        drawBoard()
        gameC.gameModel.switchPlayer()
        //if gameC.gameModel.gameBoard[posX,posY] == .valid {
            gameC.aiMove2()
        drawBoard()
        printBoard()
        //}
        resetCurrent(gameboard: gameC.gameModel.gameBoard)
        resetValid(gameboard: gameC.gameModel.gameBoard)
    
    }
//        informationLabel.text = nil
//        gameC.gameModel.scanActivePlayer(activePlayer: gameC.gameModel.activePlayer!, gameboard: gameC.gameModel.gameBoard)
//        
//        if gameC.gameModel.hasValidMove(activePlayer: gameC.gameModel.activePlayer!, gameboard: gameC.gameModel.gameBoard) {
//            
//            if (gameC.gameModel.activePlayer!.playerId == allPlayers[0].playerId) {
//                if gameC.gameModel.gameBoard[posX,posY] == .valid {
//                    resetCurrent(gameboard: gameC.gameModel.gameBoard)
//                    gameC.gameModel.gameBoard[posX,posY] = .blackLast
//                    resetValid(gameboard: gameC.gameModel.gameBoard)
//                    gameC.gameModel.flipDisk(activePlayer: gameC.gameModel.activePlayer, gameBoard: gameC.gameModel.gameBoard, x: posX, y: posY)
//                    //gameC.gameModel.switchPlayer()
//                    gameC.gameModel.currentPlayer = gameC.gameModel.currentPlayer.oppositePlayer
//                    gameC.aiMove2()
//                } else {
//                    alertInvalidMove()
//                }
//            } else if (gameC.gameModel.activePlayer!.playerId == allPlayers[1].playerId) {
////                if gameC.gameModel.gameBoard[posX,posY] == .valid {
////                    resetCurrent(gameboard: gameC.gameModel.gameBoard)
////                    gameC.gameModel.gameBoard[posX,posY] = .whiteLast
////                    resetValid(gameboard: gameC.gameModel.gameBoard)
////                    gameC.gameModel.flipDisk(activePlayer: gameC.gameModel.activePlayer, gameBoard: gameC.gameModel.gameBoard, x: posX, y: posY)
////                    gameC.gameModel.switchPlayer()
//                resetCurrent(gameboard: gameC.gameModel.gameBoard)
//                gameC.aiMove2()
//                drawBoard()
//                resetValid(gameboard: gameC.gameModel.gameBoard)
//                gameC.gameModel.flipDisk(activePlayer: gameC.gameModel.activePlayer, gameBoard: gameC.gameModel.gameBoard, x: posX, y: posY)
//                gameC.gameModel.switchPlayer()
//                } else {
//                    alertInvalidMove()
//                }
//            //}
//        } else {
//            informationLabel.text = "have to pass"
//            gameC.gameModel.switchPlayer()
//            resetValid(gameboard: gameC.gameModel.gameBoard)
//            gameC.gameModel.flipDisk(activePlayer: gameC.gameModel.activePlayer, gameBoard: gameC.gameModel.gameBoard, x: posX, y: posY)
//            drawBoard()
//        }
//        
//        drawBoard()
//        resetValid(gameboard: gameC.gameModel.gameBoard)
//        gameC.gameModel.scanActivePlayer(activePlayer: gameC.gameModel.activePlayer!, gameboard: gameC.gameModel.gameBoard)
//        printBoard()
//        drawBoard()
//        
//        if !(gameC.gameModel.hasValidMove(activePlayer: gameC.gameModel.activePlayer!, gameboard: gameC.gameModel.gameBoard)) {
//            //alertNoMove()
//            informationLabel.text = "have to pass"
//            gameC.gameModel.switchPlayer()
//            gameC.gameModel.scanActivePlayer(activePlayer: gameC.gameModel.activePlayer!, gameboard: gameC.gameModel.gameBoard)
//            printBoard()
//            drawBoard()
//            if !(gameC.gameModel.hasValidMove(activePlayer: gameC.gameModel.activePlayer!, gameboard: gameC.gameModel.gameBoard)) {
//                alertGameOver()
//            }
//        }
//        
//    }
    
    @IBAction func newGame(_ sender: Any) {
        resetBoard(gameboard: gameC.gameModel.gameBoard)
        informationLabel.text = nil
        gameC.gameModel.currentPlayer = allPlayers[0]   // - BLACK first
        gameC!.setInitialBoard()
        //setInitialBoard()
        gameC.gameModel.scanActivePlayer(activePlayer: gameC.gameModel.activePlayer!, gameboard: gameC.gameModel.gameBoard)
        drawBoard()
        printBoard()
    }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gameC = GameController(view: self)
        gameC.gameModel.currentPlayer = allPlayers[0]
        gameC!.setInitialBoard()
        gameC.gameModel.scanActivePlayer(activePlayer: gameC.gameModel.activePlayer!, gameboard: gameC.gameModel.gameBoard)
        drawBoard()
        printBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



