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
    
    
    // Validate lat and lon values
    func validateLatAnLong(latValue latValue: String, lonValue: String, controller: UIViewController) -> Bool {
        var booleanToReturn: Bool = false
        if latValue != "" && lonValue != "" {
            let latFloat: Float = (latValue as NSString).floatValue
            let lonFloat: Float = (lonValue as NSString).floatValue
            if (latFloat <= 90 && latFloat >= -90 && lonFloat <= 180 && lonFloat >= -180) {
                booleanToReturn = true
            }  else {
                okDismissAlert(titleStr: "Lat and Lon Fields", messageStr: "Latitue range must be between -90 and 90 and longitude must be between -180 and 180 degrees.", controller: controller)
            }
        } else {
            okDismissAlert(titleStr: "Lat and Lon Fields", messageStr: "Not allowed search with empty field.", controller: controller)
        }
        return booleanToReturn
    }
    
    
    // Just display an alert, telling the search was empty
    func noResultsAlert(controller: UIViewController) {
        okDismissAlert(titleStr: "Empty Result", messageStr: "The search didn't return any results", controller: controller)
    }
    
    
    // UIAlertDisplay with one ok buttom to dismiss
    func okDismissAlert(titleStr titleStr: String, messageStr: String, controller: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.Alert)
        let okDismiss: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okDismiss)
        controller.presentViewController(alert, animated: true, completion: {})
    }
    
}