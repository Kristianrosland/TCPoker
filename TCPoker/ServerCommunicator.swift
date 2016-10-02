//
//  ServerCommunicator.swift
//  112ShadesOfPoker
//
//  Created by Kristian Rosland on 18.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class ServerCommunicator: NSObject{
    
    //Socket stuff
    var socket:TCPClient!
    let port: Int = 39100
    
    //Personal info
    var name: String!
    var id: Int?
    
    //Total info
    var names: [Int:String]!
    
    //Delegates
    var lobbyDelegate: LobbyDelegate?
    var gamePlayDelegate:GamePlayDelegate?
    
    init?(name: String, ipAddress: String) {
        super.init()
        self.name = name
        self.names = [Int:String]()
        
        let testIP = "10.0.1.36"
        socket = TCPClient(addr: testIP, port: 39100)
        let closure = socket.connect(timeout: 10)
        if (!closure.0) {
            print("Error creating socket: " + closure.1)
            return nil
        }
    }
    
    func write(msg: String) {
        print("Writing..")
        socket.send(str: msg)
    }
    
    func read() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            var attempts = 0
            while(true) {
                let data = self.socket.read(1024*10)
                if let d = data {
                    if let str = String.init(bytes: d, encoding: NSUTF8StringEncoding) {
                        let inputs = str.componentsSeparatedByString("\n")
                        for input in inputs {
                            if (!input.isEmpty) {
                                self.parseString(input)
                            }
                        }
                    }
                } else {
                    print("Received nothing form server")
                    attempts += 1
                    if (attempts >= 10) {
                        return
                    }
                    
                }
            }
        }
    }
    
    func parseString(str: String) {
        dispatch_async(dispatch_get_main_queue()) { //Perfrom on main thread
            let tokens = str.tokenize()
            
            print("Command " + str)
            switch (tokens[0]) {
            case "lobbyok":
                break;
            case "yourId":
                self.id = Int(tokens[1])
                break;
            case "playerNames":
                if (tokens.count <= 2) { return }
                for i in 1 ..< tokens.count - 1 {
                    if (i % 2 != 0) {
                        self.names[Int(tokens[i])!] = tokens[i+1]
                        if let _ = self.gamePlayDelegate {
                            self.gamePlayDelegate?.setNames(self.names)
                        }
                    }
                }
                break;
            case "lobbySent":
                break;
            case "playerJoinedLobby":
                self.names[Int(tokens[1])!] = tokens[2]
                break;
            case "playerLeftLobby":
                //Not yet implemented
                break;
            case "tableCreated":
                if let del = self.lobbyDelegate {
                    del.tableCreated(Int(tokens[1])!)
                }
                break;
            case "tableSettings":
                if let del = self.lobbyDelegate {
                    let t_id = Int(tokens[1])!
                    let settings = GameSettings(upiString: tokens[2])
                    del.setSettingsForTable(t_id, settings: settings)
                }
                break;
            case "playerJoinedTable":
                if let del = self.lobbyDelegate {
                    let p_id = Int(tokens[1])!
                    let name = self.names[p_id]!
                    let t_id = Int(tokens[2])!
                    del.seatPlayer(p_id, name: name, t_ID: t_id)
                }
                break;
            case "playerLeftTable":
                if let del = self.lobbyDelegate {
                    let p_id = Int(tokens[1])!
                    let t_id = Int(tokens[2])!
                    del.unseatPlayer(p_id, t_ID: t_id)
                }
                break
            case "tableDeleted":
                if let del = self.lobbyDelegate {
                    let t_id = Int(tokens[1])!
                    del.tableDeleted(t_id)
                }
                break;
            case "startGame":
                if let del = self.lobbyDelegate {
                    del.startGame()
                }
                break;
            default:
                self.parseGamePlayString(str)
                break;
            }
        }
    }
    
    private func parseGamePlayString(string: String) {
        guard gamePlayDelegate != nil else { print("Error, gamePlayDelegate was not present when receiving command " + string); return }

        
        let tokens = string.tokenize()
        
        switch (tokens[0]) {
            case "getName":
                write("playerName " + self.name + "\n")
                break;
            case "newHand":
                gamePlayDelegate!.newHand()
                break;
            case "clientId":
                gamePlayDelegate!.setID(Int(tokens[1])!)
                break;
            case "playerPositions":
                var positionsDict = [Int: Int]()
                for i in 1 ..< tokens.count - 1{
                    guard i % 2 != 0 else { continue }
                    let id = Int(tokens[i])!
                    let pos = Int(tokens[i+1])!
                    print("(" + String(id) + ") is position " + String(pos))
                    positionsDict[pos] = id //[Position, ClientID]
                }
                gamePlayDelegate!.setPositions(positionsDict)
                break
            case "stackSizes":
                var stacksizesDict = [Int: Int]()
                for i in 1 ..< tokens.count - 1 {
                    guard i % 2 != 0 else { continue }
                    let id = Int(tokens[i])!
                    let stack = Int(tokens[i+1])!
                    print(String(id) + " has " + String(stack) + " + chips")
                    stacksizesDict[id] = stack
                }
                gamePlayDelegate!.setStacksizes(stacksizesDict)
                break;
            case "smallBlind":
                gamePlayDelegate!.setSmallBlind(Int(tokens[1])!)
                break
            case "bigBlind":
                gamePlayDelegate!.setBigBlind(Int(tokens[1])!)
                break
            case "setHand":
                let id = Int(tokens[1])!
                let card1 = UpiUtils.parseCard(tokens[2])
                let card2 = UpiUtils.parseCard(tokens[3])
                gamePlayDelegate!.setHandForClient(id, card1: card1, card2: card2)
                break
            case "setFlop":
                let card1 = UpiUtils.parseCard(tokens[1])
                let card2 = UpiUtils.parseCard(tokens[2])
                let card3 = UpiUtils.parseCard(tokens[3])
                gamePlayDelegate!.setFlop(card1, card2: card2, card3: card3)
                break
            case "setTurn":
                gamePlayDelegate!.setTurn(UpiUtils.parseCard(tokens[1]))
                break
            case "setRiver":
                gamePlayDelegate!.setRiver(UpiUtils.parseCard(tokens[1]))
                break
            case "playerBust":
                let id = Int(tokens[1])!
                let rank = Int(tokens[2])!
                gamePlayDelegate!.bustPlayer(id, rank: rank)
                break
            case "showdown":
                //TODO: Implement
                break
            case "getDecision":
                gamePlayDelegate!.getDecision(Int(tokens[1])!)
                break
            case "playerMadeDecision":
                let clientID = Int(tokens[1])!
                let decision = UpiUtils.decisionFromUPIString(tokens[3])
                gamePlayDelegate!.setDecisionForClient(clientID, decision: decision!)
                break;
            case "preShowdownWinner":
                let id = Int(tokens[1])!
                gamePlayDelegate!.preShowdownWinner(id)
                break
            case "amountOfPlayers":
                gamePlayDelegate!.setAmountOfPlayers(Int(tokens[1])!)
                break;
            
            case "logPrint":
                //TODO: Maybe implement
                break
            case "statistics":
                //TODO: Maybe implement
                break
        default:
                print("Command not recognized, " + string)
        }
        /*
         case "errorMessage":

         case "playerNames":
         case "playerPositions":
         case "stackSizes":
         case "smallBlind":
         case "bigBlind":
         case "setHand":
         case "setFlop":
         case "setTurn":
         case "setRiver":
         case "playerBust":
         case "showdown":
         case "getDecision":
         case "playerMadeDecision":
         case "logPrint":
         case "statistics":
         case "preShowdownWinner":
         */
    }
    
    func assignLobbyDelegate(lobbyDelegate: LobbyDelegate) {
        self.lobbyDelegate = lobbyDelegate
    }
    
    func assignGamePlayDelegate(gamePlayDelegate: GamePlayDelegate) {
        self.gamePlayDelegate = gamePlayDelegate;
    }
}

