//
//  CheckButton.swift
//  112ShadesOfPoker
//
//  Created by Kristian Rosland on 15.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class CheckButton: UIButton {

    var actionLabel:UILabel!
    var amountLabel:UILabel!
    
    init(width: CGFloat, height:CGFloat) {
        super.init(frame: CGRect.zero)
        
        //Dimmensions
        let heightConst = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        let widthConst = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
        self.addConstraints([heightConst, widthConst])
        
        
        //Set image
        self.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
        
        //Create labels
        self.actionLabel = UILabel();
        self.amountLabel = UILabel();
        self.actionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.amountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(actionLabel)
        self.addSubview(amountLabel)
        
        self.actionLabel.text = "Call"
        self.amountLabel.text = "$200"
        self.actionLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        self.amountLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        self.actionLabel.textColor = .whiteColor()
        self.amountLabel.textColor = .whiteColor()
        
        //Action label constraints
        let centerXConst = NSLayoutConstraint(item: actionLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerYConst = NSLayoutConstraint(item: actionLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: -12)
        self.addConstraints([centerXConst, centerYConst])
        
        //Amount label constraints
        let centerXConstraint = NSLayoutConstraint(item: amountLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let topConst = NSLayoutConstraint(item: amountLabel, attribute: .Top, relatedBy: .Equal, toItem: actionLabel, attribute: .Bottom, multiplier: 1, constant: 0)
        self.addConstraints([centerXConstraint, topConst])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
