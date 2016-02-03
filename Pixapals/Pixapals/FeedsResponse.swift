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
        message <- map["message"]
        code <- map["code"]
        feeds <- map["feeds"]
    }
}

class ProfileResponseJSON: FeedsResponseJSON {
    var user: UserInDetailJSON!
    
    required init(_ map: Map) {
        super.init(map)!
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        user <- map["user"]
    }
}

class FeedJSON: Mappable {
    var id: Int?
    var leaveit: Int?
    var photo_thumb: String?
    var leavers: [UserJSON]?
    var lovers: [UserJSON]?
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
            let dateConverter = DateConverter()
            created_at = dateConverter.convertDateFromStringToPhoneTimeZone(newValue!)
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
}

class UserJSON: Mappable {
    var photo_thumb: String?
    var id: Int?
    var username: String?
    var photo: String?
    var is_my_fed = false
    var is_my_profile = true

    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        photo_thumb <- map["photo_thumb"]
        id <- map["id"]
        username <- map["username"]
        photo <- map["photo"]
        is_my_fed <- map["is_my_fed"]
        is_my_profile <- map["is_my_profile"]
    }
}

class UserInDetailJSON: UserJSON {
    
    var bio: String?
    
    var created_at: NSDate?
    var _created_at: String? {
        get{
            return nil
        }
        set {
            let dateConverter = DateConverter()
            self.created_at = dateConverter.convertDateFromStringToPhoneTimeZone(newValue!)
        }
    }
    
    var feeders: [UserJSON]?
    var feeders_count: Int!
    var feeds_count: Int!
    
    var _gender: Gender!
    var gender: String {
        get {
            return _gender.rawValue
        }
        set {
            if newValue == "male" || newValue == "Male" {
                self._gender = Gender.Male
            } else {
                self._gender = Gender.Female
            }
        }
    }
    
    var email: String?
    var feeding: [UserJSON]?
    var feeding_count: Int?
    var latitude: Int?
    var longitude: Int?
    var name: String?
    var phone: String?
    var website: String?
    
    override func mapping(map: Map) {
        super.mapping(map)
        bio <- map["bio"]
        created_at <- map["created_at"]
        feeders <- map["feeders"]
        feeders_count <- map["feeders_count"]
        feeds_count <- map["feeds_count"]
        _gender <- map["gender"]
        email <- map["email"]
        feeding <- map["feeding"]
        feeding_count <- map["feeding_count"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        name <- map["name"]
        phone <- map["phone"]
        website <- map["website"]
    }
    
    required init?(_ map: Map){
        super.init(map)
    }
}

class DateConverter {
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
