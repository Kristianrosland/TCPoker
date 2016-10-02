//
//  GameScreenVC.swift
//  112ShadesOfPoker
//
//  Created by Kristian Rosland on 15.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

protocol ActionDelegate {
    func fold()
    func check()
    func call()
    func bet(size:Int)
    func raise(size:Int)
    func cancel()
    func showRaiseMenu()
}

protocol GamePlayDelegate {
    func setPositions(positions: [Int:Int])
    func setStacksizes(stacksizes: [Int:Int])
    func getDecision(timeToThink: Int)
    func setDecisionForClient(id: Int, decision: Decision)
    func setBigBlind(bigBlind: Int)
    func setSmallBlind(smallBlind: Int)
    func setHandForClient(id: Int, card1: Card, card2: Card)
    func newHand()
    func setID(id: Int)
    func setFlop(card1: Card, card2: Card, card3: Card)
    func setTurn(card: Card)
    func setRiver(card: Card)
    func bustPlayer(id: Int, rank: Int)
    func preShowdownWinner(id: Int)
    func setAmountOfPlayers(amount: Int)
    func setNames(names: [Int: String])
}


// --- GAMESCREEN VIEW CONTROLLER --- //
class GameScreenVC: UIViewController, ActionDelegate, GamePlayDelegate{
    var background: UIImageView!
    var seatToPlayerlayout:[Int:PlayerLayout] = [Int:PlayerLayout]()
    var idToPlayerLayout: [Int: PlayerLayout]! //[ClientID, playerLayout]
    var board:Board!
    var actionPanel:ActionPanel!
    
    //Raise view
    var raiseView: RaiseView!
    var raiseViewTopConstraint: NSLayoutConstraint!
    var blockView: UIView!
    
    //Communication
    var serverCommunicator:ServerCommunicator!
    var gameState: GameState = GameState()
    
