//
//  PledgeViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 3/15/17.
//  Copyright © 2017 Make School. All rights reserved.
// Allows donors to pledge money to a certain campaign of their choice 

import UIKit
import Parse

class PledgeViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tipButton: UIButton!
    @IBAction func btn_box(sender: UIButton) {
        if (sender.selected == true)
        {
            sender.setBackgroundImage(UIImage(named: "checked box"), forState: UIControlState.Normal)
            sender.selected = false;
        }
        else
        {
            sender.setBackgroundImage(UIImage(named: "unchecked box"), forState: UIControlState.Normal)
            sender.selected = true;
        }
    }
    
    let campaign = Campaign()
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var amtNeeded: UILabel!
    @IBOutlet weak var amtReceived: UILabel!
    
    //function for the stepper that donors press to increase or decrease the amount of money they are pledging
    @IBAction func stepper(sender: UIStepper) {
        let money: String = String(sender.value)
        moneyLabel.text = "$" + money + "0"
    }

    //called when donor's press the done button
    @IBAction func doneButton(sender: AnyObject) {
        //if the tip button is not selected (default is selected, so that means it is selected), pass on to the next function that the check box for taking a 10% tip is selected
        if self.tipButton.selected != true{
            showAlert("selected")
        } else{
            showAlert("not selected")
        }
    }
    
    //goes to previous view controller
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        amtReceived.text! = amtReceivedText
        amtNeeded.text! = money
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard() {
        view.endEditing(true)
    }
    
    //asks donors to confirm their pledge before going to the next view controller
    func showAlert(selected: String){
        if selected == "selected"{
            let newString: String! = self.moneyLabel.text!
            let index2 = newString.startIndex.advancedBy(1)
            let money = newString.substringFromIndex(index2)
            var currentValue: Double = Double(money)!
            
            //add the 10% to the donor's pledge
            let tipAmount = 0.1 * currentValue
            currentValue = currentValue + tipAmount
            
            let finalAmount: String = "$" + "\(currentValue)" + "0"
            
            let actionSheetController = UIAlertController(title: "Pledge", message: "Please confirm your pledge of " + "\(finalAmount)", preferredStyle: .Alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel){ action -> Void in
            }
            actionSheetController.addAction(cancelAction)
            let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                self.campaignQuery()
                self.alertTwo()
            }
            actionSheetController.addAction(nextAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        } else if selected == "not selected" {
            let newString: String! = self.moneyLabel.text!
            
            let actionSheetController = UIAlertController(title: "Pledge", message: "Please confirm your pledge of " + newString, preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel){ action -> Void in
            }
            actionSheetController.addAction(cancelAction)
            let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                self.campaignQuery()
                self.alertTwo()
            }
            actionSheetController.addAction(nextAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
    
    //asks donors if they would like to continue to next page after confirming their pledge amount
    func alertTwo(){
        let actionSheetController = UIAlertController(title: "Continue", message: "Would you like to continue to the next page?", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel){ action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action in self.performSegueWithIdentifier("toMain", sender: self)
        }
        actionSheetController.addAction(nextAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

    var name: String = ""
    var campaignTitle: String = ""
    var brief: String = ""
    var money: String = ""
    var amtReceivedText: String = ""
    
    //saves the data about how much the donor will pledge to the Parse Server
    func campaignQuery(){
        let campaignQuery = Campaign.query()
        campaignQuery?.whereKey("Name", equalTo: name)
        campaignQuery?.whereKey("Title", equalTo: campaignTitle)
        campaignQuery?.whereKey("Brief", equalTo: brief)
        campaignQuery?.whereKey("AmtNeeded", equalTo: money)
        campaignQuery?.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
        if object != nil {
            if let result = object{
                if result.valueForKey("amtGotten") == nil{
                    result.setValue(self.moneyLabel.text, forKey: "amtGotten")
                    result.saveInBackground()
                    let printable = result.valueForKey("amtGotten")
                    print(printable)
                } else {
                    //convert current value for amtGotten in Parse into a double
                    let str: String! = "\(result.valueForKey("amtGotten")!)"
                    let index1 = str.startIndex.advancedBy(1)
                    let subString = str.substringFromIndex(index1)
                    let previousValue: Double = Double(subString)!
                    
                    //convert pledge value just submitted by user into a double
                    let newString: String! = self.moneyLabel.text!
                    let index2 = newString.startIndex.advancedBy(1)
                    let money = newString.substringFromIndex(index2)
                    var currentValue: Double = Double(money)!
                    
                    if self.tipButton.selected == true {
                        let tipAmount = 0.1 * currentValue
                        currentValue = currentValue + tipAmount
                    }
                    
                    //add previous pledge value to current and save to parse
                    let parseValue: Double = previousValue + currentValue
                    let finalValue: String = "$" + "\(parseValue)" + "0"
                    result.setValue(finalValue, forKey: "amtGotten")
                    result.saveInBackground()
                    let printable = result.valueForKey("amtGotten")!
                    print(printable)
                }
                }
            }
        }
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
