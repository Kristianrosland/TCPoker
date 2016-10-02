//
//  Card.swift
//  112ShadesOfPoker
//
//  Created by Kristian Rosland on 15.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class Card: UIView {

    var rank:Int!
    var suit:Suit!
    
    init(rank: Int, suit: Suit) {
        super.init(frame: CGRect.zero)
        assert(rank >= 2 && rank <= 14);
        
        self.rank = rank
        self.suit = suit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toString() -> String {
        return suit.toString() + toLetter()
    }
    
    func toLetter() -> String {
        switch (rank) {
            case 14: return "A"
            case 13: return "K"
            case 12: return "Q"
            case 11: return "J"
            default: return String(rank)
        }
    }
    
    func getCardImage() -> UIImage{
        let imgName:String = (suit == .Spades ? "Spades " : suit == .Hearts ? "Hearts " : suit == .Clubs ? "Clubs " : "Diamonds ") + String(rank)
        return UIImage(named: imgName)!
    }
    
    enum Suit {
        case Spades
        case Hearts
        case Diamonds
        case Clubs
        
        func toString() -> String {
            switch (self) {
                case .Spades: return "\u{2660}"
                case .Hearts: return "\u{2665}"
                case .Diamonds: return "\u{2666}"
                case .Clubs: return "\u{2663}"
            }
        }
    }
    
}
