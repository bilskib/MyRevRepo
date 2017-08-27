//
//  Game.swift
//  ReversiPA1
//
//  Created by Bartosz on 12.08.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import UIKit
import GameplayKit

class GameModel: NSObject, GKGameModel {
    
    // GKGameModel protocol requirements
    var players: [GKGameModelPlayer]? { return allPlayers }
    var activePlayer: GKGameModelPlayer? { return currentPlayer }   // black
    
    //BART
    var gameBoard = Board(rows: 8, columns: 8)
    var move = Move(x:3, y:5)
    var currentPlayer: Player = allPlayers[0]
    
    func setGameModel(_ gameModel: GKGameModel) {
        // TODO
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        //return true // TODO
        return [move]
    }
    
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        // TODO 
    }
    
    // NSCopying protocol requirements - TODO
    func copy(with zone: NSZone? = nil) -> Any {
        return true
    }
    
    
    
    func addDiskToBoard(_ type: BoardTypeCell, x: Int, y: Int) {
        self.gameBoard[x, y] = type
    }

    
    func addXY (x1: Int, y1: Int, xy:(Int, Int)) -> (Int, Int) {
        let addedXY = (x1 + xy.0, y1 + xy.1)
        return (addedXY)
    }
    
    // Find disks of given color
    func locateDisks (color: BoardTypeCell, gameboard: Board) -> ([(Int, Int)]) {
        var tab = [(Int,Int)]()
        tab.removeAll()
        for i in 0...7 {
            for j in 0...7 {
                if color == .black {
                    if gameboard[i,j] == .black || gameboard[i,j] == .blackLast {
                        tab.append((i,j))
                    }
                } else if color == .white {
                    if gameboard[i,j] == .white || gameboard[i,j] == .whiteLast {
                        tab.append((i,j))
                    }
                } else if color == .valid {
                    if gameboard[i,j] == .valid {
                        tab.append((i,j))
                }
            }
            }
        }
        return tab
    }
    
    func flipDisk(activePlayer: GKGameModelPlayer?, gameBoard: Board, x: Int, y: Int) {
        
        let activePlayersCellType: BoardTypeCell = (currentPlayer == allPlayers[0]) ? .black : .white
        let opponentPlayersCellType: BoardTypeCell = (activePlayersCellType == .black) ? .white : .black
        var newCell = (x,y)
        var diskToFlip: [(Int,Int)] = Array()
        var diskToFlipCounter: Int = 0
        
        for direction in move.directions {
            newCell = (x,y)
            newCell.0 += direction.value.x
            newCell.1 += direction.value.y
            
            if newCell.0 < 0 || newCell.0 > 7 || newCell.1 < 0 || newCell.1 > 7 {
                continue
            } else {
                if gameBoard[newCell.0,newCell.1] == activePlayersCellType {
                    continue
                } else if gameBoard[newCell.0,newCell.1] == .empty {
                    continue
                } else if gameBoard[newCell.0,newCell.1] == opponentPlayersCellType {
                    diskToFlipCounter = 0
                    while (newCell.0 >= 0 && newCell.1 >= 0 && newCell.0 <= 7 && newCell.1 <= 7) && gameBoard[newCell.0,newCell.1] == opponentPlayersCellType {
                        diskToFlip.append(newCell)
                        diskToFlipCounter += 1
                        newCell.0 += direction.value.x
                        newCell.1 += direction.value.y
                    }
                        if newCell.0 < 0 || newCell.0 > 7 || newCell.1 < 0 || newCell.1 > 7 {
                            diskToFlip.removeLast(diskToFlipCounter)
                            continue
                        } else {
                            
                            switch gameBoard[newCell.0,newCell.1] {
                            case opponentPlayersCellType:
                                diskToFlip.removeLast(diskToFlipCounter)
                                continue
                            case activePlayersCellType:
                                // TODO: make flipped disk of active player color
                                for i in 0...diskToFlip.count-1 {
                                    gameBoard[diskToFlip[i].0,diskToFlip[i].1] = activePlayersCellType
                                }
                                diskToFlip.removeLast(diskToFlipCounter)
                                continue
                            case .empty:
                                diskToFlip.removeLast(diskToFlipCounter)
                                continue
                            default:
                                print("flipDisk(): default")
                                break
                            }
                    }
                }
            }
        }
    }
   
    func scanNeighbourCell(activePlayer: GKGameModelPlayer?, gameBoard: Board, x: Int, y: Int) {
        let activePlayersCellType: BoardTypeCell = (currentPlayer == allPlayers[0]) ? .black : .white
        let opponentPlayersCellType: BoardTypeCell = (activePlayersCellType == .black) ? .white : .black
        let activePlayersLastCellType: BoardTypeCell = (currentPlayer == allPlayers[0]) ? .blackLast : .whiteLast
        let opponentPlayersLastCellType: BoardTypeCell = (activePlayersLastCellType == .blackLast) ? .whiteLast : .blackLast
        
        let baseCell = (x,y)
        var newCell = (x,y)
        
        for direction in move.directions {
            newCell = (x,y)
            newCell.0 += direction.value.x
            newCell.1 += direction.value.y
            print("base cell:", baseCell, "modified with:", direction.key, direction.value, "is: ", newCell)
            
            if (newCell.0 >= 0 && newCell.1 >= 0 && newCell.0 <= 7 && newCell.1 <= 7) {
                if gameBoard[newCell.0,newCell.1] == activePlayersCellType {
                    continue
                } else if gameBoard[newCell.0,newCell.1] == activePlayersLastCellType {
                    continue
                }else if gameBoard[newCell.0,newCell.1] == .empty {
                    continue
                } else if gameBoard[newCell.0,newCell.1] == opponentPlayersCellType {
                    while (newCell.0 >= 0 && newCell.1 >= 0 && newCell.0 <= 7 && newCell.1 <= 7) && (gameBoard[newCell.0,newCell.1] == opponentPlayersCellType || gameBoard[newCell.0,newCell.1] == opponentPlayersLastCellType) {
                            newCell.0 += direction.value.x
                            newCell.1 += direction.value.y
                    }
                    if (newCell.0 >= 0 && newCell.1 >= 0 && newCell.0 <= 7 && newCell.1 <= 7) {
                        print("scan for diections:", direction.key)
                        switch gameBoard[newCell.0,newCell.1] {
                        case opponentPlayersCellType:
                            continue
                        case opponentPlayersLastCellType:
                            continue
                        case activePlayersCellType:
                            continue
                        case activePlayersLastCellType:
                            continue
                        case .empty:
                            gameBoard[newCell.0,newCell.1] = .valid
                            print("now valid will be:", [newCell.0,newCell.1])
                            continue
                        case .valid:
                            continue
                        default:
                            print("SCAN: defualt")
                            break
                        }
                    } else {
                        continue
                    }
                } else if gameBoard[newCell.0,newCell.1] == opponentPlayersLastCellType {
                    while (newCell.0 >= 0 && newCell.1 >= 0 && newCell.0 <= 7 && newCell.1 <= 7) && (gameBoard[newCell.0,newCell.1] == opponentPlayersLastCellType || gameBoard[newCell.0,newCell.1] == opponentPlayersCellType) {
                        newCell.0 += direction.value.x
                        newCell.1 += direction.value.y
                    }
                    if (newCell.0 >= 0 && newCell.1 >= 0 && newCell.0 <= 7 && newCell.1 <= 7) {
                        print("scan for diections:", direction.key)
                        switch gameBoard[newCell.0,newCell.1] {
                        case opponentPlayersCellType:
                            continue
                        case opponentPlayersLastCellType:
                            continue
                        case activePlayersCellType:
                            continue
                        case activePlayersLastCellType:
                            continue
                        case .empty:
                            gameBoard[newCell.0,newCell.1] = .valid
                            print("now valid will be:", [newCell.0,newCell.1])
                            continue
                        case .valid:
                            continue
                        default:
                            print("SCAN: defualt")
                            break
                        }
                    } else {
                        continue
                    }                }
            } else {
                print("rejected due to wrong index: ", newCell.0, newCell.1)
                continue
            }
        }
    }
    
    // Perform a board scan for given player (i.e. only black disks)
    func scanActivePlayer (activePlayer: GKGameModelPlayer, gameboard: Board) {
        var tab = [(Int,Int)]()
        
        if currentPlayer == allPlayers[0] {
            tab = locateDisks(color: .black, gameboard: gameboard)
            print("number of scans for black:", tab.count, " -> ", tab)
            if tab.isEmpty {
                print("tab of black is empty")
            } else {
                for i in 0...tab.count-1 {
                    scanNeighbourCell(activePlayer: activePlayer, gameBoard: gameboard, x: tab[i].0, y: tab[i].1)
                }
                tab.removeAll()
            }
        } else if currentPlayer == allPlayers[1] {
            tab = locateDisks(color: .white, gameboard: gameboard)
            print("number of scans for white:", tab.count, " -> ", tab)
            if tab.isEmpty {
                print("tab of white is empty")
            } else {
                for i in 0...tab.count-1 {
                    scanNeighbourCell(activePlayer: activePlayer, gameBoard: gameboard, x: tab[i].0, y: tab[i].1)
                }
                tab.removeAll()
            }
        }
    }
    
    func switchPlayer() {
        currentPlayer = (currentPlayer == allPlayers[0]) ? allPlayers[1] : allPlayers[0]
    }
    
    func hasValidMove (activePlayer: GKGameModelPlayer, gameboard: Board) -> Bool {
        var blackHasMoves: Bool = false
        var whiteHasMoves: Bool = false
        var result: Bool = true
        
        if currentPlayer == allPlayers[0] {
            for i in 0...7 {
                for j in 0...7 {
                    if gameboard[i,j] == .valid {
                        blackHasMoves = true
                        print("black has moves", blackHasMoves)
                        break
                    }
                }
            }
        } else if currentPlayer == allPlayers[1] {
            for i in 0...7 {
                for j in 0...7 {
                    if gameboard[i,j] == .valid {
                        whiteHasMoves = true
                        print("white has moves", whiteHasMoves)
                        break
                    }
                }
            }
        }
        result = (currentPlayer == allPlayers[0]) ? blackHasMoves : whiteHasMoves
        return result
    }
}
let allPlayers: [Player] = [Player(disk: .black), Player(disk: .white)]
