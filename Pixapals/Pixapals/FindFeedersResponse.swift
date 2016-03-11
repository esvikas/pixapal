//
//  FindFeedersResponse.swift
//  Pixapals
//
//  Created by DARI on 3/10/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation
import ObjectMapper
class FeedersFriendsJSON: Mappable {
    var error = true
    var users : [UserJSON]?
    var message: [String]?
    
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.error <- map["error"]
        self.users <- map["users"]
        self.message <- map["message"]
    }
}