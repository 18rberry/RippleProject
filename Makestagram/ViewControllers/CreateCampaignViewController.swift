//
//  CreateCampaignViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 2/1/17.
//  Copyright © 2017 Make School. All rights reserved.
// Used for student's to create their campaign

import UIKit
import CoreLocation
import Parse

class CreateCampaignViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBAction func getLocation(sender: AnyObject) {
    }
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var briefField: UITextView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBAction func stepper(sender: UIStepper) {
        let money: String = String(sender.value)
        moneyLabel.text = "$" + money + "0"
    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    let campaign = Campaign()
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        briefField.delegate = self
        briefField.becomeFirstResponder()
        titleField.delegate = self
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //called to create the Campaign
    func createCampaign(){
        campaign.Name = nameField.text
        campaign.Title = titleField.text
        campaign.Brief = briefField.text
        campaign.date = NSDate()
        campaign.AmtNeeded = moneyLabel.text
        campaign.uploadCampaign()
    }
    
    //when the return field is pressed, the keyboard is dismissed
    func textFieldShouldReturn(briefField: UITextField) -> Bool {
        briefField.resignFirstResponder()
        return true
    }

    

    func DismissKeyboard() {
        view.endEditing(true)
    }

    //the code checks several things before performing the segue to go to the next view controller
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "nextPage" {
            // perform your computation to determine whether segue should occur
            
         if self.briefField.text.characters.count == 0 {
                let notPermitted = UIAlertView(title: "Alert", message: "Please enter a brief", delegate: nil, cancelButtonTitle: "OK")
                
                // shows alert to user
                notPermitted.show()
                // prevent segue from occurring
                return false
                
            } else if self.nameField.text?.characters.count == 0 {
                let notPermitted = UIAlertView(title: "Alert", message: "Please enter your name", delegate: nil, cancelButtonTitle: "OK")
                
                // shows alert to user
                notPermitted.show()
                
                // prevent segue from occurring
                return false
            } else if self.titleField.text?.characters.count == 0{
                let notPermitted = UIAlertView(title: "Alert", message: "Please enter a campaign title", delegate: nil, cancelButtonTitle: "OK")
                
                // shows alert to user
                notPermitted.show()
                
                // prevent segue from occurring
                return false
         } else if self.titleField.text?.characters.count >= 45 {
            let notPermitted = UIAlertView(title: "Alert", message: "Your campaign title must be less than 25 characters", delegate: nil, cancelButtonTitle: "OK")
            
            // shows alert to user
            notPermitted.show()
            
            // prevent segue from occurring
            return false
            }
            //createCampaign()
            return true
        }
        
        // by default perform the segue transitio
        return true
        
    }
    
    //prepares for going to the next View Controller by passing data from this view controller to the next one
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destViewController: DonorViewController = segue.destinationViewController as! DonorViewController
        destViewController.name = nameField.text!
        destViewController.campaignTitle = titleField.text!
        destViewController.brief = briefField.text
        destViewController.money = moneyLabel.text!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    //stops students from typing in the title field if their character count exceeds 25 characters
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 25
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
