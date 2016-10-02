//
//  LobbyTableView.swift
//  TCPoker
//
//  Created by Kristian Rosland on 18.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func cellClicked(table: LobbyTable)
}

class LobbyTableView: UIView, TableViewCellDelegate {
    var height:CGFloat!
    var width:CGFloat!
    
    var tables: [LobbyTable]!
    var tableViews: [UIView]!
    
    var newTableButton:UIButton!
    var delegate: LobbyDelegate!
    
    init(delegate: LobbyDelegate, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRectMake(0, 0, 0, 0))
        
        self.width = width
        self.height = height
        self.tableViews = [UIView]()
        self.delegate = delegate
        self.tables = delegate.getTables()
        
        setupAddNewTableButton()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func rePaint() {
        for v in tableViews {
            v.removeFromSuperview()
        }
        tableViews.removeAll()
        
        tables = delegate.getTables()
        guard tables.count > 0 else { return }
        
        for i in 0 ... tables.count-1 {
            let tableViewCell = TableViewCell(table: tables[i], delegate: self)
            tableViewCell.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(tableViewCell)
            self.tableViews.append(tableViewCell)
            
            //Dimms
            let heightConst = NSLayoutConstraint(item: tableViewCell, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height / 8)
            let widthConst = NSLayoutConstraint(item: tableViewCell, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
            tableViewCell.addConstraints([heightConst, widthConst])
            
            //Position
            var topConst:NSLayoutConstraint!
            if i == 0 {
                topConst = NSLayoutConstraint(item: tableViewCell, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
            } else {
                topConst = NSLayoutConstraint(item: tableViewCell, attribute: .Top, relatedBy: .Equal, toItem: self.subviews[i] , attribute: .Bottom, multiplier: 1, constant: 0)
            }
            let centerXConst = NSLayoutConstraint(item: tableViewCell, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
            self.addConstraints([topConst, centerXConst])
            
            //Color
            tableViewCell.backgroundColor = .whiteColor();
            tableViewCell.layer.borderWidth = 1
            tableViewCell.layer.borderColor = UIColor.blackColor().CGColor
            tableViewCell.alpha = 0.7
            
            //Label
            let nameLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            tableViewCell.addSubview(nameLabel)
            nameLabel.textAlignment = .Center
            nameLabel.text = "Table " + String(tables[i].tableID)
            
            let nameLabelCenterY = NSLayoutConstraint(item: nameLabel, attribute: .CenterY, relatedBy: .Equal, toItem: tableViewCell, attribute: .CenterY, multiplier: 1, constant: 0)
            let nameLabelCenterX = NSLayoutConstraint(item: nameLabel, attribute: .CenterX, relatedBy: .Equal, toItem: tableViewCell, attribute: .CenterX, multiplier: 1, constant: 0)
            tableViewCell.addConstraints([nameLabelCenterX, nameLabelCenterY])
        }
    }
    
    func setupAddNewTableButton() {
        self.newTableButton = UIButton(frame: CGRectMake(0, 0, width, height/8))
        self.newTableButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newTableButton)
        self.newTableButton.backgroundColor = UIColor(red: 35/255, green: 120/255, blue: 40/255, alpha: 1)
        self.newTableButton.alpha = 0.7
        self.newTableButton.setTitle("Make new table", forState: .Normal)
        self.newTableButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        self.newTableButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.newTableButton.titleLabel?.textAlignment = .Center
        self.newTableButton.titleLabel?.textColor = .blackColor()
        self.newTableButton.addTarget(self, action: #selector(self.makeNewTableButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        //Dimms
        let heightConst = NSLayoutConstraint(item: self.newTableButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height/8)
        let widthConst = NSLayoutConstraint(item: self.newTableButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
        self.newTableButton.addConstraints([heightConst, widthConst])
        
        //Pos
        let bottomConst = NSLayoutConstraint(item: self.newTableButton, attribute: .Bottom, relatedBy: .Equal, toItem: self , attribute: .Bottom, multiplier: 1, constant: 0)
        let centerXConst = NSLayoutConstraint(item: self.newTableButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        self.addConstraints([bottomConst, centerXConst])
    }
    
    func cellClicked(table: LobbyTable) {
        delegate.tableSelected(table)
    }
    
    func makeNewTableButtonClicked() {
        print("Make new table")
        
    }
}
