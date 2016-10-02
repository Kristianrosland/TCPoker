//
//  TableViewCell.swift
//  TCPoker
//
//  Created by Kristian Rosland on 19.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class TableViewCell: UIView, UIGestureRecognizerDelegate {

    var table: LobbyTable!
    var delegate: TableViewCellDelegate!
    
    init(table: LobbyTable, delegate: TableViewCellDelegate) {
        super.init(frame: CGRectZero)
        self.table = table
        self.delegate = delegate
        
        //Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector(self.clicked))
        tapGesture.delegate = self
        self.userInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clicked() {
        delegate.cellClicked(self.table)
    }

}
