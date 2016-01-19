//
//  LoginWithEmailViewController.swift
//  Pixapals
//
//  Created by DARI on 1/12/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftyJSON

class LoginWithEmailViewController: UIViewController {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogin(sender: AnyObject) {
        loginWithEmail()
    }
    
    func loginWithEmail(){
        
        
        
<<<<<<< HEAD
        let registerUrlString = "\(apiUrl)api/v1/login-using-email"
=======
        let registerUrlString = "http://192.168.0.77/API/public/api/v1/login-using-email"
>>>>>>> master
        
        let parametersToPost = [
            "email": emailTextfield.text!,
            "password": passwordTextfield.text!
        ]
        
        print(parametersToPost, terminator: "")
        
        
        
        
        Alamofire.request(.POST, registerUrlString, parameters: parametersToPost)
            .responseJSON { response in
                //                debugPrint(response)     // prints detailed description of all response properties
                //
                //                print(response.request)  // original URL request
                //                print(response.response) // URL response
                //                print(response.data)     // server data
                //                print(response.result)   // result of response serialization
                
                //                switch response.result {
                //                case .Success(let data):
                //                    //print(data)
                //                    let json = JSON(data)
                //
                //                    if let dict = data["user"] as? [String: AnyObject] {
                //                        print(dict)
                //                        for values in
                //                        if json["error"].boolValue {
                //                            print("error exist")
                //                        }else {
                //                            print("no error")
                //                            let userDefaults = NSUserDefaults.standardUserDefaults()
                //                            userDefaults.setObject(dict, forKey: "user_info")
                //                        }
                //                    } else {
                //                        print("failed")
                //                    }
                //
                //
                //                case .Failure(let error):
                //                    print(error)
                //                }
                
                switch response.result {
                case .Success(let data):
                    if let dict = data["user"] as? [String: AnyObject] {
                        var newDict = [String: AnyObject]()
                        for (item, value) in dict where "<null>" != "\(value.description)" {
                            newDict[item] = "\(value)"
                        }
                        print(newDict)
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setObject(newDict, forKey: "user_info")
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewControllerWithIdentifier("tabView")
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        print(data)
                        print("Invalid Username/Password: \(data["message"])")
                    }
                case .Failure(let error):
                    print("Error in connection \(error)")
                }
//                if let HTTPResponse = response.response {
//                    
//                    let statusCode = HTTPResponse.statusCode
//                    //print(statusCode)
//                    
//                    if statusCode==200{
//                        if let dict = response.result.value?["user"] as? [String: AnyObject] {
//                            var newDict = [String: AnyObject]()
//                            for (item, value) in dict where "<null>" != "\(value.description)" {
//                                newDict[item] = "\(value)"
//                            }
//                            print(newDict)
//                            let userDefaults = NSUserDefaults.standardUserDefaults()
//                            userDefaults.setObject(newDict, forKey: "user_info")
//                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                            let vc = storyBoard.instantiateViewControllerWithIdentifier("tabView")
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    }else if statusCode == 412  {
//                        print("Invalid Username/Password")
//                    } else {
//                        print("Error in connection")
//                    }
//                }else {
//                    print("Error in connection")
//                }
        }
        
    }
    
    
    
}
