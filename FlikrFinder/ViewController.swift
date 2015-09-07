//
//  ViewController.swift
//  FlikrFinder
//
//  Created by Klaus Villaca on 8/28/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import UIKit

class ViewController: ViewControllerWithKeyboardControl, UITextFieldDelegate, NSURLConnectionDelegate {
    
    @IBOutlet weak var imageLoaded: UIImageView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchLatLonButton: UIButton!
    
    
    let PHRASE_SEARCH: String = "Phrase Text Field"
    let LATITUDE: String = "Latitude"
    let LONGITUDE: String = "Longitude"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        
        searchTextField.text = "ball";
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // Keyboard notify notification center the keyboard will show
    func keyboardWillShow(notification: NSNotification) {
        if (view.frame.origin.y >= 0 &&
            (searchTextField.isFirstResponder() || latitudeTextField.isFirstResponder() || longitudeTextField.isFirstResponder())) {
                view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    // Keyboard notify notification center the keyboard will hide
    func keyboardWillHide(notification: NSNotification) {
        if (view.frame.origin.y <= 0 && (searchTextField.isFirstResponder() || latitudeTextField.isFirstResponder() || longitudeTextField.isFirstResponder())) {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    
    
    @IBAction func phraseSearchButton(sender: UIButton) {
        var urlHelper: UrlHelper = UrlHelper()
        // Change to false the line bellow and enable the second line to have option to select a picture
        // instead random
        urlHelper.isRandom = true
        //        urlHelper.photoIndex = 1
        var photoResult: PhotoResult!
        let urlToCallTemp = urlHelper.createSearchByTextRequestURL(searchTextField.text)
        urlHelper.requestSearchByText(urlToCallTemp, handler: { (result) -> Void in
            if let photoResultTemp = result {
                photoResult = photoResultTemp
                self.imageLoaded.image = photoResult.photoImage
            }
        })
    }
    
    
    
    @IBAction func latLonSearchButton(sender: UIButton) {
        // make the search by lat. and lon.
    }
    
    
    // Check for what field (UITextView) has data and what doesn't, enabling and disabiling fields and buttons
    func checkStringsForNotEmpty(uiTextField: UITextField) {
        searchButton.enabled = false
        searchLatLonButton.enabled = false
        if uiTextField.text != nil {
            if uiTextField.placeholder == PHRASE_SEARCH {
                searchButton.enabled = true
            } else if uiTextField.placeholder == LATITUDE && uiTextField.placeholder == LONGITUDE {
                searchLatLonButton.enabled = true
            }
        }
    }
}

