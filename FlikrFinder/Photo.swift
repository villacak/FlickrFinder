//
//  Photo.swift
//  FlikrFinder
//
//  Created by Klaus Villaca on 9/2/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import Foundation

class Photo: NSObject {
    
//    <photo id="2636" owner="47058503995@N01"
//    secret="a123456" server="2" title="test_04"
//    ispublic="1" isfriend="0" isfamily="0" />
    
    var id: String!
    var owner: String!
    var secret: String!
    var server: String!
    var title: String!
    var isPublic: String!
    var isFriend: String!
    var isFamily: String!
    
    
    override init() {
        id = ""
        owner = ""
        secret = ""
        server = ""
        title = ""
        isPublic = ""
        isFriend = ""
        isFamily = ""
    }
    
    
    init(id: String, owner: String, secret: String, server: String, title: String, isPublic: String, isFriend: String, isFamily: String) {
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
