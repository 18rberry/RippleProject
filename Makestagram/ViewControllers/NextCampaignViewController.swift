//
//  NextCampaignViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 2/1/17.
//  Copyright © 2017 Make School. All rights reserved.
// provides a feed of all the student's previous campaigns so students can see the progress of each campaign

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
    
    var campaigns: [Campaign] = []
    var allCampaigns: [Campaign]?
    
    @IBOutlet weak var tableView: UITableView!
   
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        tableView.delegate = self
        queries()
        self.tableView.reloadData()
        self.tableView.scrollEnabled = true
    }
    
    //queries for data from the Parse Server to create the feed
    func queries(){
        if campaigns.count == 0{
            let campaignQueryInChronoOrder = Campaign.query()
            campaignQueryInChronoOrder?.whereKey("user", equalTo: PFUser.currentUser()!)
            campaignQueryInChronoOrder?.orderByDescending("createdAt")
            campaignQueryInChronoOrder!.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
                self.campaigns = result as? [Campaign] ?? []
                print("just set posts in chrono order to " + String(self.campaigns.count))
                self.allCampaigns = self.campaigns
                self.tableView.reloadData()
            }
        }
    }
    
    let campaign = Campaign()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        ParseHelper.campaignRequestForCurrentUser {
//            (result: [PFObject]?, error: NSError?) -> Void in
//            self.campaigns = result as? [Campaign] ?? []
//            
//            for campaign in self.campaigns {
//                do {
//                    //let data = try campaign.imageFile?.getData()
//                    //campaign.image = UIImage(data: data!, scale:1.0)
//                } catch {
//                    print("could not get image")
//                }
//            }
//            
//            self.tableView.reloadData()
//        }
    }
    
    
//    func queryForCampaign(){
//        let campaignQuery = Campaign.query()
//        campaignQuery?.whereKey("user", equalTo: PFUser.currentUser()!)
//        campaignQuery?.orderByDescending("createdAt")
//        campaignQuery?.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
//            if object != nil {
//                if let result = object{
//                    self.nameLabel.text = "\(result.valueForKey("Name")!)"
//                    let parseLocation = result["Location"]
//                    let lat: CLLocationDegrees = parseLocation.latitude
//                    let long: CLLocationDegrees = parseLocation.longitude
//                    let location = CLLocation(latitude: lat, longitude: long)
//                    
//                    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
//                        print(location)
//                        
//                        if error != nil {
//                            print("Reverse geocoder failed with error" + error!.localizedDescription)
//                            return
//                        }
//                        
//                        if placemarks!.count > 0 {
//                            let pm = placemarks![0] as! CLPlacemark
//                            print(pm.locality)
//                            self.locationLabel.text = pm.locality
//                        }
//                            
//                        else {
//                            print("Problem with the data received from geocoder")
//                        }
//                    })
//
//        
//                    self.titleLabel.text = "\(result.valueForKey("Title")!)"
//                    self.briefLabel.text = "\(result.valueForKey("Brief")!)"
//                    self.amtNeededLabel.text = "\(result.valueForKey("AmtNeeded")!)"
//                    if result.valueForKey("amtGotten") == nil {
//                        self.amtReceivedLabel.text! = "$0.00"
//                    } else {
//                        self.amtReceivedLabel.text! = "\(result.valueForKey("amtGotten")!)"
//                    }
//                }
//            }
//        }
//    }

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

extension NextCampaignViewController: UITableViewDelegate {
    
    //    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //        if (editingStyle == .Delete) {
    //            if (post.user != PFUser.currentUser()) {
    //                let post = posts[indexPath.row] as Post
    //                println(self.post)
    //                post.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
    //                    self.post.delete()
    //
    //                })
    //                posts.removeAtIndex(indexPath.row)
    //                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    //
    //
    //            }
    //        }
    //
    //    }
    
    //func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //}
    //
    //func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //    return false
    //}
    
}

//extension for the Table View Data Source
extension NextCampaignViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return campaigns.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell") as! CampaignTableViewCell
        let p = allCampaigns
        
        if (p != nil) {
            var cellPost = p![indexPath.row] as Campaign
            cell.campaign = cellPost
            cell.timeline = self
            //cell.replyQuery()
        }
        return cell
    }
}

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }
