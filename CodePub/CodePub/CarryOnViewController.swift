//
//  CarryOnViewController.swift
//  CodePub
//
//  Created by Susanne Moseby on 09/02/15.
//  Copyright (c) 2015 codepub. All rights reserved.
//

import Foundation
import UIKit

class CarryOnViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var longPressButton: UIButton!
    
    var nameString: String = ""
    
    override func viewDidLoad() {
        self.nameLabel.text = nameString
    }
    
    
    @IBAction func pressMeLongTime(sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began) {
            println("3 Seconds baby")
            self.performSegueWithIdentifier("cupcakes", sender: self)
        }
    }
}