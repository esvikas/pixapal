//
//  HelperFile.swift
//  Pixapals
//
//  Created by ak2g on 1/13/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire

let apiUrl = "http://pixapals.com/API/public/"

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

var UserLocationForFilter = nsUserDefault.objectForKey("UserLocationForFilter") as! String
var UserGenderForFilter = nsUserDefault.objectForKey("UserGenderForFilter") as! String

var userGender:String!

let nsUserDefault = NSUserDefaults.standardUserDefaults()


public func requestWithHeaderXAuthToken(
    method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .URL,
    var headers: [String: String] = [String:String]())
    -> Alamofire.Request
{
    let token = UserDataStruct().api_token ?? "NO TOKEN"
    
    headers["X-Auth-Token"] = token
    return Alamofire.Manager.sharedInstance.request(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

public func requestWithHeaderXAuthTokenAndDeviceTokenInParam(
    method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    var parameters: [String: AnyObject] = [String: AnyObject]() ,
    encoding: ParameterEncoding = .URL,
    var headers: [String: String] = [String: String]())
    -> Alamofire.Request
{
    let token = UserDataStruct().api_token ?? "NO TOKEN"
    headers["X-Auth-Token"] = token
    
    let deviceToken = appDelegate.deviceTokenString ?? "No Device Token"
    parameters["device_token"] = deviceToken
    
    return Alamofire.Manager.sharedInstance.request(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

public func requestWithDeviceTokenInParam(
    method: Alamofire.Method,
    _ URLString: URLStringConvertible,
    var parameters: [String: AnyObject] = [String: AnyObject](),
    encoding: ParameterEncoding = .URL,
    headers: [String: String]? = nil)
    -> Alamofire.Request
{
    let deviceToken = appDelegate.deviceTokenString ?? "No Device Token"
    parameters["device_token"] = deviceToken
    
    return Alamofire.Manager.sharedInstance.request(
        method,
        URLString,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

public func showAlertx(controller: UIViewController){
    let alert = UIAlertController(title: "sdd", message: "sdsd", preferredStyle: UIAlertControllerStyle.Alert)
    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
    alert.addAction(action)
    controller.presentViewController(alert, animated: true, completion: nil)
}


