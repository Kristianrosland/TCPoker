//
//  MainScreenVC.swift
//  TCPoker
//
//  Created by Kristian Rosland on 19.05.2016.
//  Copyright © 2016 Kristian Rosland. All rights reserved.
//

import UIKit

class MainScreenVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var ipAddressTF: UITextField!
    
    //Communicator
    var serverCommunicator:ServerCommunicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTF.delegate = self
        self.ipAddressTF.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainScreenVC.backgroundClicked))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backgroundClicked(){
        self.usernameTF.resignFirstResponder()
        self.ipAddressTF.resignFirstResponder()
    }
    
    @IBAction func enterButtonClicked(sender: AnyObject) {
        let name = usernameTF.text!
        var ipAddress = ipAddressTF.text!
        
        guard !name.isEmpty else { print("More info required"); return; }
        if ipAddress.isEmpty { ipAddress = "127.0.0.1"; }
        
        serverCommunicator = ServerCommunicator(name: name, ipAddress: ipAddress)
        
        if serverCommunicator != nil {
            performSegueWithIdentifier("mainToLobbySegue", sender: self)
        } else {
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mainToLobbySegue") {
            let destinationVC = segue.destinationViewController as! LobbyScreenVC
            destinationVC.prepareServerCommunicator(self.serverCommunicator!)
        }
    }
}
