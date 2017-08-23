//
//  ViewController.swift
//  ReversiPA1
//
//  Created by Bartosz on 12.08.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = Game()
    var gameBoard = Board(rows: 8, columns: 8)
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var blackScoreLabel: UILabel!
    @IBOutlet weak var whiteScoreLabel: UILabel!
    
    func alertGameOver() {
        let gameOverAlert = UIAlertController(title: "Game over", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let blackDisks: Int = gameBoard.countDisk(gameBoard: gameBoard, color: "black")
        let whiteDisks: Int = gameBoard.countDisk(gameBoard: gameBoard, color: "white")
        
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
        if game.activePlayer!.playerId == allPlayers[0].playerId {
            noMoveAlert.message = "Switching to White"
            noMoveAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(noMoveAlert, animated: true, completion: nil)
        } else if game.activePlayer!.playerId == allPlayers[1].playerId {
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
                gameBoard[i,j] = .empty
            }
        }
    }
    
    // make "valid" cell an "empty" cell
    func resetValid(gameboard: Board) {
        for i in 0..<8 {
            for j in 0..<8 {
                if gameBoard[i,j] == .valid {
                    gameBoard[i,j] = .empty
                }
            }
        }
    }
    
    func resetCurrent(gameboard: Board) {
        for i in 0..<8 {
            for j in 0..<8 {
                if gameBoard[i,j] == .blackLast {
                    gameBoard[i,j] = .black
                } else if gameBoard[i,j] == .whiteLast {
                    gameBoard[i,j] = .white
                }
            }
        }
    }
    
    // print the actual board to the console output
    func printBoard () {
        print(".................................................................................................")
        print("  0     1     2     3     4     5     6     7  /")
        for i in 0..<8 {
            print("-------------------------------------------------")
            for j in 0..<8{
                print( gameBoard[i,j], terminator: "|")
            }
            print(i)
        }
        print("-------------------------------------------------")
        print("activePlayer/currentPlayer (0-BLACK):", game.activePlayer!.playerId)
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
                if gameBoard[i,j].rawValue == 1 {
                    cellButton.setImage(UIImage(named: "blackPiece.png"), for: .normal)
                } else if gameBoard[i,j].rawValue == 2 {
                    cellButton.setImage(UIImage(named: "whitePiece.png"), for: .normal)
                } else if gameBoard[i,j].rawValue == 3 {
                    cellButton.setImage(UIImage(named: "availableMove.png"), for: .normal)
                } else if gameBoard[i,j].rawValue == 11 {
                    cellButton.setImage(UIImage(named: "blackPieceLast.png"), for: .normal)
                } else if gameBoard[i,j].rawValue == 22 {
                    cellButton.setImage(UIImage(named: "whitePieceLast.png"), for: .normal)
                } else {
                    cellButton.setImage(nil, for: .normal)
                }
            }
        }
    }
    
    @IBAction func action(_ sender: UIButton)
    {
        // Converting button tag into X, Y coordinates on the game board.
        var posX: Int! = sender.tag
        posX = (posX-100)/10
        var posY: Int! = sender.tag
        posY = (posY-100)%10
        
        informationLabel.text = nil
        game.scanActivePlayer(activePlayer: game.activePlayer!, gameboard: gameBoard)
        
        if game.hasValidMove(activePlayer: game.activePlayer!, gameboard: gameBoard) {
            
            if (game.activePlayer!.playerId == allPlayers[0].playerId) {
                if gameBoard[posX,posY] == .valid {
                    resetCurrent(gameboard: gameBoard)
                    gameBoard[posX,posY] = .blackLast
                    resetValid(gameboard: gameBoard)
                    game.flipDisk(activePlayer: game.activePlayer, gameBoard: gameBoard, x: posX, y: posY)
                    game.switchPlayer()
                } else {
                    alertInvalidMove()
                }
            } else if (game.activePlayer!.playerId == allPlayers[1].playerId) {
                if gameBoard[posX,posY] == .valid {
                    resetCurrent(gameboard: gameBoard)
                    gameBoard[posX,posY] = .whiteLast
                    resetValid(gameboard: gameBoard)
                    game.flipDisk(activePlayer: game.activePlayer, gameBoard: gameBoard, x: posX, y: posY)
                    game.switchPlayer()
                } else {
                    alertInvalidMove()
                }
            }
        } else {
            informationLabel.text = "have to pass"
            game.switchPlayer()
            resetValid(gameboard: gameBoard)
            game.flipDisk(activePlayer: game.activePlayer, gameBoard: gameBoard, x: posX, y: posY)
            drawBoard()
        }
        
        drawBoard()
        resetValid(gameboard: gameBoard)
        game.scanActivePlayer(activePlayer: game.activePlayer!, gameboard: gameBoard)
        printBoard()
        drawBoard()
        //undoButton.isHidden = false
        
        if !(game.hasValidMove(activePlayer: game.activePlayer!, gameboard: gameBoard)) {
            //alertNoMove()
            informationLabel.text = "have to pass"
            game.switchPlayer()
            game.scanActivePlayer(activePlayer: game.activePlayer!, gameboard: gameBoard)
            printBoard()
            drawBoard()
            if !(game.hasValidMove(activePlayer: game.activePlayer!, gameboard: gameBoard)) {
                alertGameOver()
            }
        }
        print("BLACK @: ", game.locateDisks(color: .black, gameboard: gameBoard))
        print("WHITE @: ", game.locateDisks(color: .white, gameboard: gameBoard))
        print("VALID @: ", game.locateDisks(color: .valid, gameboard: gameBoard))
        whiteScoreLabel.text = String(gameBoard.countDisk(gameBoard: gameBoard, color: "white"))
        blackScoreLabel.text = String(gameBoard.countDisk(gameBoard: gameBoard, color: "black"))
    }
    
    @IBAction func newGame(_ sender: Any) {
        resetBoard(gameboard: gameBoard)
        informationLabel.text = nil
        game.currentPlayer = allPlayers[0]   // - BLACK first
        game.setInitialBoard(gameBoard: gameBoard)
        game.scanActivePlayer(activePlayer: game.activePlayer!, gameboard: gameBoard)
        drawBoard()
        printBoard()
        
        print("BLACK @: ", game.locateDisks(color: .black, gameboard: gameBoard))
        print("WHITE @: ", game.locateDisks(color: .white, gameboard: gameBoard))
        print("VALID @: ", game.locateDisks(color: .valid, gameboard: gameBoard))
        whiteScoreLabel.text = String(gameBoard.countDisk(gameBoard: gameBoard, color: "white"))
        blackScoreLabel.text = String(gameBoard.countDisk(gameBoard: gameBoard, color: "black"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        game.currentPlayer = allPlayers[0]
        game.setInitialBoard(gameBoard: gameBoard)
        game.scanActivePlayer(activePlayer: game.activePlayer!, gameboard: gameBoard)
        drawBoard()
        printBoard()
        
        print("BLACK @: ", game.locateDisks(color: .black, gameboard: gameBoard))
        print("WHITE @: ", game.locateDisks(color: .white, gameboard: gameBoard))
        print("VALID @: ", game.locateDisks(color: .valid, gameboard: gameBoard))
        whiteScoreLabel.text = String(gameBoard.countDisk(gameBoard: gameBoard, color: "white"))
        blackScoreLabel.text = String(gameBoard.countDisk(gameBoard: gameBoard, color: "black"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



