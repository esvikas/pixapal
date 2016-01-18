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
    let username: String
    let email: String
    let api_token: String
    let longitude: String
    let latitude: String
    let gender: Gender
    let id: Int
    
    init () {
        let nsUserDefault = NSUserDefaults.standardUserDefaults()
        let user_Info_Dict = nsUserDefault.valueForKey("user_info") as! [String: AnyObject]
        username = user_Info_Dict["username"]!.stringValue
        email = user_Info_Dict["email"]!.stringValue
        api_token = user_Info_Dict["api_token"]!.stringValue
        longitude = user_Info_Dict["longitude"]!.stringValue
        latitude = user_Info_Dict["latitude"]!.stringValue
        if let gender = user_Info_Dict["gender"]!.stringValue {
            switch gender {
                case "male":
                    self.gender = Gender.Male
                default:
                    self.gender = Gender.Female
            }
        } else {
            gender = Gender.Male
        }
        id = user_Info_Dict["id"]!.integerValue
    }
}