    //Gameplay
    var id: Int?
    var amountOfPlayers: Int!
    var playerNames: [Int:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        
        serverCommunicator.assignGamePlayDelegate(self)
        serverCommunicator.write("upi 1.0\n")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: ActionDelegate methods
    func fold() {
        serverCommunicator.write("decision fold\n")
        actionPanel.hide()
    }
    func check() {
        serverCommunicator.write("decision check\n")
        actionPanel.hide()
    }
    func call() {
        serverCommunicator.write("decision call\n")
        actionPanel.hide()
    }
    func bet(size:Int) {
        serverCommunicator.write("decision bet\(size) \n")
        actionPanel.hide()
        self.hideRaiseView()
    }
    func raise(size:Int) {
        serverCommunicator.write("decision raise\(size) \n")
        actionPanel.hide()
        self.hideRaiseView()
    }
    func cancel() {
        self.hideRaiseView()
    }
    func showRaiseMenu() {
        self.showRaiseView()
    }
    
    
    //MARK: GamePlayDelegates (GUI-client)
    func setPositions(positions: [Int:Int]) { //[tablePos, ClientID]
        if (!GameState.playersSeated) {
            let sortedPositions = Array(positions.keys).sort(<)
            var myIndex:Int?
            
            //Find what position I am in
            for i in 0 ..< sortedPositions.count {
                if (positions[sortedPositions[i]] == self.id!) {
                    myIndex = i
                }
            }
            
            guard myIndex != nil else { fatalError("Client was not sent his own position") }
            
            //Start inserting players, me first (idToPlayerLayout = [ClientID, seatNr])
            for i in 0 ..< sortedPositions.count {
                let pos = (myIndex! + i) % sortedPositions.count
                let id = positions[pos]!
                self.idToPlayerLayout[id] = self.seatToPlayerlayout[pos]
                self.idToPlayerLayout[id]!.setDealer(pos == positions.keys.count - 1)
                self.idToPlayerLayout[id]!.nameLabel.text = playerNames![id]
            }
            
            GameState.playersSeated = true
        } else {
            //Set positions
            for pos in positions.keys {
                idToPlayerLayout[positions[pos]!]?.setDealer(pos == positions.keys.count - 1)
            }
        }
    }
    
    func setStacksizes(stacksizes: [Int:Int]) {
        if (GameState.playersSeated) {
            for i in stacksizes.keys {
                let stack = stacksizes[i]!
                idToPlayerLayout[i]!.setStacksize(stack)
            }
        }
    }
    func getDecision(timeToThink: Int) {
        actionPanel.show(gameState)
    }
    func setDecisionForClient(id: Int, decision: Decision) {
        if let player = idToPlayerLayout[id] {
            player.makeDecision(self.gameState, decision: decision)
        }
    }
    func setBigBlind(bigBlind: Int) {
        gameState.setBB(bigBlind)
    }
    func setSmallBlind(smallBlind: Int) {
        gameState.setSB(smallBlind)
    }
    func playerBust() {
        
    }
    
    func newHand() {
        for player in idToPlayerLayout.values {
            player.newHand()
        }
        
        gameState.newHand()
        board.reset()
    }
    
    func setID(id: Int) {
        self.id = id
    }
    
    func setHandForClient(id: Int, card1: Card, card2: Card) {
        idToPlayerLayout[id]!.setHand(card1, card2: card2)
    }
    
    func setFlop(card1: Card, card2: Card, card3: Card) {
        board.setFlop(card1, card2: card2, card3: card3)
        gameState.newBettingRound()
    }
    
    func setTurn(card: Card) {
        board.setTurn(card)
        gameState.newBettingRound()
    }
    
    func setRiver(card: Card) {
        board.setRiver(card)
        gameState.newBettingRound()
    }
    
    func bustPlayer(id: Int, rank: Int) {
        
    }
    
    func preShowdownWinner(id: Int) {
        board.setWinnerText("\(playerNames![id]) won the pot")
    }
    
    func setAmountOfPlayers(amount: Int) {
        self.amountOfPlayers = amount
    }
    
    func setNames(names: [Int: String]) {
        self.playerNames = names
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Setup methods
    func initialSetup() {
        addTableBackground();
        for i in 0...5 { insertPlayer(i) }
        insertActionPanel();
        insertBoard();
        insertRaiseView();
        GameState.playersSeated = false
        idToPlayerLayout = [Int:PlayerLayout]()
    }
    
    func insertRaiseView() {
        self.blockView = UIView(frame: CGRectMake(0,0, self.view.frame.width, self.view.frame.height))
        self.blockView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(blockView)
        self.blockView.backgroundColor = .blackColor()
        self.blockView.alpha = 0.0
        
        self.raiseView = RaiseView(delegate: self, width: self.view.frame.width * 0.65, height: self.view.frame.height * 0.35)
        self.raiseView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(raiseView)
        
        let xConstraint = NSLayoutConstraint(item: self.raiseView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        self.raiseViewTopConstraint = NSLayoutConstraint(item: self.raiseView, attribute: .Top, relatedBy: .LessThanOrEqual, toItem: self.view, attribute: .Top, multiplier: 1, constant: 1000)
        self.view.addConstraints([xConstraint, raiseViewTopConstraint])
    }
    
    func insertBoard() {
        self.board = Board(width: 255, height: 100)
        self.view.addSubview(board)
        self.board.translatesAutoresizingMaskIntoConstraints = false
        
        //Position
        let boardCenterX = NSLayoutConstraint(item: board, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let boardCenterY = NSLayoutConstraint(item: board, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -15)
        self.view.addConstraints([boardCenterX, boardCenterY])
    }
    
    func insertActionPanel() {
        actionPanel = ActionPanel(delegate: self, width: 300, height: 75)
        actionPanel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(actionPanel)
        
        let bottomConstraint = NSLayoutConstraint(item: actionPanel, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 2)
        let leftConstraint = NSLayoutConstraint(item: actionPanel, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: -30)
        self.view.addConstraints([bottomConstraint, leftConstraint])
    }
    
    
    // 0 is bottom, moving to the left. [0 -> 5]
    func insertPlayer(position: Int) {
        var playerLayout: PlayerLayout!
        var xAttribute: NSLayoutAttribute!
        var yAttribute: NSLayoutAttribute!
        var xConstant:CGFloat!
        var yConstant:CGFloat!
        
        switch(position) {
        case 0:
            playerLayout = PlayerLayout(tableSide: .Bottom)
            xAttribute = .CenterX
            yAttribute = .Bottom
            xConstant = -150
            yConstant = 0
            break;
        case 1:
            playerLayout = PlayerLayout(tableSide: .Left)
            xAttribute = .Left
            yAttribute = .Top
            xConstant = 0
            yConstant = playerLayout.getHeight() + 18
            break;
        case 2:
            playerLayout = PlayerLayout(tableSide: .Left)
            xAttribute = .Left
            yAttribute = .Top
            xConstant = 0;
            yConstant = 18;
            break;
        case 3:
            playerLayout = PlayerLayout(tableSide: .Top)
            xAttribute = .CenterX
            yAttribute = .Top
            xConstant = 0
            yConstant = 0
            break;
        case 4:
            playerLayout = PlayerLayout(tableSide: .Right)
            xAttribute = .Right
            yAttribute = .Top
            xConstant = 0
            yConstant = 18
            break;
        case 5:
            playerLayout = PlayerLayout(tableSide: .Right)
            xAttribute = .Right
            yAttribute = .Top
            xConstant = 0
            yConstant = playerLayout.getHeight() + 18
            break;
        default: break
        }
        
        playerLayout.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerLayout)
        
        let centerY = NSLayoutConstraint(item: playerLayout, attribute: xAttribute, relatedBy: .Equal, toItem: self.view, attribute: xAttribute, multiplier: 1, constant: xConstant)
        let centerX = NSLayoutConstraint(item: playerLayout, attribute: yAttribute, relatedBy: .Equal, toItem: self.view, attribute: yAttribute, multiplier: 1, constant: yConstant)
        self.view.addConstraints([centerY, centerX])
        
        seatToPlayerlayout[position] = playerLayout
    }
    
    func addTableBackground() {
        background = UIImageView.init(image: UIImage(named: "table"))
        background.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(background)
        
        //Constraints
        let rightConst = NSLayoutConstraint(item: background, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0)
        let leftConst = NSLayoutConstraint(item: background, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0)
        let topConst = NSLayoutConstraint(item: background, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0)
        let bottomConst = NSLayoutConstraint(item: background, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([rightConst, leftConst, topConst, bottomConst])
    }
    
    func showRaiseView() {
        var putOnTable = self.gameState.playerPutOnTable![self.id!]
        var buttonText = "Raise"
        if (putOnTable == nil) { putOnTable = 0; }
        if (gameState.highestAmountPutOnTable == 0) { buttonText = "Bet"}
        self.raiseView.show(50, maxSliderValue: 5000, playerPutOnTable: putOnTable!, buttonText: buttonText)
        self.raiseViewTopConstraint.constant = self.view.frame.height*0.50
        UIView.animateWithDuration(0.2, animations: {
            self.view.layoutIfNeeded()
        })
        self.blockView.alpha = 0.2
    }
    
    func hideRaiseView() {
        self.raiseViewTopConstraint.constant = 1000
        UIView.animateWithDuration(0.2, animations: {
            self.view.layoutIfNeeded()
            }) { (true) in
                self.raiseView.hide()
        }
        self.blockView.alpha = 0.0
    }

}
