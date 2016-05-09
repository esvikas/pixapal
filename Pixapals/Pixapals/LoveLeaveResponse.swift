//
//  LoveLeaveResponse.swift
//  Pixapals
//
//  Created by DARI on 2/4/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation
import ObjectMapper

class SuccessFailJSON: Mappable {
    var code: Int?
    var error: Bool?
    var message: String?
    var user: UserJSON?
    
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map) {
        code <- map["code"]
        error <- map["error"]
        message <- map["message"]
        user <- map["user"]
        if let user = user {
            self.user = UserFeedDistinction.sharedInstance.checkDistinctUser(user)
        }
    }
}

class ReportResponseJSON: Mappable {
    var code: Int?
    var error: Bool?
    var message = [String]()
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map) {
        code <- map["code"]
        error <- map["error"]
        message <- map["message"]
    }
}