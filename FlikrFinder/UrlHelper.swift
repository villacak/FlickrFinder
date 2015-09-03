//
//  UrlHelper.swift
//  FlikrFinder
//
//  Created by Klaus Villaca on 8/31/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import Foundation


class UrlHelper: NSObject {
    
    // Standard parts for URL formation
    let URL_SEARCH_BASE: String = "https://api.flickr.com/services/rest/?"
    let URL_METHOD_SEARCH: String = "flickr.photos.search"
    let URL_KEY_API: String = "c2589f04f4ec12443e4a919390aa4e1c"
    let URL_JSON_FORMAT: String = "json"
    let URL_CALL_BACK: String = "1"
    
    // Empty String
    let EMPTY_STRING: String = ""
    
    // Keys used in the URL params
    let METHOD_DIC_KEY: String = "method"
    let API_DIC_KEY: String = "api_key"
    let TEXT_DIC_LEY: String = "text"
    let FORMAT_DIC_KEY: String = "format"
    let CALLBACK_DIC_KEY: String = "nojsoncallback"
    
    
    // REST Call Methods
    let GET_METHOD = "GET"
    let POST_METHOD = "POST"
    let PUT_METHOD = "PUT"
    let DELETE_METHOD = "DELETE"
    
    // Get Random
    var isRandom: Bool = false
    var photoIndex: Int = 0
    
    let EMPTY_DICTIONARY: Int = 1
    
    // Encode the Dictionary Strings
    func encodeParameters(#params: [String: String]) -> String {
        var queryItems = map(params) { NSURLQueryItem(name:$0, value:$1)}
        var components = NSURLComponents()
        components.queryItems = queryItems
        return components.percentEncodedQuery ?? EMPTY_STRING
    }
    
    
    
    // Assemble the Search with text url to perform a request
    func createSearchRequestURL(textToSend: String) -> String {
        let urlParamsDictionary: Dictionary<String, String>  = [METHOD_DIC_KEY : URL_METHOD_SEARCH,
            API_DIC_KEY : URL_KEY_API,
            TEXT_DIC_LEY: textToSend,
            FORMAT_DIC_KEY : URL_JSON_FORMAT,
            CALLBACK_DIC_KEY : URL_CALL_BACK]
        let encodedParamsString = encodeParameters(params: urlParamsDictionary)
        let urlToCall: String = URL_SEARCH_BASE + encodedParamsString
        return urlToCall
    }
    
    
    
    // Make a GET request call from a url as string
    func requestGETCall(urlToCall: String) -> PhotoResult {
        var toReturn: PhotoResult!
        var request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: urlToCall)
        request.HTTPMethod = GET_METHOD
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            
            if (jsonResult != nil) {
                let jsonObject: AnyObject = self.parseNSDictionaryToJSON(jsonResult)
                if (jsonResult.count > 1) {
                    toReturn = self.requestGetPhoto(jsonObject, itemsCount: jsonResult.count)
                }
            } else {
                Utils().okDismissAlert(error.debugDescription, messageStr: "No Results Found")
            }
        })
        return toReturn
    }
    
    
    
    // Parse NSDictionary to AnyObject - JSON
    func parseNSDictionaryToJSON(nsDictionary: NSDictionary) -> AnyObject {
        let bytes: NSData = NSJSONSerialization.dataWithJSONObject(nsDictionary, options: NSJSONWritingOptions.allZeros, error: nil)!
        let jsonObj: AnyObject = NSJSONSerialization.JSONObjectWithData(bytes, options: nil, error: nil) as! [NSDictionary]
        return jsonObj
    }
    
    
    
    // Return the PhotoResult populated
    func requestGetPhoto(photo: AnyObject, itemsCount: Int) -> PhotoResult {
        if (isRandom) {
            photoIndex = Utils().ramdomNumber(itemsCount)
        } else {
            if (photoIndex == 0 || (photoIndex >= 1 && photoIndex <= itemsCount)) {
                photoIndex++
            }
        }

        let urlToCall: String = assembleUrlToLoadImage(photo[photoIndex])
        var request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: urlToCall)
        request.HTTPMethod = GET_METHOD
    }
    
    
    
    // ASsemble the URL to load the images as per link: https://www.flickr.com/services/api/flickr.photos.search.html
    func assembleUrlToLoadImage(jsonItem: AnyObject) -> String {
        var urlToReturn: String!
        
        
    }
    
}