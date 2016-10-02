//
//  RaiseView.swift
//  112ShadesOfPoker
//
//  Created by Kristian Rosland on 16.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class RaiseView: UIView {

    var width:CGFloat!
    var height:CGFloat!
    
    var plusButton:UIButton!
    var minusButton:UIButton!
    var raiseButton:UIButton!
    var cancelButton:UIButton!
    
    var amountSlider:UISlider!
    var raiseLabel:UILabel!
    
    var raiseAmount:Int!
    var playerPutOnTable: Int!
    var delegate: ActionDelegate!
    
    init(delegate: ActionDelegate, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.width = width
        self.height = height
        self.delegate = delegate
        self.raiseAmount = 0
        
        let heightConst = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        let widthConst = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
        self.addConstraints([heightConst, widthConst])
        
        self.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
        
        self.setupPlusAndMinusButtons();
        self.setupAmountSlider()
        self.setupRaiseAndCancelButton();
        self.setupRaiseLabel()
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func sliderValueDidChange(sender:UISlider!) {
        self.raiseAmount = Int(sender.value)
        self.raiseLabel.text = "$" + String(raiseAmount)
    }
    
    func raiseButtonClicked() {
        delegate.raise(raiseAmount - playerPutOnTable)
    }
    
    func cancelButtonClicked() {
        delegate.cancel()
    }
    
    func show(minSliderValue: Int, maxSliderValue: Int, playerPutOnTable: Int, buttonText: String) {
        guard buttonText == "Bet" || buttonText == "Raise" else { fatalError() }
        self.hidden = false
        self.raiseButton.setTitle(buttonText, forState: .Normal)
        self.amountSlider.minimumValue = Float(minSliderValue)
        self.amountSlider.maximumValue = Float(maxSliderValue)
        self.raiseAmount = Int(amountSlider.minimumValue)
        self.raiseLabel.text = "$" + String(raiseAmount)
        self.playerPutOnTable = playerPutOnTable
    }
    
    func hide() {
        self.hidden = true
    }
    
    func plusButtonClicked() {
        self.raiseAmount = min(Int(self.amountSlider.maximumValue), (raiseAmount + 50))
        self.raiseLabel.text = "$" + String(raiseAmount)
        self.amountSlider.value = Float(raiseAmount)
    }
    
    func minusButtonClicked() {
        self.raiseAmount = max(Int(self.amountSlider.minimumValue), (raiseAmount - 50))
        self.raiseLabel.text = "$" + String(raiseAmount)
        self.amountSlider.value = Float(raiseAmount)
    }
    
    
    
    
    
    
    
    
    //MARK: Setup methods
    private func setupAmountSlider() {
        self.amountSlider = UISlider(frame: CGRectMake(0, 0, 100, 20))
        self.amountSlider.translatesAutoresizingMaskIntoConstraints = false
        self.amountSlider.addTarget(self, action: #selector(RaiseView.sliderValueDidChange(_:)), forControlEvents: .ValueChanged)
        self.amountSlider.tintColor = .redColor()
        self.addSubview(amountSlider)
        
        //Position
        let leftConst = NSLayoutConstraint(item: self.amountSlider, attribute: .Left, relatedBy: .Equal, toItem: self.minusButton, attribute: .Right, multiplier: 1, constant: 10)
        let rightConst = NSLayoutConstraint(item: self.amountSlider, attribute: .Right, relatedBy: .Equal, toItem: self.plusButton, attribute: .Left, multiplier: 1, constant: -10)
        let topConst = NSLayoutConstraint(item: self.amountSlider, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 25)
        self.addConstraints([leftConst, rightConst, topConst])
        
    }
    
    private func setupPlusAndMinusButtons() {
        self.minusButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.plusButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        for button in [minusButton, plusButton] {
            button.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button)
            
            let topConst = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 20)
            let sideConst = NSLayoutConstraint(item: button, attribute: button == minusButton ? .Left : .Right, relatedBy: .Equal, toItem: self, attribute: button == minusButton ? .Left : .Right, multiplier: 1, constant: button == minusButton ? self.width * 0.20 : -(self.width * 0.20))
            self.addConstraints([topConst, sideConst])
            
            button.setImage(UIImage(named: (button == minusButton ? "minusButton" : "plusButton")), forState: .Normal)
        }
        
        self.minusButton.addTarget(self, action: #selector(RaiseView.minusButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        self.plusButton.addTarget(self, action: #selector(RaiseView.plusButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupRaiseLabel() {
        self.raiseLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
        self.raiseLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.raiseLabel)
        
        //Pos
        let leftConst = NSLayoutConstraint(item: self.raiseLabel, attribute: .Left, relatedBy: .Equal, toItem: self.minusButton, attribute: .Right, multiplier: 1, constant: 0)
        let rightConst = NSLayoutConstraint(item: self.raiseLabel, attribute: .Right, relatedBy: .Equal, toItem: self.plusButton, attribute: .Left, multiplier: 1, constant: 0)
        let topConst = NSLayoutConstraint(item: self.raiseLabel, attribute: .Top, relatedBy: .Equal, toItem: self.amountSlider, attribute: .Bottom, multiplier: 1, constant: 0)
        self.addConstraints([leftConst, rightConst, topConst])
        
        self.raiseLabel.textAlignment = .Center
        self.raiseLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        self.raiseLabel.adjustsFontSizeToFitWidth = true
        self.raiseLabel.textColor = .darkGrayColor()
        self.raiseLabel.text = "$5000"
    }
    
    private func setupRaiseAndCancelButton() {
        self.raiseButton = UIButton(frame: CGRectMake(0, 0, (self.width/2)-1, 30))
        self.cancelButton = UIButton(frame: CGRectMake(0, 0, (self.width/2)-1, 30))
        self.addSubview(raiseButton)
        self.addSubview(cancelButton)
        self.raiseButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.raiseButton.backgroundColor = UIColor(red: 35/255, green: 120/255, blue: 40/255, alpha: 1)
        self.cancelButton.backgroundColor = UIColor(red: 120/255, green: 30/255, blue: 40/255, alpha: 1)
        self.raiseButton.alpha = 0.7
        self.cancelButton.alpha = 0.7
        self.raiseButton.setTitle("Raise", forState: .Normal)
        self.cancelButton.setTitle("Cancel", forState: .Normal)
        self.raiseButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        self.cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        self.raiseButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.raiseButton.titleLabel?.textAlignment = .Center
        self.cancelButton.titleLabel?.textAlignment = .Center
        self.raiseButton.addTarget(self, action: #selector(RaiseView.raiseButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        self.cancelButton.addTarget(self, action: #selector(RaiseView.cancelButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        for button in [cancelButton, raiseButton] {
            
            let bottomConst = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
            let sideConst = NSLayoutConstraint(item: button, attribute: button == cancelButton ? .Left : .Right, relatedBy: .Equal, toItem: self, attribute: button == cancelButton ? .Left : .Right, multiplier: 1, constant: 0)
            var betweenConst: NSLayoutConstraint!
            if (button == cancelButton) {
                betweenConst = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: (width/2)-10)
            } else {
                betweenConst = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -(width/2 + 10))
            }
            self.addConstraints([bottomConst, sideConst, betweenConst])
        }
    }
}
