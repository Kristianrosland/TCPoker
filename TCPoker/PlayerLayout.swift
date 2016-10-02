//
//  PlayerLayout.swift
//  112ShadesOfPoker
//
//  Created by Kristian Rosland on 15.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class PlayerLayout: UIView {
    
    enum TableSide {
        case Bottom
        case Top
        case Left
        case Right
    }
    
    var height:CGFloat!
    var width:CGFloat!
    var chipOffset:CGFloat = 40 // How much space the chip image of this layout needs

    var leftCard:UIImageView!
    var rightCard:UIImageView!
    var chips:UIImageView!
    var betLabel:UILabel!
    var dealerButton:UIImageView!
    var tableSide:TableSide!
    var stackLabel:UILabel!
    var nameLabel:UILabel!
    
    var cardHeight:CGFloat!, cardWidth:CGFloat!
    var card1: Card?, card2: Card?
    
    
    //Constructor
    init(tableSide: TableSide) {
        super.init(frame: CGRect.zero)
        self.tableSide = tableSide;

        setupDimmensions();
        
        //self.backgroundColor = UIColor.blueColor();
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //Constraints
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem:nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
        self.addConstraints([heightConstraint, widthConstraint]);
        
        setupCardImageViews();
        setupLabels();
        setupDealerButton();
        setupChips();
        
    }
    
    //Required constructor (used for creating object in Storyboard)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDealer(dealer: Bool) {
        if (dealer) {
            self.dealerButton.image = UIImage(named: "dealer")
        } else {
            self.dealerButton.image = nil
        }
    }
    
    func setStacksize(size: Int) {
        self.stackLabel.text = "$" + String(size)
    }
    
    
    func setHand(card1: Card, card2: Card) {
        self.card1 = card1
        self.card2 = card2
        
        self.leftCard.image = card1.getCardImage()
        self.rightCard.image = card2.getCardImage()
    }
    
    
    func setLastMove(betSize: Int, bigBlind: Int) {
        self.betLabel.text = betSize > 0 ? String(betSize) : ""
        self.chips.image = betSize > 0 ? getChipImage(betSize, bigBlind: bigBlind) : nil
    }
    
    func makeDecision(gameState: GameState, decision: Decision) {
        guard gameState.bigBlind != nil && gameState.smallBlind != nil else { return }
        switch(decision.move!) {
        case Move.Fold:
            self.leftCard!.alpha = 0.5
            self.rightCard!.alpha = 0.5
            break
        case Move.Small_blind:
            self.setLastMove(gameState.smallBlind!, bigBlind: gameState.bigBlind!)
            break
        case Move.Big_blind:
            self.setLastMove(gameState.bigBlind!, bigBlind: gameState.smallBlind!)
            break
        case Move.Check:
            self.setLastMove(0, bigBlind: gameState.bigBlind!)
            break
        case Move.Call:
            if let amount = gameState.highestAmountPutOnTable {
                self.setLastMove(amount, bigBlind: gameState.bigBlind!)
            } else {
                self.setLastMove(0, bigBlind: gameState.bigBlind!)
            }
            break
        case Move.Bet:
            setLastMove(decision.size, bigBlind: gameState.bigBlind!)
            break
        case Move.Raise:
            if let amount = gameState.highestAmountPutOnTable {
                setLastMove(decision.size + amount, bigBlind: gameState.bigBlind!)
            }
            break
        default:
            break
        }
    }
    
    func newHand() {
        self.leftCard.alpha = 1.0
        self.rightCard.alpha = 1.0
        
        self.leftCard.image = UIImage(named: "cardBack")
        self.rightCard.image = UIImage(named: "cardBack")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Setup methods
    private func setupChips() {
        self.chips = UIImageView()
        self.betLabel = UILabel()
        self.chips.translatesAutoresizingMaskIntoConstraints = false
        self.betLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chips)
        self.addSubview(betLabel)
        
        let widthConst = NSLayoutConstraint(item: chips, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 25)
        let heightConst = NSLayoutConstraint(item: chips, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 25)
        chips.addConstraints([widthConst, heightConst])
        
        var chipRightConst:NSLayoutConstraint!
        var chipBottomConst:NSLayoutConstraint!
        var labelRightConst:NSLayoutConstraint!
        var labelBottomConst:NSLayoutConstraint!
        if (self.tableSide == .Bottom) {
            chipRightConst = NSLayoutConstraint(item: chips, attribute: .Right, relatedBy: .Equal, toItem: dealerButton, attribute: .Left, multiplier: 1, constant: -8)
            chipBottomConst = NSLayoutConstraint(item: chips, attribute: .Bottom, relatedBy: .Equal, toItem: rightCard, attribute: .Top, multiplier: 1, constant: -4)
            labelRightConst = NSLayoutConstraint(item: betLabel, attribute: .Right, relatedBy: .Equal, toItem: chips, attribute: .Left, multiplier: 1, constant: -10)
            labelBottomConst = NSLayoutConstraint(item: betLabel, attribute: .Bottom, relatedBy: .Equal, toItem: rightCard, attribute: .Top, multiplier: 1, constant: -8)
        } else if self.tableSide == .Top {
            chipRightConst = NSLayoutConstraint(item: chips, attribute: .Right, relatedBy: .Equal, toItem: dealerButton, attribute: .Left, multiplier: 1, constant: -8)
            chipBottomConst = NSLayoutConstraint(item: chips, attribute: .Top, relatedBy: .Equal, toItem: rightCard, attribute: .Bottom, multiplier: 1, constant: 4)
            labelRightConst = NSLayoutConstraint(item: betLabel, attribute: .Right, relatedBy: .Equal, toItem: chips, attribute: .Left, multiplier: 1, constant: -10)
            labelBottomConst = NSLayoutConstraint(item: betLabel, attribute: .Top, relatedBy: .Equal, toItem: rightCard, attribute: .Bottom, multiplier: 1, constant: 8)
        } else  if self.tableSide == .Left {
            chipRightConst = NSLayoutConstraint(item: chips, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
            chipBottomConst = NSLayoutConstraint(item: chips, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
            labelRightConst = NSLayoutConstraint(item: betLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
            labelBottomConst = NSLayoutConstraint(item: betLabel, attribute: .Bottom, relatedBy: .Equal, toItem: chips, attribute: .Top, multiplier: 1, constant: 0)
        } else {
            chipRightConst = NSLayoutConstraint(item: chips, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
            chipBottomConst = NSLayoutConstraint(item: chips, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
            labelRightConst = NSLayoutConstraint(item: betLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
            labelBottomConst = NSLayoutConstraint(item: betLabel, attribute: .Bottom, relatedBy: .Equal, toItem: chips, attribute: .Top, multiplier: 1, constant: 0)
        }
        
        self.addConstraints([chipRightConst, chipBottomConst, labelBottomConst, labelRightConst])
        
        self.betLabel.font = UIFont(name: "HelveticaNeue", size: 10)
        self.betLabel.textColor = .whiteColor()
        
    }
    
    private func setupCardImageViews() {
        let backCardImage: UIImage! = UIImage(named: "cardBack")!
        leftCard = UIImageView(image: backCardImage);
        rightCard = UIImageView(image: backCardImage);
        leftCard.translatesAutoresizingMaskIntoConstraints = false
        rightCard.translatesAutoresizingMaskIntoConstraints = false
        
        for card in [leftCard, rightCard] {
            self.addSubview(card)
            
            //Dimms
            let cardHeightConst = NSLayoutConstraint(item: card, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.cardHeight)
            let cardWidthConst = NSLayoutConstraint(item: card, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.cardWidth)
            card.addConstraints([cardHeightConst, cardWidthConst])
            
            //Positioning
            let rightConst: NSLayoutConstraint!
            var topConst: NSLayoutConstraint!
            if (self.tableSide == .Bottom) {
                //Bottom seat
                rightConst = NSLayoutConstraint(item: card, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: card == leftCard ? -53 : 0)
                topConst = NSLayoutConstraint(item: card, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: chipOffset/2)
            }
            else if (self.tableSide == .Top) {
                //Top seat
                topConst = NSLayoutConstraint(item: card, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: -(chipOffset/2))
                rightConst = NSLayoutConstraint(item: card, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: card == leftCard ? -40 : 0)
                
            } else if (self.tableSide == .Left){
                //Left seat
                topConst = NSLayoutConstraint(item: card, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 5)
                rightConst = NSLayoutConstraint(item: card, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: card == leftCard ? -(40+chipOffset) : -chipOffset)
            } else {
                //Right seat
                topConst = NSLayoutConstraint(item: card, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 5)
                rightConst = NSLayoutConstraint(item: card, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: card == leftCard ? -40 : 0)
            }
            
            self.addConstraints([rightConst, topConst])
        }
    }
    
    func getHeight() -> CGFloat {
        return self.height;
    }
    
    private func setupDimmensions() {
        if (tableSide == .Bottom) {
            height = 90 + chipOffset
            width = 175
            cardWidth = 50
            cardHeight = 75
        }
        else if (tableSide == .Top) {
            height = 62 + chipOffset
            width = 175
            cardHeight = 60
            cardWidth = 40
        } else {
            height = 100
            width = 90 + chipOffset
            cardHeight = 60
            cardWidth = 40
        }
    }
    
    
    private func setupDealerButton(){
        dealerButton = UIImageView()
        dealerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dealerButton)
        
        //Dimms
        let heightConstraint = NSLayoutConstraint(item: dealerButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        let widthConstraint = NSLayoutConstraint(item: dealerButton, attribute: .Width  , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        dealerButton.addConstraints([heightConstraint, widthConstraint])
        
        if (self.tableSide == .Bottom) {
            let rightConstraint = NSLayoutConstraint(item: dealerButton, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: dealerButton, attribute: .Bottom, relatedBy: .Equal, toItem: rightCard, attribute: .Top, multiplier: 1, constant: -4)
            self.addConstraints([rightConstraint, bottomConstraint])
        } else if self.tableSide == .Top {
            let rightConstraint = NSLayoutConstraint(item: dealerButton, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: dealerButton, attribute: .Top, relatedBy: .Equal, toItem: rightCard, attribute: .Bottom, multiplier: 1, constant: 4)
            self.addConstraints([rightConstraint, bottomConstraint])
        } else  if self.tableSide == .Left {
            let rightConstraint = NSLayoutConstraint(item: dealerButton, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -18)
            let bottomConstraint = NSLayoutConstraint(item: dealerButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -15)
            self.addConstraints([rightConstraint, bottomConstraint])
        } else {
            let leftConstraint = NSLayoutConstraint(item: dealerButton, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 18)
            let bottomConstraint = NSLayoutConstraint(item: dealerButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -15)
            self.addConstraints([leftConstraint, bottomConstraint])
        }
    }
    
    private func setupLabels() {
        //Put labels on left side of cards
        self.nameLabel = UILabel();
        self.stackLabel = UILabel();
        
        
        for label in [nameLabel, stackLabel] {
            self.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false;
            
            
            if (self.tableSide == .Bottom) {
                //Bottom seat
                let leftConstraint = NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 5)
                let topConstraint = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: label == nameLabel ? self : nameLabel, attribute: label == nameLabel ? .Top : .Bottom , multiplier: 1, constant: label == nameLabel ? chipOffset*1.5 : 3)
                self.addConstraints([leftConstraint, topConstraint])
            }
            else if (self.tableSide == .Top) {
                //Top seat
                let leftConstraint = NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 5)
                let topConstraint = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: label == nameLabel ? self : nameLabel, attribute: (label == nameLabel ? .Top : .Bottom), multiplier: 1, constant: 7)
                self.addConstraints([leftConstraint, topConstraint])
            } else {
                //Left/right seat
                var topConstraint: NSLayoutConstraint!
                if (label == nameLabel) {
                    topConstraint = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: cardHeight+3)
                } else {
                    topConstraint = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: label == stackLabel ? nameLabel : stackLabel, attribute: .Bottom, multiplier: 1, constant: 1)
                }
                
                let centerX = NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: (tableSide == .Left ? -(chipOffset/2) : (chipOffset/2)))
                self.addConstraints([topConstraint, centerX])
            }
            
            label.text = label == nameLabel ? "<name>" : "$...";
            label.font = UIFont(name: "HelveticaNeue", size: 16)
            label.textColor = .whiteColor()
        }
    }
    
    private func getChipImage(betSize: Int, bigBlind: Int) -> UIImage {
        if (betSize <= bigBlind / 2){
            return UIImage(named: "smallblind")!
        } else if (betSize <= bigBlind){
            return UIImage(named: "bigblind")!
        } else if (betSize <= bigBlind*3){
            return UIImage(named: "poker1")!
        } else if (betSize <= bigBlind*5){
            return UIImage(named: "poker2")!
        } else if (betSize <= bigBlind*8){
            return UIImage(named: "poker3")!
        } else if (betSize <= bigBlind*12) {
            return UIImage(named: "poker4")!
        } else if (betSize <= bigBlind*20) {
            return UIImage(named: "poker6")!
        } else if (betSize <= bigBlind*50) {
            return UIImage(named: "poker7")!
        } else {
            return UIImage(named: "poker8")!
        }
    }
}
