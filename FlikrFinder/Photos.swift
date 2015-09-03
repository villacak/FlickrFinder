//
//  Photos.swift
//  FlikrFinder
//
//  Created by Klaus Villaca on 9/2/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import Foundation

class Photos: NSObject {
    
//    <photos page="2" pages="89" perpage="10" total="881">
    var page: String!
    var pages: String!
    var perPage: String!
    var total: String!
    var photoArray: [Photo]!
    
    
    override init() {
        page = ""
        pages = ""
        perPage = ""
        total = ""
        photoArray = []
    }
    
    
    init(page: String, pages: String, perPage: String, total: String, photoArray: [Photo]) {
        self.page = page
        self.pages = pages
        self.perPage = perPage
        self.total = total
        self.photoArray = photoArray
    }

}
