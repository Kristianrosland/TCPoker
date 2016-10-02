//
//  LobbyTable.swift
//  TCPoker
//
//  Created by Kristian Rosland on 18.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class LobbyTable: NSObject {

    var tableID: Int!
    var playerIDs = [Int]()
    var host:Int?
    var names:[Int:String]!
    var settings:GameSettings?
    
    init(tableID: Int) {
        self.tableID = tableID
        self.names = [Int:String]()
    }
    
    func addPlayer(id: Int, name: String) {
        if let _ = host {
            playerIDs.append(id)
        } else {
            self.host = id
            playerIDs.append(id)
        }
        
        self.names[id] = name
    }
    
    func removePlayer(id: Int) {
        let index:Int? = playerIDs.indexOf(id)
        if let actualIndex = index {
            playerIDs.removeAtIndex(actualIndex)
            print("Removed player " + String(id) + " from table " + String(tableID))
        }
    }
    
    func getSeatedPlayers() -> [Int] {
        var copy = [Int]()
        for i in playerIDs {
            copy.append(i)
        }
        return copy;
    }
    
    func getNames() -> [String] {
        var namesArray = [String]()
        for i in playerIDs {
            guard let name = self.names[i] else {
                namesArray.append("<name_not_found>");
                continue;
            }
            namesArray.append(name)
        }
        return namesArray
    }
    
    func setGameSettings(settings: GameSettings) {
        self.settings = settings
    }
}
