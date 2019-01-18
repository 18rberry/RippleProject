//
//  CampaignDetailViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 3/8/17.
//  Copyright © 2017 Make School. All rights reserved.
// Shows the details of a campaign after a user wants to learn more information about a campaign shown on the Map View

import UIKit
import MapKit
import CoreLocation
import Parse

class CampaignDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    //goes back to previous view contorller
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pledgeButton(sender: AnyObject) {
    }
    //ignore this function
    @IBAction func report(sender: AnyObject) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Report", message: "Do you want to flag this campaign", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        let flagAction:UIAlertAction = UIAlertAction(title: "Flag", style: .Default) { action -> Void in
            
        }
        actionSheetController.addAction(flagAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amtNeededLabel: UILabel!
    @IBOutlet weak var amtReceivedLabel: UILabel!
    @IBOutlet weak var briefLabel: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text! = annotation.title!
        titleLabel.text! = annotation.subtitle!
        queryForCampaign()
    }
  
    //queries for the corresponding campaign in Parse Server
    func queryForCampaign(){
        let campaignQuery = Campaign.query()
        campaignQuery?.whereKey("Name", equalTo: annotation.title!)
        campaignQuery?.whereKey("Title", equalTo: annotation.subtitle!)
        campaignQuery?.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            if let result = result {
                for campaign in result {
                    self.briefLabel.text! = "\(campaign.valueForKey("Brief")!)"
                    self.amtNeededLabel.text! = "\(campaign.valueForKey("AmtNeeded")!)"
                    if campaign.valueForKey("amtGotten") == nil {
                        self.amtReceivedLabel.text! = "$0.00"
                    } else {
                         self.amtReceivedLabel.text! = "\(campaign.valueForKey("amtGotten")!)"
                    }
                    let parseLocation = campaign["Location"]
                    let lat: CLLocationDegrees = parseLocation.latitude
                    let long: CLLocationDegrees = parseLocation.longitude
                    let location = CLLocation(latitude: lat, longitude: long)
                    
                    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                        print(location)
        
                        if error != nil {
                            print("Reverse geocoder failed with error" + error!.localizedDescription)
                            return
                        }
                        
                        if placemarks!.count > 0 {
                            let pm = placemarks![0] as! CLPlacemark
                            print(pm.locality)
                            self.locationLabel.text = pm.locality
                        }
                            
                        else {
                            print("Problem with the data received from geocoder")
                        }
                    })
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //sets up for the segue to the next controller by passing information to the next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destViewController: PledgeViewController = segue.destinationViewController as! PledgeViewController
        destViewController.name = nameLabel.text!
        destViewController.campaignTitle = titleLabel.text!
        destViewController.brief = briefLabel.text!
        destViewController.money = amtNeededLabel.text!
        destViewController.amtReceivedText = amtReceivedLabel.text!
    }

    
    var annotation: MKPointAnnotation = MKPointAnnotation()
    //let title = annotation.title


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
