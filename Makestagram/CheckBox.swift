//
//  CheckBox.swift
//  Makestagram
//
//  Created by Riya Berry on 4/24/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    let checkedImage = UIImage(named: "checked box")! as UIImage
    let uncheckedImage = UIImage (named: "unchecked box")! as UIImage
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false 
    }
    
    func buttonClicked(sender: UIButton) {
        if (sender == self){
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
}
