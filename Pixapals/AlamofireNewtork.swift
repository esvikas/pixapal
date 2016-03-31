//
//  AlamofireNewtork.swift
//  Pixapals
//
//  Created by DARI on 3/4/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public enum RequestType {
    case WithXAuthTokenInHeader, WithDeviceTokenInParam, WithBoth
}

public class APIManager{

    let request: Alamofire.Request
    
    public init (requestType: RequestType, urlString: URLStringConvertible, var parameters: [String: AnyObject]? = nil, var headers: [String: String] = [String:String](), method: Alamofire.Method = .POST, _ encoding: ParameterEncoding = .URL) {

        switch requestType {
        case .WithXAuthTokenInHeader:
            let token = UserDataStruct().api_token ?? "NO TOKEN"
            headers["X-Auth-Token"] = token
        case .WithDeviceTokenInParam:
            parameters = (parameters == nil) ? [String:AnyObject]() : parameters
            let deviceToken = appDelegate.deviceTokenString ?? "No Device Token"
            
            parameters!["device_token"] = deviceToken

        case .WithBoth:
            parameters = (parameters == nil) ? [String:AnyObject]() : parameters
            let token = UserDataStruct().api_token ?? "NO TOKEN"
            headers["X-Auth-Token"] = token
            let deviceToken = appDelegate.deviceTokenString ?? "No Device Token"
            parameters!["device_token"] = deviceToken
        }
        
        self.request = Alamofire.Manager.sharedInstance.request(
            method,
            urlString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        //print(request)
    }
    
    func handleResponse<T: Mappable>(completionHandler: (T)-> Void, errorBlock: ()-> UIViewController, onResponse: (Void -> Void)? = nil) {
        self.request.responseObject { (response: Response<T, NSError>) -> Void in
            self.responseHandling(response, completionHandler: completionHandler, errorBlock: errorBlock, onResponse: onResponse)
        }
//        self.request.responseJSON{ (response) -> Void in
//            print(response.request)
//            switch response.result {
//            case .Failure(let error):
//                print(error)
//            case .Success(let val):
//                print(val)
//            }
//        }
    }
    
    func giveResponseJSON(completionHandler: (AnyObject)-> Void, errorBlock: ()-> UIViewController, onResponse: (Void -> Void)? = nil){
        request.responseJSON { (response) -> Void in
            self.responseHandling(response, completionHandler: completionHandler, errorBlock: errorBlock, onResponse: onResponse)
        }
//        self.request.responseJSON{ (response) -> Void in
//            print(response.request)
//            switch response.result {
//            case .Failure(let error):
//                print(error)
//            case .Success(let val):
//                print(val)
//            }
//        }
    }
    
    private func responseHandling<T> (response: Response<T, NSError>, completionHandler: (T)-> Void, errorBlock: ()-> UIViewController, onResponse: (Void -> Void)? = nil) {
        switch response.result {
        case .Success(let data):
            completionHandler(data)
        case .Failure(let error):
            //print(error)
            let viewController = errorBlock()
            PixaPalsErrorType.ConnectionError.show(viewController)
        }
        if let onResponse = onResponse {
            onResponse()
        }
    }
}
