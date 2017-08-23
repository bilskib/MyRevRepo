//
//  Board.swift
//  ReversiPA1
//
//  Created by Bartosz on 12.08.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import Foundation

enum BoardTypeCell: Int {
    case empty = 0
    case black = 1
    case white = 2
    case valid = 3
    case blackLast = 11
    case whiteLast = 22
}

class Board {

    let rows: Int, columns: Int
    var grid: [BoardTypeCell]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns

        grid = Array(repeating: .empty, count: rows * columns)
    }
    
    func indexIsValid (row: Int, column: Int) -> Bool {
        return (row >= 0 && row < rows) && (column >= 0 && column < columns)
    }
    
    subscript(row: Int, column: Int) -> BoardTypeCell {
        
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    
    func countDisk (gameBoard: Board, color: String) -> Int {
        var counter: Int = 0
        
        if (color.lowercased() == "white") {
            for i in 0..<8 {
                for j in 0..<8 {
                    if gameBoard[i,j] == .white || gameBoard[i,j] == .whiteLast {
                        counter += 1
                    }
                }
            }
        } else if (color.lowercased() == "black") {
            for i in 0..<8 {
                for j in 0..<8 {
                    if gameBoard[i,j] == .black || gameBoard[i,j] == .blackLast {
                        counter += 1
                    }
                }
            }
        }
        return counter
    }
}
