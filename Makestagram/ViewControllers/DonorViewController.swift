//
//  DonorViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 1/31/17.
//  Copyright © 2017 Make School. All rights reserved.
// This file appears after student's have created a campaign and shows their campaign as a pin annotation on the larger map view

import UIKit
import MapKit
import CoreLocation
import Parse

class DonorViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    //goes to next view controller
    @IBAction func next(sender: AnyObject) {
        self.performSegueWithIdentifier("toStudent", sender: self)
    }
   
    @IBAction func nextAction(sender: AnyObject) {
    }
    
    //goes to previous view controller when back button is pressed
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var lattitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    
    var name: String = ""
    var campaignTitle: String = ""
    var brief: String = ""
    var date = NSDate()
    var money: String = ""
    
    
    let campaign = Campaign()
    //let user = PFUser.currentUser()
 
   
    //have the Location Manager start updating for the user's location
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //animate the map to focus on the User's location
    func animateMap(location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations.last!
        lattitudeLabel.text = String(format: "%.6f", lastLocation.coordinate.latitude)
        longitudeLabel.text = String(format: "%.6f", lastLocation.coordinate.longitude)
        let location = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        
        //Do stuff for the map view to show user's location
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpanMake(0.5, 0.5))
        let regionCenter = region.center
        mapView.setRegion(region, animated: true)
        
        //add annotation at campaign creator's location
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        annotation.coordinate = centerCoordinate
        mapView.addAnnotation(annotation)
        
        let point = PFGeoPoint(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        saveToParse(point)
    }
    
    //save the user's location to the Parse Server
    func saveToParse(point: PFGeoPoint){
        campaign.Name = name
        campaign.Title = campaignTitle
        campaign.Brief = brief
        campaign.date = NSDate()
        campaign.AmtNeeded = money
        campaign.Location = point
        campaign.uploadCampaign()
    }
   
    
    //handle errors with getting the user's location
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors " + error.localizedDescription)
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
