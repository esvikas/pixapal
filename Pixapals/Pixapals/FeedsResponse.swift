//
//  FeedsResponse.swift
//  Pixapals
//
//  Created by DARI on 2/1/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation
import ObjectMapper

class UserFeedDistinction {
    static let sharedInstance = UserFeedDistinction()
    var feeds = [FeedJSON]()
    var users = [UserJSON]()
    var myProfile: UserInDetailJSON?
    
    func checkDistinctFeed(feed: FeedJSON) -> FeedJSON {
        
        let isDistinct = feeds.reduce((true, feed)) { (isDistinct, feedElem) -> (Bool, FeedJSON) in
            if !isDistinct.0 {
                return isDistinct
            }
            else if feedElem.id! == feed.id! {
                return (false, feedElem)
            }
            return (true, feed)
        }
        
        if isDistinct.0 {
            feeds.append(feed)
            return feed
        }
        
        isDistinct.1.id = feed.id
        isDistinct.1.leaveit = feed.leaveit
        isDistinct.1.photo_thumb = feed.photo_thumb
        isDistinct.1.leavers = feed.leavers
        isDistinct.1.lovers = feed.lovers
        isDistinct.1.created_at = feed.created_at
        isDistinct.1.error = feed.error
        isDistinct.1.is_my_feed = feed.is_my_feed
        isDistinct.1.photo_two_thumb = feed.photo_two_thumb
        isDistinct.1.comment = feed.comment
        isDistinct.1.loveit = feed.loveit
        isDistinct.1.photo_two = feed.photo_two
        isDistinct.1.region = feed.region
        isDistinct.1.is_my_left = feed.is_my_left
        isDistinct.1.is_my_love = feed.is_my_love
        isDistinct.1.country = feed.country
        isDistinct.1.photo = feed.photo
        isDistinct.1.user  = feed.user
        isDistinct.1.mode = feed.mode
        isDistinct.1.is_outdated = feed.is_outdated
        
        return isDistinct.1
    }
    
    func checkDistinctUser(user: UserJSON) -> UserJSON {
        let isDistinct = users.reduce((true, user)) { (isDistinct, userElem) -> (Bool, UserJSON) in
            if !isDistinct.0 {
                return isDistinct
            }
            else if userElem.id! == user.id! {
                return (false, userElem)
            }
            return (true, user)
        }
        
        if isDistinct.0 {
            users.append(user)
            return user
        }
        
        isDistinct.1.photo_thumb = user.photo_thumb
        isDistinct.1.id = user.id
        isDistinct.1.username = user.username
        isDistinct.1.photo = user.photo
        isDistinct.1.is_my_fed = user.is_my_fed
        ////print("sddddd--->\(user.is_my_fed)")
        isDistinct.1.is_my_profile = user.is_my_profile
        return isDistinct.1
    }
    
    func setCurrentUserDetail(user: UserInDetailJSON, currentUserId: Int) {
        if let userid = user.id where userid == currentUserId {
            self.myProfile = user
        }
    }
    
    func getUserWithId(id: Int) -> UserJSON? {
        let user = users.filter { (user) -> Bool in
            user.id! == id
        }
        if user.count > 0 {
            return user.first
        }
        return nil
    }
    
    func getFeedWithId(id: Int) -> FeedJSON? {
        let feed = feeds.filter { (feed) -> Bool in
            feed.id! == id
        }
        if feed.count > 0 {
            return feed.first
        }
        return nil
    }
    
    func removeUserWithId(id: Int) {
        self.users  = self.users.filter({ (user) -> Bool in
            user.id! != id
        })
    }
    
