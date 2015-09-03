//
//  PhotoResult.swift
//  FlikrFinder
//
//  Created by Klaus Villaca on 9/2/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import Foundation
import UIKit

class PhotoResult: NSObject {
    
    var photoImage: UIImage!
    var photoTitle: UILabel!
    var photoDetail: UILabel!
    
    init(photoImage: UIImage, photoTitle: UILabel, photoDetail: UILabel) {
        self.photoImage = photoImage
        self.photoTitle = photoTitle
        self.photoDetail = photoDetail
    }

}
