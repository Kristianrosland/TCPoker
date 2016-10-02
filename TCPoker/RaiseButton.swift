//
//  RaiseButton.swift
//  112ShadesOfPoker
//
//  Created by Kristian Rosland on 15.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class RaiseButton: UIButton {
    
    var label:UILabel!
    var amountTextField:UITextField!
    var plusButton:UIButton!
    var minusButton:UIButton!
    
    init(width: CGFloat, height:CGFloat) {
        super.init(frame: CGRect.zero)
        
        //Dimmensions
        let heightConst = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        let widthConst = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
        self.addConstraints([heightConst, widthConst])
        
        //Set image
        self.setBackgroundImage(UIImage(named: "raise"), forState: .Normal)
        
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        //Create label
        self.label = UILabel();
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        self.label.text = "Raise"
        self.label.font = UIFont(name: "HelveticaNeue", size: 20)
        self.label.textColor = .whiteColor()
        
        let centerXConst = NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerYConst = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: -12)
        self.addConstraints([centerXConst, centerYConst])
    }
}
