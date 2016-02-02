//
//  FeedsResponse.swift
//  Pixapals
//
//  Created by DARI on 2/1/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation
import ObjectMapper

class FeedsResponseJSON: Mappable {
    var feeds: [FeedJSON]?
    var message: String?
    var error: Bool!
    var code: Int?
    
    required init?(_ map: Map){
        
    }
    func mapping(map: Map) {
        error  <- map["error"]
        if error == true {
            message <- map["message"]
            code <- map["code"]
        } else {
             feeds <- map
        }
    }
}

class FeedJSON: Mappable {
    var id: Int?
    var leaveit: Int?
    var photo_thumb: String?
    var leavers: [LeaverJSON]?
    var lovers: [LoverJSON]?
    var created_at: NSDate?
    var error: Bool?
    var is_my_feed: Bool?
    var photo_two_thumb: String?
    var comment: String?
    var loveit: Int?
    var photo_two: String?
    var region: String?
    var is_my_left: Bool?
    var is_my_love: Bool?
    var country: String?
    var photo: String?
    var user : UserJSON?
    private var _created_at: String? {
        get {
           return nil
        }
        set {
            created_at = self.convertDateFromStringToPhoneTimeZone(newValue!)
        }
    }
    
    required init?(_ map: Map){
    
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        leaveit <- map["leaveit"]
        photo_thumb <- map["photo_thumb"]
        leavers <- map["leavers"]
        lovers <- map["lovers"]
        _created_at <- map["created_at"]
        error <- map["error"]
        is_my_feed <- map["is_my_feed"]
        photo_two_thumb <- map["photo_two_thumb"]
        comment <- map["comment"]
        loveit <- map [ "loveit"]
        photo_two <- map["photo_two"]
        region <- map["region"]
        is_my_left <- map["is_my_left"]
        is_my_love <- map["is_my_love"]
        country <- map["country"]
        photo <- map ["photo"]
        user <- map["user"]
    }
    
    func getTimeDifferenceFromGMT() -> Int{
        return NSTimeZone.localTimeZone().secondsFromGMT
    }
    
    func dateFormatter(format: String = "y-MM-dd HH:mm:ss" ) -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "y-MM-dd HH:mm:ss"
        return dateFormatter
    }
    
    func convertDateFromString(dateString: String) -> NSDate? {
        return self.dateFormatter().dateFromString(dateString)
    }
    
    func convertDateFromStringToPhoneTimeZone(dateString: String) -> NSDate? {
       let date = convertDateFromString(dateString)
        return self.getDateConvertedToPhoneTimeZone(date)
    }
    
    func createStringFromDate (date: NSDate) -> String {
       return self.dateFormatter().stringFromDate(date)
    }
    
    func getDateConvertedToPhoneTimeZone(date: NSDate?) -> NSDate? {
        return date?.dateByAddingTimeInterval(Double(self.getTimeDifferenceFromGMT()))
    }
}

class LoverJSON: Mappable {
    var photo_thumb: String?
    var id: Int?
    var username: String?
    var is_my_profile: Bool?
    var photo: String?
    var is_my_fed: Bool?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        photo_thumb <- map["photo_thumb"]
        id <- map["id"]
        username <- map["username"]
        is_my_profile <- map["is_my_profile"]
        photo <- map["photo"]
        is_my_fed <- map["is_my_fed"]
    }
}

class LeaverJSON: Mappable {
    var photo_thumb: String?
    var id: Int?
    var username: String?
    var is_my_profile: Bool?
    var photo: String?
    var feeding: Bool?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        photo_thumb <- map["photo_thumb"]
        id <- map["id"]
        username <- map["username"]
        is_my_profile <- map["is_my_profile"]
        photo <- map[""]
        feeding <- map["feeding"]
    }
}

class UserJSON: Mappable {
    var photo_thumb: String?
    var id: Int?
    var username: String?
    var photo: String?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        photo_thumb <- map["photo_thumb"]
        id <- map["id"]
        username <- map["username"]
        photo <- map["photo"]
    }
}
