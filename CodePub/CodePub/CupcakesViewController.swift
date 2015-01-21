//
//  CupcakesViewController.swift
//  CodePub
//
//  Created by Susanne Moseby on 21/01/15.
//  Copyright (c) 2015 codepub. All rights reserved.
//

import UIKit

class CupcakesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cupcakesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.purpleColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.cupcakesTableView.dequeueReusableCellWithIdentifier("cupcakeCell", forIndexPath: indexPath) as UITableViewCell

        let number = arc4random_uniform(5)+1
        
        var imageView = cell.viewWithTag(1) as? UIImageView
        imageView?.image = UIImage(named: "ck\(number).jpg")
        imageView?.alpha = 0.9
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 99;
    }

}
