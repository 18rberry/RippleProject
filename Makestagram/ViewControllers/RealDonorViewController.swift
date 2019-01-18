//
//  RealDonorViewController.swift
//  Makestagram
//
//  Created by Riya Berry on 3/2/17.
//  Copyright © 2017 Make School. All rights reserved.
// View Controller that presents a Map View where all the campaigns are tagged as Point Annotations so the Donor can browse campaigns by location

import UIKit
import MapKit
import CoreLocation
import Parse

class RealDonorViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var searchController:UISearchController!
    var annotationFinal: MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var error: NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!

    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //search Bar that enables users to search a location in the search bar and the screen will zoom into the corresponding search area
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let lastLocation: CLLocation = locations.last!
//        let location = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
//        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpanMake(1, 1))
//        let regionCenter = region.center
//        mapView.setRegion(region, animated: true)
        queryForCampaigns()
        mapView.addAnnotations(annotations)
        //locationManager.stopUpdatingLvartion()
    }
    
    //query for the corresponding campaign in Parse Server
    func queryForCampaigns(){
        let campaignQuery = Campaign.query()
        campaignQuery?.findObjectsInBackgroundWithBlock {(results: [PFObject]?, error: NSError?) -> Void in
            if let results = results {
                for campaign in results {
                    let parseLocation = campaign.valueForKey("Location")
                    let location = CLLocation(latitude: (parseLocation?.latitude)!, longitude: (parseLocation?.longitude)!)
                    let annotation = MKPointAnnotation()
                    let centerCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    annotation.coordinate = centerCoordinate
                    annotation.subtitle = "\(campaign.valueForKey("Title")!)"
                    let name = "\(campaign.valueForKey("Name")!)"
                    annotation.title = name
                    self.annotations.append(annotation)
                }
            }
        }
    }

    //deal with errors in location
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors " + error.localizedDescription)
    }
    
    //provides the View for the map annotation - if you click on an annotation you will be able to see more information
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.pinColor = .Red
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        return pin
    }
    
    var selectedAnnotation: MKPointAnnotation!
    
    //goes to the next view controller after clicking on more information on a point annotation
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            selectedAnnotation = annotationView.annotation as? MKPointAnnotation
            performSegueWithIdentifier("NextScene", sender: self)
            print("it worked!")
        }
    }
    
    //prepares for segue by passing information to the next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? CampaignDetailViewController {
            destination.annotation = selectedAnnotation
        }
    }
    
    //deals with searching for locations in the search bar 
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotationFinal = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotationFinal)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler {(localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place not found", preferredStyle: .Alert)
                
                let dismissAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Default) { action -> Void in }
                alertController.addAction(dismissAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            let region = MKCoordinateRegion(center: self.pointAnnotation.coordinate, span: MKCoordinateSpanMake(10, 10))
            let regionCenter = region.center
            self.mapView.setRegion(region, animated: true)
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
