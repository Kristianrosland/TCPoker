//
//  UpiUtils.swift
//  TCPoker
//
//  Created by Kristian Rosland on 19.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

extension String {
    func startsWith(string: String) -> Bool {
        guard let range = rangeOfString(string, options:[.AnchoredSearch, .CaseInsensitiveSearch]) else {
            return false
        }
        
        return range.startIndex == startIndex
    }
    
    func endsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str, options:NSStringCompareOptions.BackwardsSearch) {
            return range.endIndex == self.endIndex
        }
        return false
    }

    func tokenize() -> [String]{
        let allTokens = self.componentsSeparatedByString(" ")
        var returnTokens = [String]()
        
        var insideQuotes:Bool = false
        var s: String = ""
        
        for token in allTokens {
            var t = token
            if (token.startsWith("\"")) {
                insideQuotes = true
                s = t.substringFromIndex(token.startIndex.advancedBy(1))
                if (token.endsWith("\"")) {
                    s = s.substringToIndex(s.endIndex.advancedBy(-1))
                    returnTokens.append(s)
                    insideQuotes = false
                }
                continue;
            }
            
            if (insideQuotes) {
                if (token.endsWith("\"")) {
                    insideQuotes = false
                    t = t.substringToIndex(t.endIndex.advancedBy(-1))
                    s.appendContentsOf(" "+t)
                    returnTokens.append(s)
                    continue
                }
                s.appendContentsOf(" " + t)
            } else {
                returnTokens.append(t)
            }
        }
        
        return returnTokens
    }
    
}

class UpiUtils: NSObject {

    
    static func parseCard(cardString: String) -> Card{
        if(cardString.startsWith("spades")) {
            let rank = Int(cardString.substringFromIndex(cardString.startIndex.advancedBy(6)))!
            return Card(rank: rank, suit: Card.Suit.Spades)
        } else if(cardString.startsWith("hearts")) {
            let rank = Int(cardString.substringFromIndex(cardString.startIndex.advancedBy(6)))!
            return Card(rank: rank, suit: Card.Suit.Hearts)
        } else if(cardString.startsWith("diamonds")) {
            let rank = Int(cardString.substringFromIndex(cardString.startIndex.advancedBy(8)))!
            return Card(rank: rank, suit: Card.Suit.Diamonds)
        } else {
            let rank = Int(cardString.substringFromIndex(cardString.startIndex.advancedBy(5)))!
            return Card(rank: rank, suit: Card.Suit.Clubs)
        }
    }
    
    static func decisionFromUPIString(upiString: String) -> Decision? {
        switch(upiString) {
        case "fold":
            return Decision.init(move: Move.Fold)
        case "check":
            return Decision.init(move: Move.Check)
        case "call":
            return Decision.init(move: Move.Call)
        case "smallBlind":
            return Decision.init(move: Move.Small_blind)
        case "bigBlind":
            return Decision.init(move: Move.Big_blind)
        case "allIn":
            return Decision.init(move: Move.All_in)
        default:
            if (upiString.lowercaseString.containsString("bet")) {
                let size = Int(upiString.substringFromIndex(upiString.startIndex.advancedBy(3)))
                if let _ = size {
                    return Decision.init(move: Move.Bet, size: size!)
                } else {
                    print("Error parsing upi decision, " + upiString); return nil
                }
            } else if (upiString.lowercaseString.containsString("raise")) {
                let size = Int(upiString.substringFromIndex(upiString.startIndex.advancedBy(5)))
                if let _ = size {
                    return Decision.init(move: Move.Raise, size: size!)
                } else {
                    print("Error parsing upi decision, " + upiString); return nil
                }
            } else {
                print("Error parsing upi decision, " + upiString); return nil
            }
        }
    }
    
    static func decisionToUPIString(decision: Decision) -> String {
        var string: String = "decision "
        switch(decision.move!) {
        case Move.Fold: string.appendContentsOf("fold"); break;
        case Move.Check: string.appendContentsOf("check"); break;
        case Move.Call: string.appendContentsOf("call"); break;
        case Move.Small_blind: string.appendContentsOf("smallBlind"); break;
        case Move.Big_blind: string.appendContentsOf("bigBlind"); break;
        case Move.Bet:
            string.appendContentsOf("bet");
            string.appendContentsOf(String(decision.size))
            break;
        case Move.Raise:
            string.appendContentsOf("raise");
            string.appendContentsOf(String(decision.size))
            break;
        default:
            break;
        }
        
        return string
    }
}
