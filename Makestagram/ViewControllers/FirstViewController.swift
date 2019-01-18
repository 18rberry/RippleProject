//
//  FirstViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 1/25/17.
//  Copyright © 2017 Make School. All rights reserved.
// Initial page that users are prsented with after logging in or signing up

import UIKit
import MapKit
import CoreLocation
import Parse

class FirstViewController: UIViewController{

    //users will chose this button if they are a student wishing to create a campaign
    @IBAction func studentAction(sender: AnyObject) {
        self.performSegueWithIdentifier("StudentVC", sender: self)
    }
    
    //users will chose this button if they are a donor wishing to pledge money to campaigns
    @IBAction func goToDonor(sender: AnyObject) {
        self.performSegueWithIdentifier("toDonor", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //goes to the Settings View Controller
    @IBAction func goToSettings(sender: AnyObject) {
        self.performSegueWithIdentifier("toSettings", sender: self)
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

}
