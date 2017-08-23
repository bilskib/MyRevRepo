//
//  Move.swift
//  ReversiPA1
//
//  Created by Bartosz on 12.08.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {

    // GKGameModelUpdate protocol requirements
        // Store a move value
    var value: Int {
        get { return score }
        set { score = newValue }
    }
    
    var score: Int = 0
    var x: Int, y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y 
    }
    
    // Properties and methods
    typealias directionType = (x: Int, y: Int)
    
    let directions : [String: directionType] = [
        "north"     : (-1, 0),
        "south"     : (1, 0),
        "east"      : (0, 1),
        "west"      : (0, -1),
        "northeast" : (-1, 1),
        "northwest" : (1, -1),
        "southeast" : (1, 1),
        "southwest" : (-1, -1),
    ]
    
    
    
}
