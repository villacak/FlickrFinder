//
//  ViewController.swift
//  FlikrFinder
//
//  Created by Klaus Villaca on 8/28/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import UIKit

class ViewController: ViewControllerWithKeyboardControl, UITextFieldDelegate {
    
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
        let urlToCallTemp = UrlHelper().createSearchByTextRequestURL(searchTextField.text)
        makeRESTCallAndGetResponse(urlToCallTemp)
    }
    
    
    
    @IBAction func latLonSearchButton(sender: UIButton) {
        let urlToCallTemp = UrlHelper().createSearchByLatitudeLogitudeRequestURL(lat: latitudeTextField.text, lon: longitudeTextField.text)
        makeRESTCallAndGetResponse(urlToCallTemp)
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
    
    
    
    // Function to call the service and populate data when response return
    func makeRESTCallAndGetResponse(urlToCall: String) {
        var helperObject: UrlHelper = UrlHelper()
        var photoResult: PhotoResult!
        // Change to false the line bellow and enable the second line to have option to select a picture
        // instead random
        helperObject.isRandom = true
        //        urlHelper.photoIndex = 1
        helperObject.requestSearch(urlToCall, handler: { (result) -> Void in
            if let photoResultTemp = result {
                photoResult = photoResultTemp
                self.imageLoaded.image = photoResult.photoImage
                self.detailsLabel = photoResult.photoTitle
            }
        })
    }
}

