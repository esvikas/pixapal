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
    
//    let method: Alamofire.Method
//    let URLString: URLStringConvertible
//    let parameters: [String: AnyObject]?
//    let encoding: ParameterEncoding
//    let headers: [String: String]
    let request: Alamofire.Request
    
    public init (requestType: RequestType, urlString: URLStringConvertible, var parameters: [String: AnyObject]? = nil, var headers: [String: String] = [String:String](), method: Alamofire.Method = .POST, _ encoding: ParameterEncoding = .URL) {
//        self.method = method
//        self.URLString = urlString
//        self.parameters = parameters
//        self.encoding = encoding
//        self.headers = headers
        switch requestType {
        case .WithXAuthTokenInHeader:
            let token = UserDataStruct().api_token ?? "NO TOKEN"
            headers["X-Auth-Token"] = token
        case .WithDeviceTokenInParam:
            
//            if parameters == nil {
//                parameters = [String: AnyObject]()
//            }
            
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
    }
    
    func handleResponse<T: Mappable>(completionHandler: (T)-> Void, errorBlock: ()-> UIViewController, onResponse: (Void -> Void)? = nil) {
        self.request.responseObject { (response: Response<T, NSError>) -> Void in
//            switch response.result {
//            case .Success(let data):
//                completionHandler(data)
//            case .Failure(let error):
//                print(error)
//                let viewController = errorBlock()
//                PixaPalsErrorType.ConnectionError.show(viewController)
//            }
//            
//            if let onResponse = onResponse {
//                onResponse()
//            }
            self.responseHandling(response, completionHandler: completionHandler, errorBlock: errorBlock, onResponse: onResponse)
        }
    }
    
    func giveResponseJSON(completionHandler: (AnyObject)-> Void, errorBlock: ()-> UIViewController, onResponse: (Void -> Void)? = nil){
        request.responseJSON { (response) -> Void in
//            switch response.result {
//            case .Success(let data):
//                completionHandler(data)
//            case .Failure(let error):
//                print(error)
//                let viewController = errorBlock()
//                PixaPalsErrorType.ConnectionError.show(viewController)
//            }
//            if let onResponse = onResponse {
//                onResponse()
//            }
            self.responseHandling(response, completionHandler: completionHandler, errorBlock: errorBlock, onResponse: onResponse)
        }
    }
    
    private func responseHandling<T> (response: Response<T, NSError>, completionHandler: (T)-> Void, errorBlock: ()-> UIViewController, onResponse: (Void -> Void)? = nil) {
        switch response.result {
        case .Success(let data):
            completionHandler(data)
        case .Failure(let error):
            print(error)
            let viewController = errorBlock()
            PixaPalsErrorType.ConnectionError.show(viewController)
        }
        if let onResponse = onResponse {
            onResponse()
        }
    }
    
//    public func requestWithHeaderXAuthToken(
//        method: Alamofire.Method,
//        _ URLString: URLStringConvertible,
//        parameters: [String: AnyObject]? = nil,
//        encoding: ParameterEncoding = .URL,
//        //classType: Element,
//        var headers: [String: String] = [String:String](),
//        completionHandler: (T)-> Void, errorBlock: ()-> UIViewController)
//    {
//        // print(classType)
//        let token = UserDataStruct().api_token ?? "NO TOKEN"
//        headers["X-Auth-Token"] = token
//        Alamofire.Manager.sharedInstance.request(
//            method,
//            URLString,
//            parameters: parameters,
//            encoding: encoding,
//            headers: headers
//            )
//            .responseObject { (response: Response<T, NSError>) -> Void in
//                print(response.result.description)
//                switch response.result {
//                case .Success(let data):
//                    completionHandler(data)
//                case .Failure(let error):
//                    print(error)
//                    let viewController = errorBlock()
//                    PixaPalsErrorType.ConnectionError.show(viewController)
//                }
//        }
//    }
//    
//    public func requestWithHeaderXAuthTokenAndDeviceTokenInParam(
//        method: Alamofire.Method,
//        _ URLString: URLStringConvertible,
//        var parameters: [String: AnyObject] = [String: AnyObject]() ,
//        encoding: ParameterEncoding = .URL,
//        var headers: [String: String] = [String: String](),
//        completionHandler: (T)-> Void, errorBlock: ()-> UIViewController)
//        -> Alamofire.Request
//    {
//        let token = UserDataStruct().api_token ?? "NO TOKEN"
//        headers["X-Auth-Token"] = token
//        
//        let deviceToken = appDelegate.deviceTokenString ?? "No Device Token"
//        parameters["device_token"] = deviceToken
//        
//        return Alamofire.Manager.sharedInstance.request(
//            method,
//            URLString,
//            parameters: parameters,
//            encoding: encoding,
//            headers: headers
//        )
//    }
//    
//    public func requestWithDeviceTokenInParam(
//        method: Alamofire.Method,
//        _ URLString: URLStringConvertible,
//        var parameters: [String: AnyObject] = [String: AnyObject](),
//        encoding: ParameterEncoding = .URL,
//        headers: [String: String]? = nil,
//        completionHandler: (T)-> Void, errorBlock: ()-> UIViewController)
//        -> Alamofire.Request
//    {
//        let deviceToken = appDelegate.deviceTokenString ?? "No Device Token"
//        parameters["device_token"] = deviceToken
//        
//        return Alamofire.Manager.sharedInstance.request(
//            method,
//            URLString,
//            parameters: parameters,
//            encoding: encoding,
//            headers: headers
//        )
//    }
}
