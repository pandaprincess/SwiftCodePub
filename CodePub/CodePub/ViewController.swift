//
//  ViewController.swift
//  CodePub
//
//  Created by Susanne Moseby on 21/01/15.
//  Copyright (c) 2015 codepub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.topLabel.text = "HELLO"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func buttonClicked(sender: AnyObject) {
        let red = CGFloat(Float(arc4random()/1000000000))*100/255
        let blue = CGFloat(Float(arc4random()/1000000000))*100/255
        let green = CGFloat(Float(arc4random()/1000000000))*100/255
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        self.view.backgroundColor = randomColor
    }
}

