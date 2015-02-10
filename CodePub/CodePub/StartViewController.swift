//
//  StartViewController.swift
//  CodePub
//
//  Created by Susanne Moseby on 09/02/15.
//  Copyright (c) 2015 codepub. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as? CarryOnViewController
        destinationViewController?.nameString = nameTextField.text;
    }
    
}