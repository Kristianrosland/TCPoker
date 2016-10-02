//
//  LobbyScreenVC.swift
//  TCPoker
//
//  Created by Kristian Rosland on 18.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

protocol LobbyDelegate {
    //Callbacks from ServerCommunicator
    func tableCreated(tableID: Int)
    func tableDeleted(table_id: Int)
    func setSettingsForTable(table_id: Int, settings: GameSettings)
    func seatPlayer(p_id: Int, name: String, t_ID: Int)
    func unseatPlayer(p_id: Int, t_ID: Int)
    func startGame()
    
    //Callbacks from GUI
    func tableSelected(table: LobbyTable)
    func joinTableClicked(id: Int)
    func leaveTableClicked(id: Int)
    func getTables() -> [LobbyTable]
}

class LobbyScreenVC: UIViewController, LobbyDelegate {
    var leftView: LobbyTableView!
    var rightView: TablePreview!
    
    var serverCommunicator: ServerCommunicator!
    var tables: [LobbyTable]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Setup the view containers
        self.setupTopAndBottomView()
        self.handshake()
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    func handshake(){
        serverCommunicator.assignLobbyDelegate(self)
        serverCommunicator.write("lobby " + serverCommunicator.name + "\n")
        serverCommunicator.read()
    }
    
    func tableSelected(table: LobbyTable) {
        rightView.setTable(table)
        rightView.rePaint()
        self.view.layoutIfNeeded()
    }
    
    func joinTableClicked(id: Int) {
        serverCommunicator.write("takeSeat " + String(id) + "\n")
    }
    func leaveTableClicked(id: Int) {
        serverCommunicator.write("leaveSeat " + String(id) + "\n")
    }
    
    func setupTopAndBottomView() {
        let leftWidth:CGFloat = 0.35 * self.view.frame.width
        let rightWidth:CGFloat = self.view.frame.width - leftWidth
        
        tables = [LobbyTable]()

        leftView = LobbyTableView(delegate: self, width: leftWidth, height: self.view.frame.height)
        rightView = TablePreview(delegate: self, width: rightWidth, height: self.view.frame.height)
        
        for view in [leftView, rightView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            
            //Dimms
            let heightConst = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.view.frame.height)
            let widthConst = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: view == leftView ? leftWidth : rightWidth)
            view.addConstraints([heightConst, widthConst])
        
            //Position
            let centerY = NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
            let xAttribute: NSLayoutAttribute = (view == leftView ? .Left : .Right)
            let xConst = NSLayoutConstraint(item: view, attribute: xAttribute, relatedBy: .Equal, toItem: self.view, attribute: xAttribute, multiplier: 1, constant: 0)
            
            self.view.addConstraints([centerY, xConst])
        }
        
        leftView.backgroundColor = .darkGrayColor()
        rightView.backgroundColor = UIColor(red: 96/255, green: 33/255, blue: 33/255, alpha: 1.0)
        leftView.rePaint()
        rightView.rePaint()
    }
    
    func prepareServerCommunicator(communicator: ServerCommunicator) {
        self.serverCommunicator = communicator;
    }
    
    func tableCreated(tableID: Int) {
        tables.append(LobbyTable(tableID: tableID))
        leftView.rePaint()
        rightView.rePaint()
        self.view.layoutIfNeeded()
    }
    
    func tableDeleted(table_id: Int) {
        var index = -1
        for i in 0 ..< tables.count {
            if (tables[i].tableID == table_id) {
                index = i
            }
        }
        guard (index != -1) else { return }
        
        
        tables.removeAtIndex(index)
        leftView.rePaint()
        rightView.rePaint()
        self.view.layoutIfNeeded()
    }
    
    func seatPlayer(p_id: Int, name: String, t_ID: Int) {
        if let table = getTable(t_ID) { table.addPlayer(p_id, name: name) }
        leftView.rePaint()
        rightView.rePaint()
        self.view.layoutIfNeeded()
    }
    
    func unseatPlayer(p_id: Int, t_ID: Int) {
        if let table = getTable(t_ID) { table.removePlayer(p_id) }
        leftView.rePaint()
        rightView.rePaint()
        self.view.layoutIfNeeded()
    }
    
    func setSettingsForTable(table_id: Int, settings: GameSettings) {
        
    }
    
    func startGame() {
        self.performSegueWithIdentifier("lobbyToGameScreen", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "lobbyToGameScreen") {
            let destinationVC = segue.destinationViewController as! GameScreenVC
            destinationVC.serverCommunicator = self.serverCommunicator
        }
    }
    
    func getTables() -> [LobbyTable] {
        return self.tables
    }
    
    private func getTable(t_id: Int) -> LobbyTable? {
        for table in tables {
            if table.tableID == t_id {
                return table
            }
        }
        return nil
    }
    
}