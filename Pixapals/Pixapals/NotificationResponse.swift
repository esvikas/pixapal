//
//  NotificationResponse.swift
//  Pixapals
//
//  Created by DARI on 2/18/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class NotificationResponseJSON: Mappable {
    var notifications: [NotificationJSON]?
    var message: String?
    var error: Bool!
    var code: Int!
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        error  <- map["error"]
        message <- map["message"]
        code <- map["code"]
        notifications <- map["notification"]
    }
}

class NotificationJSON: Mappable {
    var action: String?
    var user: NotificationItemJSON?
    var item2: NotificationItemJSON?
    var message: String?
    var created_at: CreatedAt?
    
    required init?(_ map: Map){
        
    }
    func mapping(map: Map) {
        action  <- map["action"]
        user <- map["fed_details"]
        if user == nil {
            user <- map["user"]
        }
        item2 <- map["follower_details"]
        if item2 == nil {
            item2 <- map["post"]
        }
        message <- map["message"]
        created_at <- map["created_at"]
        //x <- map["created_at", "date"]
        //print(x)
    }
}

class CreatedAt: Mappable {
    var created_at: NSDate?
    var timezone: String?
    var timezone_type: Int?
    private var _created_at: String? {
        get {
            return nil
        }
        set {
            let dateConverter = DateConverter()
            var y = newValue
            y!.replaceRange(y!.endIndex.advancedBy(-7)...y!.endIndex.advancedBy(-1),
                with: "")
            self.created_at = dateConverter.convertDateFromStringToPhoneTimeZone(y!)
        }
    }
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        _created_at <- map["date"]
        timezone <- map["timezone"]
        timezone_type <- map["timezone_type"]
    }
}

class NotificationItemJSON: Mappable {
    var id: Int?
    var photo_thumb: String?
    var username: String?
    var isUser = false
    
    required init?(_ map: Map){
        
    }
    func mapping(map: Map) {
        id  <- map["id"]
        photo_thumb <- map["photo_thumb"]
        username <- map["username"]
        if let _ = username {
            isUser = true
        }
    }
    
}