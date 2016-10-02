//
//  GameState.swift
//  TCPoker
//
//  Created by Kristian Rosland on 19.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class GameState: NSObject {
    
    static var playersSeated: Bool = false
    
    var stackSizes:[Int:Int]?
    var highestAmountPutOnTable: Int?
    var playerPutOnTable: [Int:Int]?
    var pot: Int?
    var bigBlind:Int?
    var smallBlind:Int?
    
    override init() {
        super.init()
        self.newHand()
    }
    
    func newHand() {
        self.highestAmountPutOnTable = 0
        self.playerPutOnTable = [Int:Int]()
        self.pot = 0
    }
    
    func setStacksizes(ss: [Int:Int]) {
        self.stackSizes = ss;
    }
    func newBettingRound() { self.highestAmountPutOnTable = 0 }
    func setBB(bb: Int) { self.bigBlind = bb }
    func setSB(sb: Int) { self.smallBlind = sb }
}
