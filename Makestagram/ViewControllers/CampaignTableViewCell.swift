//
//  CampaignTableViewCell.swift
//  Makestagram
//
//  Created by Riya Berry on 4/6/17.
//  Copyright © 2017 Make School. All rights reserved.
// File for the Table View Cell in the feed of the user's previous posts

import UIKit
import Bond
import Parse

class CampaignTableViewCell: UITableViewCell {
    
    var campaigns: [Campaign]?
    var campaignDisposable: DisposableType?
    weak var timeline: NextCampaignViewController?
    
    @IBOutlet weak var campaignTitle: UILabel!
    @IBOutlet weak var brief: UITextView!
    @IBOutlet weak var MoneyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //did Set method
    var campaign: Campaign? {
        didSet {
            campaignDisposable?.dispose()
            if let campaign = campaign{
                self.campaignTitle.text = campaign.Title
                self.brief.text = campaign.Brief
                self.dateLabel.text = campaign.createdAt?.shortTimeAgoSinceDate(NSDate()) ?? ""
                if campaign.amtGotten == nil{
                    self.MoneyLabel.text = "$0.00 / " + campaign.AmtNeeded!
                } else {
                    self.MoneyLabel.text = campaign.amtGotten! + " / " + campaign.AmtNeeded!
                }
                
            } else {
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
