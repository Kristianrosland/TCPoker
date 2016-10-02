//
//  TablePreview.swift
//  TCPoker
//
//  Created by Kristian Rosland on 19.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class TablePreview: UIView {

    var height:CGFloat!
    var width:CGFloat!
    
    var tableImgView: UIImageView!
    var joinLeaveButton: UIButton!
    
    var delegate: LobbyDelegate!
    var lobbyTable: LobbyTable?
    var nameLabelDict: [Int:UILabel]!
    
    init(delegate: LobbyDelegate, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect.zero)
        self.delegate = delegate
        
        //Dimms
        let heightConst = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        let widthConst = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
        self.addConstraints([heightConst, widthConst])
        
        //Table image
        tableImgView = UIImageView(frame: CGRectMake(width/5 / 2, height/6, width*0.8, height*(2/3)))
        tableImgView.image = UIImage(named: "lobbyTable")
        self.addSubview(tableImgView)
        
        //Setup labels
        self.setupNameLabels()
        
        //Setup button
        self.setupButton()
    }
    
    func setTable(table: LobbyTable) {
        lobbyTable = table
    }
    
    func rePaint() {
        for i in 0 ... 5 {
            self.nameLabelDict[i]!.text = ""
        }
        
        guard delegate.getTables().count != 0 else { return }
        
        if lobbyTable == nil {
            lobbyTable = delegate.getTables().first!
        } else if (!delegate.getTables().contains(lobbyTable!)) {
            lobbyTable = delegate.getTables().first
        }
        
        for i in 0 ..< max(0, lobbyTable!.getNames().count) {
            self.nameLabelDict[i]!.text = lobbyTable!.getNames()[i]
        }
        
        self.joinLeaveButton.setImage(UIImage(named: "leaveSeat"), forState: .Normal)
    }
    
    private func setupButton() {
        self.joinLeaveButton = UIButton()
        self.joinLeaveButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(joinLeaveButton)
        
        //Dimms
        let heightConst = NSLayoutConstraint(item: self.joinLeaveButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: tableImgView.frame.height * 0.5)
        let widthConst = NSLayoutConstraint(item: self.joinLeaveButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: tableImgView.frame.width * 0.5)
        self.joinLeaveButton.addConstraints([heightConst, widthConst])
        
        //Position
        let centerX = NSLayoutConstraint(item: self.joinLeaveButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.tableImgView, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: self.joinLeaveButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.tableImgView, attribute: .CenterY, multiplier: 1, constant: 0)
        self.addConstraints([centerX, centerY])
        
        //Set action
        self.joinLeaveButton.addTarget(self, action: #selector(TablePreview.joinButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    func setupNameLabels() {
        self.nameLabelDict = [Int:UILabel]()
        
        for i in 0 ... 5 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .Center
            label.textColor = .whiteColor()
            
            let yConst = getNameYConst(i, label: label)
            let xConst = getNameXConst(i, label: label)
            self.addConstraints([yConst, xConst])
            
            self.nameLabelDict[i] = label
        }
    }
    
    private func getNameYConst(p: Int, label: UILabel) -> NSLayoutConstraint {
        let attribute:NSLayoutAttribute = (p == 0 ? .Bottom : p == 3 ? .Top : .CenterY)
        let offset:CGFloat = (p == 0 || p == 3 ? 0 : p == 1 || p == 5 ? self.tableImgView.frame.height * 0.2 : -self.tableImgView.frame.height * 0.2)
        return NSLayoutConstraint(item: label, attribute: attribute, relatedBy: .Equal, toItem: self.tableImgView, attribute: attribute, multiplier: 1, constant: offset)
    }
    
    private func getNameXConst(p: Int, label: UILabel) -> NSLayoutConstraint {
        let attribute:NSLayoutAttribute = (p == 0 || p == 3 ? .CenterX : p == 1 || p == 2 ? .Left : .Right)
        return NSLayoutConstraint(item: label, attribute: attribute, relatedBy: .Equal, toItem: self.tableImgView, attribute: attribute, multiplier: 1, constant: 0)
    }
    
    func joinButtonClicked() {
        if let del = delegate {
            if let table = lobbyTable {
                del.joinTableClicked(table.tableID)
                return
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
