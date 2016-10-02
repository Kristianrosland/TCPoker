//
//  Decision.swift
//  TCPoker
//
//  Created by Kristian Rosland on 19.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

public class Decision {
    let move: Move!
    let size: Int!
    
    init(move: Move, size: Int) {
        self.move = move
        self.size = size
    }
    
    init(move: Move) {
        self.move = move
        
        guard (move != Move.Bet && move != Move.Raise) else { fatalError("Move " + move.toString() + " needs a size") }
        self.size = -1
    }
}
