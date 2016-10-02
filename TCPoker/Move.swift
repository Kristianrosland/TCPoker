//
//  Move.swift
//  TCPoker
//
//  Created by Kristian Rosland on 19.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit
public enum Move {
    case Small_blind
    case Big_blind
    case Fold
    case Check
    case Call
    case Bet
    case Raise
    case All_in
        
    func toString() -> String {
        return self == Small_blind ? "Small blind" : self == Big_blind ? "Big blind" : self == Fold ? "Fold":
            self == Check ? "Check" : self == Call ? "Call" : self == Bet ? "Bet" : self == Raise ? "Raise" : "All in"
    }
}

