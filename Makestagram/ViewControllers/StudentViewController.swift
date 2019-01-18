//
//  StudentViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 1/30/17.
//  Copyright © 2017 Make School. All rights reserved.
// Students can either create a campaign or view the progress of their previous campaigns

import UIKit

class StudentViewController: UIViewController {

    //allows students to creata a campaign
    @IBAction func createCampaign(sender: AnyObject) {
        self.performSegueWithIdentifier("createCampaign", sender: self)
    }
    
    //goes to previous view controller
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //shows students a feed of their previous campaigns so they can track each campaign's progress
    @IBAction func campaignProgress(sender: AnyObject) {
    self.performSegueWithIdentifier("campaignProgress", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before na
    vigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
