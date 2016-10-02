//
//  Board.swift
//  112ShadesOfPoker
//
//  Created by Kristian Rosland on 16.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class Board: UIView {

    var winnerLabel:UILabel!
    var communityCards:[UIImageView]!
    var potLabel:UILabel!
    
    var height:CGFloat!
    var width:CGFloat!
    var cardWidth:CGFloat = 50;
    var cardHeight: CGFloat = 75
    
    init(width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect.zero)
        
        self.width = width
        self.height = height
        
        //Dimms
        let heightConst = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        let widthConst = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
        self.addConstraints([heightConst, widthConst])
        
        self.setupCommunityCards();
        self.setupWinnerTextLabel();
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setFlop(card1: Card, card2: Card, card3: Card) {
        communityCards[0].image = card1.getCardImage()
        communityCards[1].image = card2.getCardImage()
        communityCards[2].image = card3.getCardImage()
    }
    
    func setTurn(card: Card) {
        communityCards[3].image = card.getCardImage()
    }
    
    func setRiver(card: Card) {
        communityCards[4].image = card.getCardImage()
    }
    
    func setWinnerText(winnerText: String) {
        self.winnerLabel.text = winnerText
    }
    
    func setPot(pot: Int) {
        self.potLabel.text = "$" + String(pot)
    }
    
    func reset() {
        for imageview in communityCards {
            imageview.image = nil
        }
        
        self.winnerLabel.text = ""
        //self.potLabel.text = ""
    }
    
    //MARK: Setup methods
    private func setupCommunityCards() {
        communityCards = [UIImageView]()
        
        for i in 0...4 {
            let cardView = UIImageView()
            self.addSubview(cardView)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            
            //Dimms
            let cardHeightConst = NSLayoutConstraint(item: cardView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: cardHeight)
            let cardWidthConst = NSLayoutConstraint(item: cardView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: cardWidth)
            cardView.addConstraints([cardHeightConst, cardWidthConst])
            
            communityCards.append(cardView)
            
            //Position
            let cardTopConst = NSLayoutConstraint(item: cardView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
            let cardLeftConst = NSLayoutConstraint(item: cardView, attribute: .Left, relatedBy: .Equal, toItem: i == 0 ? self : communityCards[i-1], attribute: i == 0 ? .Left : .Right, multiplier: 1, constant: 1)
            self.addConstraints([cardTopConst, cardLeftConst])
        }
    }
    
    private func setupWinnerTextLabel() {
        self.winnerLabel = UILabel()
        self.winnerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.winnerLabel.textAlignment = NSTextAlignment.Center
        self.winnerLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.winnerLabel.numberOfLines = 0
        self.winnerLabel.textColor = .whiteColor()
        self.addSubview(winnerLabel)
        
        //Dimms
        let labelHeight = NSLayoutConstraint(item: winnerLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.height - self.cardHeight)
        self.winnerLabel.addConstraints([labelHeight])
        
        //Position
        let labelCenterX = NSLayoutConstraint(item: self.winnerLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let labelTopConst = NSLayoutConstraint(item: self.winnerLabel, attribute: .Top, relatedBy: .Equal, toItem: self.communityCards[0], attribute: .Bottom, multiplier: 1, constant: 0)
        self.addConstraints([labelCenterX, labelTopConst])
    }
}
