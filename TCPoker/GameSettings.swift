//
//  GameSettings.swift
//  TCPoker
//
//  Created by Kristian Rosland on 20.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class GameSettings: NSObject {
    
    var startStack: Int!
    var bigBlind: Int!
    var smallBlind: Int!
    var maxNumberOfPlayers: Int!
    var levelDuration: Int!
    var playerClock: Int!
    var aiType: String!
    
    //Default settings
    override init() {
        self.startStack = 5000
        self.bigBlind = 100
        self.bigBlind = 50
        self.maxNumberOfPlayers = 6
        self.levelDuration = 5
        self.playerClock = 30
        self.aiType = "Advanced"
    }
    
    init(upiString: String) {
        super.init()
        let tokens = upiString.tokenize()
        self.maxNumberOfPlayers = Int(tokens[1])!
        self.startStack = Int(tokens[3])!
        self.smallBlind = Int(tokens[5])!
        self.bigBlind = Int(tokens[7])!
        self.levelDuration = Int(tokens[9])!
        self.playerClock = Int(tokens[11])!
        self.aiType = tokens[13]
    }
}
