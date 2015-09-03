//
//  Utils.swift
//  FlikrFinder
//
//  Created by Klaus Villaca on 8/30/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//


import Foundation
import UIKit


class Utils: NSObject {
    
    // Generate a random number within the range especified
    func ramdomNumber(maxNumberOfElementsReturned: Int) -> Int {
        let numberToUInt32: UInt32 = UInt32(maxNumberOfElementsReturned)
        let tempRamdomNumber: Int = Int(arc4random_uniform(numberToUInt32))
        return tempRamdomNumber
    }
    
    
    // Just display an alert, telling the search was empty
    func noResultsAlert() {
        okDismissAlert("Empty Result", messageStr: "The search didn't return any results")
    }
    
    
    
    // Just display an alert, telling the search was empty
    func wrongLatitudeAlert() {
        okDismissAlert("Wrong Value", messageStr: "The Latitude must be within range of -90 to 90 degrees.")
    }
    
    
    // Just display an alert, telling the search was empty
    func wrongLongitudeAlert() {
        okDismissAlert("Wrong Value", messageStr: "The Latitude must be within range of -180 to 180 degrees.")
    }
    
    
    // UIAlertDisplay with one ok buttom to dismiss
    func okDismissAlert(titleStr: String, messageStr: String) {
        let alert: UIAlertController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.Alert)
        let okDismiss: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okDismiss)
    }
    
}