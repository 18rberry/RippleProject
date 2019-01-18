//
//  SettingsViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 4/15/17.
//  Copyright © 2017 Make School. All rights reserved.
// This view controller provides the settings and additional information

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //goes to the View Controller Containing legal information
    @IBAction func toLegal(sender: AnyObject) {
        self.performSegueWithIdentifier("toLegal", sender: self)
    }

    //returns to previous view controller
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
