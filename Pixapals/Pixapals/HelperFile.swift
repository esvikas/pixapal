//
//  HelperFile.swift
//  Pixapals
//
//  Created by ak2g on 1/13/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

let apiUrl = "http://pixapals.com/API/public/"

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

var UserLocationForFilter = nsUserDefault.objectForKey("UserLocationForFilter") as! String
var UserGenderForFilter = nsUserDefault.objectForKey("UserGenderForFilter") as! String

var userGender:String!

let nsUserDefault = NSUserDefaults.standardUserDefaults()



