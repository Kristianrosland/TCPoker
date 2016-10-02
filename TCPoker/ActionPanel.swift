//
//  ActionPanel.swift
//  112ShadesOfPoker
//
//  Created by Kristian Rosland on 15.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class ActionPanel: UIView {

    //Dimmensions
    var width:CGFloat!
    var height:CGFloat!
    
    //Buttons
    var foldButton:FoldButton!
    var checkCallButton:CheckButton!
    var betRaiseButton:RaiseButton!

    //Delegate
    var delegate:ActionDelegate!
    

    init(delegate: ActionDelegate, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect.zero)
        
        self.height = height;
        self.width = width;
        self.delegate = delegate
        
        //self.backgroundColor = .blueColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //Constraints
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem:nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
        self.addConstraints([heightConstraint, widthConstraint]);

        //Buttons
        setupButtons();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func foldButtonClicked() {
        delegate.fold()
    }
    
    func checkCallButtonClicked() {
        if (checkCallButton.actionLabel.text == "Check") {
            delegate.check()
        } else {
            delegate.call()
        }
    }
    
    func showRaiseMenuButton() {
        delegate.showRaiseMenu()
    }
    
    
    func show(gameState: GameState) {
        for button in [checkCallButton, foldButton, betRaiseButton] {
            button.hidden = false
        }
        
        if (gameState.highestAmountPutOnTable == 0) {
            checkCallButton.actionLabel.text = "Check"
            checkCallButton.amountLabel.text = ""
            betRaiseButton.label.text = "Bet"
        } else {
            checkCallButton.actionLabel.text = "Call"
            checkCallButton.amountLabel.text = "$" + String(gameState.highestAmountPutOnTable)
            checkCallButton.actionLabel.text = "Raise"
            betRaiseButton.label.text = "Raise"
        }
    }
    
    func hide() {
        for button in [checkCallButton, foldButton, betRaiseButton] {
            button.hidden = true
        }
    }
    
    
    //MARK: Setup functions
    private func setupButtons() {
        foldButton = FoldButton(width: width/3, height: height)
        checkCallButton = CheckButton(width: width/3, height: height)
        betRaiseButton = RaiseButton(width: width/3, height: height)
        
        for button in [foldButton, checkCallButton, betRaiseButton] {
            button.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button)
        }
        
        //FoldButton
        let bottomConstraint = NSLayoutConstraint(item: foldButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -10)
        let leftConstraint = NSLayoutConstraint(item: foldButton, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 10)
        self.addConstraints([bottomConstraint, leftConstraint])
        
        //Check and raise button
        for button in [checkCallButton, betRaiseButton] {
            let leftConst = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: button == checkCallButton ? foldButton : checkCallButton, attribute: .Right, multiplier: 1, constant: 0)
            let bottomConst = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -10)
            self.addConstraints([leftConst, bottomConst])
        }
        
        foldButton.addTarget(self, action: #selector(ActionPanel.foldButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        checkCallButton.addTarget(self, action: #selector(ActionPanel.checkCallButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        betRaiseButton.addTarget(self, action: #selector(ActionPanel.showRaiseMenuButton), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
}
