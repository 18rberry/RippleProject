//
//  UITextViewPlaceholderText.swift
//  MakeSchoolNotes
//
//  Created by Benjamin Encz on 2/23/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

public class TextView : UITextView {

  public var placeholderText: String = "Tap to edit"
  
  public required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    initialize()
  }
  
  public override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    initialize()
  }
  
  private func initialize() {
    NotificationCenter.default.addObserver(self,
      selector: "textViewDidBeginEditing:",
      name: NSNotification.Name.UITextViewTextDidBeginEditing,
      object: self)
    
    NotificationCenter.default.addObserver(self,
      selector: "textViewDidEndEditing:",
      name: NSNotification.Name.UITextViewTextDidEndEditing,
      object: self)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override public var text: String! {
    didSet {
        if let text = text, text == "" {
        if (showsPlaceholderText == nil) {
          showsPlaceholderText = true
        }
      } else {
        if (showsPlaceholderText == nil) {
          showsPlaceholderText = false
        }
      }
    }
  }
  
  public var textValue:String {
    get {
        if let showsPlaceholderText = showsPlaceholderText, showsPlaceholderText == true {
          return ""
      } else {
        return text
      }
    }
  }
  
  public private (set) var showsPlaceholderText: Bool? {
    didSet {
      if let showsPlaceholderText = showsPlaceholderText {
        if (showsPlaceholderText == true) {
          textColor = placeHolderTextColor
          text = placeholderText
        } else {
            textColor = UIColor.black
        }
      }
    }
  }
  
    @IBInspectable public var placeHolderTextColor: UIColor = UIColor.lightGray
  
  public func textViewDidEndEditing(notification: NSNotification) {
    self.showsPlaceholderText = (self.text.characters.count == 0)
  }
  
  public func textViewDidBeginEditing(notification: NSNotification) {
    if let showsPlaceholderText = showsPlaceholderText, showsPlaceholderText == true {
        self.showsPlaceholderText = false
        text = ""
    }
  }
  
}
