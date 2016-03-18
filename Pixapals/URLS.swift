//
//  URLS.swift
//  Pixapals
//
//  Created by DARI on 3/9/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation

enum URLType: String {
    case Refeed = "feeds/refeed"
    case GetFed = "profile/getfed"
    case Feed = "feed/"
    case LoveIt = "feeds/loveit"
    case LeaveIt = "feeds/leaveit"
    case PersonalisedFeed = "feeds/all/"
    case GlobalFeed = "feeds/global/"
    case LoginWithEmail = "login-using-email"
    case MyNotification = "my-notifications/"
    case FedNotification = "fed-notifications/"
    case PostFeed = "feeds"
    case Profile = "profile/"
    case ProfilePhoto = "profile/photo"
    case ProfileUpdate = "profile/update"
    case Register = "register"
    case AppIssue = "app/issue"
    case PreferencesPost = "preference/set"
    case Logout = "profile/logout"
    case Login = "login"
    case FaceBookFriends = "friends-list"
    case ForgotPassword = "forget-password"
    case NotificationCount = "unread-notification-count"
    case BlockUserFeed = "block/post-user"
    case TermsAndConditions = "terms-conditions"
    
    func make()-> String{
        let apiUrl = "http://pixapals.com/API/public/"
        let apiVersion = "api/v1/"
        return apiUrl + apiVersion + self.rawValue
    }
}

struct URLs {
    
    
//    func makeGetGLobalFeed(userId userId: Int, pageNumber: Int, postLimit: Int)->String{
//        return makeURL(.GlobalFeed) + "\(userId)/\(pageNumber)/\(postLimit)"
//    }
    
//    func makeGetPersonalisedFeed(userId userId: Int, pageNumber: Int, postLimit: Int)->String{
//        return makeURL(.PersonalisedFeed) + "\(userId)/\(pageNumber)/\(postLimit)"
//    }
    
    func makeNotification(userId userId: Int, pageNumber: Int, notificationLimit: Int) -> Bool -> String {
        
        return {
            isMy in
            if isMy {
                return (self.makeURLByAddingTrailling(userId: userId, pageNumber: pageNumber, limit: notificationLimit))(.MyNotification)
            }
            return (self.makeURLByAddingTrailling(userId: userId, pageNumber: pageNumber, limit: notificationLimit))(.FedNotification)
        }
        
    }
    
    func makeGlobal(userId userId: Int, pageNumber: Int, postLimit: Int) -> Bool -> String {
        return {
             isGlobal in
            if isGlobal {
                return (self.makeURLByAddingTrailling(userId: userId, pageNumber: pageNumber, limit: postLimit))(.GlobalFeed)
            }
            return (self.makeURLByAddingTrailling(userId: userId, pageNumber: pageNumber, limit: postLimit))(.PersonalisedFeed)
        }
    }
    
    func makeURLByAddingTrailling(userId userId: Int, pageNumber: Int, limit: Int) -> URLType -> String {
        
        let add = "\(userId)/\(pageNumber)/\(limit)"
        
        return {
            $0.make() + add
        }
    }
    
//    func makeURL(url: URLType) -> String {
//        return url.make()
//    }
}
