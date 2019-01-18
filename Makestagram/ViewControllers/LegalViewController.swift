//
//  LegalViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 4/17/17.
//  Copyright © 2017 Make School. All rights reserved.
// File for the legal information for the App - Contains the End User Liscence agreement, which users' agree to by the act of downloading the app

import UIKit

class LegalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //takes the users to their previous view controller 
    @IBAction func backButton(sender: AnyObject) {
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
