//
//  Photo.swift
//  FlikrFinder
//
//  Created by Klaus Villaca on 9/2/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import Foundation

class Photo: NSObject {
    
   
    var farm: String?
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var title: String?
    var isPublic: String?
    var isFriend: String?
    var isFamily: String?
    
    
    override init() {
        farm = ""
        id = ""
        owner = ""
        secret = ""
        server = ""
        title = ""
        isPublic = ""
        isFriend = ""
        isFamily = ""
    }
    
    
    init(farm: String, id: String, owner: String, secret: String, server: String, title: String, isPublic: String, isFriend: String, isFamily: String) {
        self.farm = farm
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.title = title
        self.isPublic = isPublic
        self.isFriend = isFriend
        self.isFamily = isFamily
    }

}
