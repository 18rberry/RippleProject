//
//  KeyboardNotificationHandler.swift
//  MakeSchoolNotes
//
//  Created by Benjamin Encz on 2/23/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

@objc(KeyboardNotificationHandler)
public class KeyboardNotificationHandler: NSObject {
  
  public typealias KeyboardHandlerCallback = (CGFloat) -> ()
  
  public var keyboardWillBeHiddenHandler: KeyboardHandlerCallback?
  public var keyboardWillBeShownHandler:  KeyboardHandlerCallback?
  
  public required override init() {
    super.init()
    
    NotificationCenter.default.addObserver(self,
                                           selector: Selector("keyboardWillBeShown:"),
      name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"),
      object: nil
    )
    
    NotificationCenter.default.addObserver(self,
                                           selector: Selector("keyboardWillBeHidden:"),
      name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"),
      object: nil
    )
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  public func keyboardWillBeShown(notification: NSNotification) {
    invokeHandler(notification: notification, callback: keyboardWillBeShownHandler)
  }
  
  public func keyboardWillBeHidden(notification: NSNotification) {
    invokeHandler(notification: notification, callback: keyboardWillBeHiddenHandler)
  }
  
  private func invokeHandler(notification: NSNotification, callback: KeyboardHandlerCallback?) {
    if let info = notification.userInfo, let callback = callback {
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        callback(keyboardFrame.height)
    }
  }
  
}
