//
//  UrlHelper.swift
//  FlikrFinder
//
//  Created by Klaus Villaca on 8/31/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import Foundation
import UIKit


class UrlHelper: NSObject { //, NSURLConnectionDelegate {
    
    // Standard parts for URL formation
    let URL_SEARCH_BASE: String = "https://api.flickr.com/services/rest/?"
    let URL_METHOD_SEARCH: String = "flickr.photos.search"
    let URL_KEY_API: String = "c2589f04f4ec12443e4a919390aa4e1c"
    let URL_JSON_FORMAT: String = "json"
    let URL_CALL_BACK: String = "1"
    let URL_EXTRAS: String = "url_m"
    
    // Empty String
    let EMPTY_STRING: String = ""
    
    // Keys used in the URL params
    let METHOD_DIC_KEY: String = "method"
    let API_DIC_KEY: String = "api_key"
    let TEXT_DIC_LEY: String = "text"
    let FORMAT_DIC_KEY: String = "format"
    let CALLBACK_DIC_KEY: String = "nojsoncallback"
    let EXTRAS: String = "extras"
    let LATITUDE: String = "lat"
    let LONGITUDE: String = "lon"
    
    
    // REST Call Methods
    let GET_METHOD = "GET"
    let POST_METHOD = "POST"
    let PUT_METHOD = "PUT"
    let DELETE_METHOD = "DELETE"
    
    // Get Random
    var isRandom: Bool = false
    var photoIndex: Int = 0
    
    let EMPTY_DICTIONARY: Int = 1
    
    var photoResultReturn: PhotoResult?
    
    
    // Encode the Dictionary Strings
    func encodeParameters(params params: [String: String]) -> String {
        let queryItems = params.map { NSURLQueryItem(name:$0, value:$1)}
        let components = NSURLComponents()
        components.queryItems = queryItems
        return components.percentEncodedQuery ?? EMPTY_STRING
    }
    
    
    
    // Assemble the Search with text url to perform a request for the search photo using a text
    func createSearchByTextRequestURL(textToSend: String) -> String {
        let urlParamsDictionary: Dictionary<String, String>  = [METHOD_DIC_KEY : URL_METHOD_SEARCH,
            API_DIC_KEY : URL_KEY_API,
            TEXT_DIC_LEY: textToSend,
            FORMAT_DIC_KEY : URL_JSON_FORMAT,
            CALLBACK_DIC_KEY : URL_CALL_BACK]
        let encodedParamsString = encodeParameters(params: urlParamsDictionary)
        let urlToCall: String = URL_SEARCH_BASE + encodedParamsString
        return urlToCall
    }
    
    
    // Assemble the Search with text url to perform a request for the search photo using a latitude and longitude
    func createSearchByLatitudeLogitudeRequestURL(lat lat: String, lon: String) -> String {
        let urlParamsDictionary: Dictionary<String, String>  = [METHOD_DIC_KEY : URL_METHOD_SEARCH,
            API_DIC_KEY : URL_KEY_API,
            LATITUDE: lat,
            LONGITUDE: lon,
            FORMAT_DIC_KEY : URL_JSON_FORMAT,
            CALLBACK_DIC_KEY : URL_CALL_BACK]
        let encodedParamsString = encodeParameters(params: urlParamsDictionary)
        let urlToCall: String = URL_SEARCH_BASE + encodedParamsString
        return urlToCall
    }
    
    
    
    // Parse NSDictionary to AnyObject - JSON
    func parseNSDictionaryToJSON(nsDictionary: NSDictionary) -> AnyObject {
        let bytes: NSData = try! NSJSONSerialization.dataWithJSONObject(nsDictionary, options: NSJSONWritingOptions())
        let jsonObj: AnyObject = (try! NSJSONSerialization.JSONObjectWithData(bytes, options: [])) as! NSDictionary
        return jsonObj
    }
    
    
    
    // Populate Photo object
    func populatePhoto(jsonObj: AnyObject) -> Photo {
        let photoObjectToReturn: Photo = Photo()
        photoObjectToReturn.farm = String((jsonObj["farm"] as? Int)!)
        photoObjectToReturn.id = jsonObj["id"]! as? String
        photoObjectToReturn.owner = jsonObj["owner"]! as? String
        photoObjectToReturn.secret = jsonObj["secret"]! as? String
        photoObjectToReturn.server = jsonObj["server"]! as? String
        photoObjectToReturn.title = jsonObj["title"]! as? String
        photoObjectToReturn.isPublic = String((jsonObj["ispublic"]! as? Int)!)
        photoObjectToReturn.isFriend = String((jsonObj["isfriend"]! as? Int)!)
        photoObjectToReturn.isFamily = String((jsonObj["isfamily"]! as? Int)!)
        return photoObjectToReturn
    }
    
    
    
    // ASsemble the URL to load the images as per link: https://www.flickr.com/services/api/flickr.photos.search.html
    func assembleUrlToLoadImageFromSearch(item: Photo) -> String {
        // URL to forms : https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        let urlToReturn: String = "https://farm\(item.farm!).staticflickr.com/\(item.server!)/\(item.id!)_\(item.secret!).jpg"
        return urlToReturn
    }
    
    
    
    // Make a POST request call from a url as string, this function is for the search by a text
    func requestSearch(urlToCall urlToCall: String, completionHandler:(result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask  {
        let url: NSURL = NSURL(string: urlToCall)!
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = POST_METHOD
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let jsonResult: NSDictionary? = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    self.requestPhoto(jsonResult!, itemsCount: jsonResult!.count, handler: { (result) -> Void in
                        if let _ = result {
                            completionHandler(result: self.photoResultReturn, error: nil)
                        } else {
                            completionHandler(result: nil, error: nil)
                        }
                        
                    })
                } catch let error as NSError {
                    completionHandler(result: nil, error: error.localizedDescription)
                }
            } else if let error = error {
                completionHandler(result: nil, error: error.localizedDescription)
            }
        })
        task.resume()
        return task
        
    }
    
    
    
    
    // Return the PhotoResult populated
    func requestPhoto(photos: AnyObject, itemsCount: Int, handler:(result: Bool?)-> Void) {
        if (photoIndex == 0 || (photoIndex >= 1 && photoIndex <= itemsCount)) {
            if (isRandom) {
                photoIndex = Utils().ramdomNumber(itemsCount)
            }
            
            let jsonPhotos: [String : AnyObject] = photos["photos"] as! [String : AnyObject]
            let arrayDictionaryPhoto: [[String : AnyObject]] = jsonPhotos["photo"] as! [[String : AnyObject]]//[NSDictionary]
            
            if (arrayDictionaryPhoto.count > 0) {
                let photoObj: Photo = populatePhoto(arrayDictionaryPhoto[photoIndex])
                let urlToCall: String = assembleUrlToLoadImageFromSearch(photoObj)
                
                let url: NSURL = NSURL(string: urlToCall)!
                if let imageData = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue(), {
                        let imageTemp: UIImage = UIImage(data: imageData)!
                        let titleLabel: UILabel = UILabel()
                        let photoDetailLabel: UILabel = UILabel()
                        titleLabel.text = photoObj.title
                        photoDetailLabel.text = self.EMPTY_STRING
                        self.photoResultReturn = PhotoResult(photoImage: imageTemp, photoTitle: titleLabel, photoDetail: photoDetailLabel)
                        handler(result: true)
                    })
                }
            } else {
                handler(result: false)
                print("No Result Found")
            }
        }
    }
    
    
    
}