//
//  UserDataStruct.swift
//  Pixapals
//
//  Created by DARI on 1/18/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation

enum Gender: String {
    case Male = "Male", Female = "Female"
}

struct UserDataStruct {
    let username: String!
    let email: String!
    let api_token: String!
    let longitude: String!
    let latitude: String!
    let gender: Gender
    let id: Int!
    let website: String!
    let bio: String!
    let phone: String!
    let thumbImage:String!
    
    init () {
        let nsUserDefault = NSUserDefaults.standardUserDefaults()
        var user_Info_Dict = [String: String]()
        if let user_Info_Dict_from_NSUserDefault = nsUserDefault.valueForKey("user_info") as? [String: String] {
            user_Info_Dict = user_Info_Dict_from_NSUserDefault
        }
        username = user_Info_Dict["username"]
        email = user_Info_Dict["email"]
        api_token = user_Info_Dict["api_token"]
        longitude = user_Info_Dict["longitude"]
        latitude = user_Info_Dict["latitude"]
        website = user_Info_Dict["website"]
        bio = user_Info_Dict["bio"]
        phone = user_Info_Dict["phone"]
        thumbImage = user_Info_Dict["photo_thumb"]

        if let gender = user_Info_Dict["gender"] {
            switch gender {
                case "male":
                    self.gender = Gender.Male
                default:
                    self.gender = Gender.Female
            }
        } else {
            gender = Gender.Male
        }
        if let id = user_Info_Dict["id"] {
            self.id = Int(id)
        }else {
            self.id = nil
        }
    }
    
    func saveUserInfoFromJSON(jsonContainingUserInfo dict: [String: AnyObject]){
        var newDict = [String: AnyObject]()
        for (item, value) in dict where "<null>" != "\(value.description)" {
            newDict[item] = "\(value)"
        }
        print(newDict)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(newDict, forKey: "user_info")
    }
    
    func saveKeyInUserInfo(key: String, value: AnyObject) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        guard var dict = userDefaults.objectForKey("user_info") as? [String: AnyObject] else {
            return
        }
        dict[key] = value
        userDefaults.removeObjectForKey("user_info")
        userDefaults.setObject(dict, forKey: "user_info")
    }
    
    func removeUserInfo() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("user_info")
    }
}
