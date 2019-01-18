//
//  NextCampaignViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 2/1/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class NextCampaignViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var briefLabel: UILabel!
    @IBOutlet weak var amtNeededLabel: UILabel!
    @IBOutlet weak var amtReceivedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryForCampaign()

        // Do any additional setup after loading the view.
    }
    
    
    func queryForCampaign(){
        let campaignQuery = Campaign.query()
        campaignQuery?.whereKey("user", equalTo: PFUser.currentUser()!)
        campaignQuery?.orderByDescending("createdAt")
        campaignQuery?.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
            if object != nil {
                if let result = object{
                    self.nameLabel.text = "\(result.valueForKey("Name")!)"
                    let parseLocation = result["Location"]
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

        
                    self.titleLabel.text = "\(result.valueForKey("Title")!)"
                    self.briefLabel.text = "\(result.valueForKey("Brief")!)"
                    self.amtNeededLabel.text = "\(result.valueForKey("AmtNeeded")!)"
                    if result.valueForKey("amtGotten") == nil {
                        self.amtReceivedLabel.text! = "$0.00"
                    } else {
                        self.amtReceivedLabel.text! = "\(result.valueForKey("amtGotten")!)"
                    }
                }
            }
        }
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
