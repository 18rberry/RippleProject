//
//  Post.swift
//  TemplateProject
//
//  Created by Riya Berry on 7/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Foundation
import Bond
import Parse
import ConvenienceKit

class Campaign: PFObject, PFSubclassing {
    @NSManaged var Name: String?
    @NSManaged var user: PFUser?
    @NSManaged var Title: String?
    @NSManaged var Brief: String?
    @NSManaged var AmtNeeded: String?
    @NSManaged var date: NSDate
    @NSManaged var Location: PFGeoPoint?
    @NSManaged var amtGotten: String?
    
    //create the Class Name
    static func parseClassName() -> String {
        return "Campaign"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    //function for uploading the campaign to the parse server
    func uploadCampaign() {
        user = PFUser.currentUser()
        saveInBackgroundWithBlock(nil)
        //print("campaign uploaded")
    }
    
    //function for flagging campaign, yet was not implemented
    func flagCampaign(user: PFUser) {
        ParseHelper.flagCampaign(user, campaign: self)
    }
    
}