    func removeFeedWithId(id: Int) {
        self.feeds  = self.feeds.filter({ (feed) -> Bool in
            feed.id! != id
        })
    }
    
}

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
        if let feeds = feeds {
            self.feeds = feeds.map({ (feed) -> FeedJSON in
                UserFeedDistinction.sharedInstance.checkDistinctFeed(feed)
            })
        }
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
        if let user = user {
            UserFeedDistinction.sharedInstance.setCurrentUserDetail(user, currentUserId: UserDataStruct().id)
        }
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
    var mode: Int?
    var user : UserJSON?
    var is_outdated: Bool? = false
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
        mode <- map["mode"]
        is_outdated <- map["is_outdated"]
        
        if let lovers = lovers {
            self.lovers = lovers.map({ (user) -> UserJSON in
                UserFeedDistinction.sharedInstance.checkDistinctUser(user)
            })
        }
        if let leavers = leavers {
            self.leavers = leavers.map({ (user) -> UserJSON in
                UserFeedDistinction.sharedInstance.checkDistinctUser(user)
            })
        }
        if let user = user {
            self.user = UserFeedDistinction.sharedInstance.checkDistinctUser(user)
        }
    }
    
    func loveFeed(viewController: UIViewController, completionHandler: ()->()) {
        let user = UserDataStruct()
        
        let urlString = URLType.LoveIt.make()
        
        let parameters: [String: AnyObject] =
        [
            "user_id": String(user.id!),
            "post_id": String(self.id!)
        ]
        
        self.loveFeed(completionHandler)
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters:  parameters).handleResponse(
            { (loveItObject: SuccessFailJSON) -> Void in
                if !loveItObject.error! {
                    self.lovers?.append(loveItObject.user!)
                    self.leavers = self.leavers!.filter{$0.id! != loveItObject.user!.id!}
                } else {
                    self.leaveFeed(completionHandler)
                    PixaPalsErrorType.CantLoveItLeaveItError.show(viewController)
                }
            }, errorBlock: {
                self.leaveFeed(completionHandler)
               return viewController
        })
    }
    
    func leaveFeed(viewController: UIViewController, completionHandler: ()->()) {
        let user = UserDataStruct()
        
        let urlString = URLType.LeaveIt.make()
        
        let parameters: [String: AnyObject] =
        [
            "user_id": String(user.id!),
            "post_id": String(self.id!)
        ]
        
        self.leaveFeed(completionHandler)
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters:  parameters).handleResponse(
            { (loveItObject: SuccessFailJSON) -> Void in
                if !loveItObject.error! {
                    self.leavers?.append(loveItObject.user!)
                    self.lovers = self.lovers!.filter{$0.id! != loveItObject.user!.id!}
                } else {
                    self.loveFeed(completionHandler)
                    PixaPalsErrorType.CantLoveItLeaveItError.show(viewController)
                }
            }, errorBlock: {
                self.loveFeed(completionHandler)
                return viewController
        })
    }
    
    private func loveFeed(completionHandler: ((Void) -> ())? = nil ) {
        self.is_my_love = true
        self.loveit = self.loveit! + 1
        if self.is_my_left! {
            self.is_my_left = false
            self.leaveit = self.leaveit! - 1
        }
        if let completionHandler = completionHandler {
            completionHandler()
        }
    }
    
    private func leaveFeed(completionHandler: ((Void)-> ())? = nil) {
        self.is_my_left = true
        self.leaveit = self.leaveit! + 1
        if self.is_my_love! {
            self.is_my_love = false
            self.loveit = self.loveit! - 1
        }
        if let completionHandler = completionHandler {
            completionHandler()
        }
    }
}

class UserJSON: Mappable {
    var photo_thumb: String?
    var id: Int?
    var username: String?
    var photo: String?
    var is_my_fed: Bool?
    var is_my_profile: Bool?
    
    
    required init?(_ map: Map){
    }
    
//    init (id: Int, username: String, photo_thumb: String, photo: String, is_my_fed: Bool, is_my_profile: Bool) {
//         self.photo_thumb = photo_thumb
//         self.id = id
//         self.username = username
//         self.photo = photo
//         self.is_my_fed = is_my_fed
//         self.is_my_profile = is_my_profile
//    }
    
    func mapping(map: Map) {
        photo_thumb <- map["photo_thumb"]
        id <- map["id"]
        username <- map["username"]
        photo <- map["photo"]
        is_my_fed <- map["is_my_fed"]
        ////print(is_my_fed)
        is_my_profile <- map["is_my_profile"]
        
        if let is_my_profile = is_my_profile where is_my_profile == true {
            is_my_fed = true
        }
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
    
//    var gender: Gender?
//    private var _gender: String? {
//        get {
//            return nil
//        }
//        set {
//            //print(newValue)
//            if newValue == "male" || newValue == "Male" {
//                self.gender = Gender.Male
//            } else {
//                self.gender = Gender.Female
//            }
//        }
//    }
    private var _gender: Gender?
    var gender: String? {
                get {
                    return _gender?.rawValue ?? ""
                }
                set {
                    if newValue == "male" || newValue == "Male" {
                        self._gender = Gender.Male
                    } else if newValue == "female" || newValue == "Female" {
                        self._gender = Gender.Female
                    } else {
                        self._gender = Gender.DontShare
                    }
        }

    }
    
    var email: String?
    var feeding: [UserJSON]?
    var feeding_count: Int!
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
        gender <- map["gender"]
        email <- map["email"]
        feeding <- map["feeding"]
        feeding_count <- map["feeding_count"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        name <- map["name"]
        phone <- map["phone"]
        website <- map["website"]
        if let feeders = feeders {
            self.feeders = feeders.map({ (user) -> UserJSON in
                UserFeedDistinction.sharedInstance.checkDistinctUser(user)
            })
        }
        if let feeding = feeding {
            self.feeding = feeding.map({ (user) -> UserJSON in
                UserFeedDistinction.sharedInstance.checkDistinctUser(user)
            })
        }
    }
    
    required init?(_ map: Map){
        super.init(map)
    }
}

//class OneFeedResponseJSON: Mappable {
//    var feeds: FeedJSON?
//    var message: String?
//    var error: Bool!
//    var code: Int?
//    
//    required init?(_ map: Map){
//        
//    }
//    func mapping(map: Map) {
//        error  <- map["error"]
//        message <- map["message"]
//        code <- map["code"]
//        feeds <- map["feeds"]
//        
//        if let feeds = feeds {
//            self.feeds = feeds.map({ (feed) -> FeedJSON in
//                UserFeedDistinction.sharedInstance.checkDistinctFeed(feed)
//            })
//        }
//    }
//}
