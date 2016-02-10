//
//  ViewController.swift
//  Pixapals
//
//  Created by ak2g on 1/7/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager = CLLocationManager()
    var location: CLLocationCoordinate2D!
    
    var dict : NSDictionary!
    //var loginUsingFB = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
                let userInfo = UserDataStruct()
        
        if let _ = userInfo.id {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewControllerWithIdentifier("tabView")
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)

        }
        
        
        
        //self.navigationController?.navigationBar.tintColor = UIColor(red:1.000, green:1.000, blue:1.000, alpha:1.00)
       // x.layer.borderColor
        //x.layer.borderWidth
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
         UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.location = newLocation.coordinate
        manager.stopUpdatingLocation()
    }
    
    //    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    //        if case 0...2 = status.rawValue {
    //            appDelegate.ShowAlertView("Access Denied", message: "Location access is denied. You can't proceed. Please change location preference to this app from setting.")
    //        }
    //    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.Denied.rawValue {
            appDelegate.ShowAlertView("Access Denied", message: "Location access is denied. You can't proceed. Please change location preference to this app from setting.")
            self.manager.stopUpdatingLocation()
        }
    }
    
    
    @IBAction func btnFbLogin(sender: AnyObject) {
        
            let reachability: Reachability
            do {
                reachability = try Reachability.reachabilityForInternetConnection()
                if reachability.isReachable()  {
                    
                    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                    
                    fbLoginManager .logInWithReadPermissions(["public_profile", "email"], handler: {
                        (result, error) -> Void in
                        
                        print("\n result :\(result)", terminator: "")
                        print("\n error :\(error)", terminator: "")
                        
                        if result == nil{
                            return
                            
                        }
                        if result.isCancelled {
                            // Handle cancellations
                            fbLoginManager.logOut()
                        }else if (error != nil) {
                            print("\n ERROR IN FACEBOOK LOGIN", terminator: "")
                        }else{
                            let fbloginresult : FBSDKLoginManagerLoginResult = result
                            
                            //                print("token :\(FBSDKAccessToken.currentAccessToken())", terminator: "")
                            
                            //if FBSDKAccessToken.currentAccessToken() != nil{
                            if(fbloginresult.grantedPermissions.contains("email"))
                            {
                                self.getFBUserData()
                                //fbLoginManager.logOut()
                            }
                            //}
                        }
                    })
                    
                    
                } else{
                    

                    return
                    
                }}catch{
                    
            }
        }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, age_range, gender, hometown, birthday"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! NSDictionary
                    //                    print(result, terminator: "")
                    print(self.dict, terminator: "")
                    
                    
                    print(self.dict["email"])
                    print(self.dict["id"])
                    print(self.dict["name"])
                    print(self.dict["age_range"]!["min"])
                    print(self.dict["gender"])
                    print(self.dict["user_birthday"])
                    
                    
                    
                    if let _ = self.location {
                        self.loginFbUser()
                    }
                    
                    NSLog(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                }
            })
        }
        
        
        let FriendsgraphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": " gender, birthday"])
        FriendsgraphRequest.startWithCompletionHandler({(connection,result,error)-> Void in
            
            print("\(result)", terminator: "")
            
            
        })
        
        
    }
    
    func loginFbUser(){
        
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            if reachability.isReachable()  {
                
                
                var registerUrlString = "\(apiUrl)api/v1/login"
                
                registerUrlString = registerUrlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                let fbName: String = self.dict.objectForKey("name") as! String
                let userName = fbName.stringByReplacingOccurrencesOfString(" ", withString: "_")
                let fbId: String = self.dict.objectForKey("id") as! String
                

                
                let defaults = NSUserDefaults.standardUserDefaults()
                let userId = defaults.objectForKey("user_id") as? Int
                String(stringInterpolationSegment: userId)
                
                //let locationManager =
                //locationManager.requestWhenInUseAuthorization()
                
                //LocationManager(manager:CLLocationManager(), afterLocationRetrived: { (locCoordinates) -> () in
                
                    let parametersToPost: [String: AnyObject] = [
                        "profileid": fbId,
                        "name": fbName,
                        "type":"facebook",
                        "gender": self.dict["gender"]!,
                        "latitude": String(location.latitude),
                        "longitude": String(location.longitude),
                        "email": self.dict["email"]!,
                        "username": userName,
                        "device_token" : appDelegate.deviceTokenString ?? "werrrrrr"
                    ]
//                "name": self.textFieldFullName.text!,
//                "email": self.textFieldEmail.text!,
//                "username": self.textFieldUsername.text!,
//                "password": self.textFieldPassword.text!,
//                "password_confirmation": self.textFieldConfirmPassword.text!,
//                "latitude": location.latitude,
//                "longitude": location.longitude,
//                "website": "",
//                "bio": "",
//                "phone": "",
//                "gender": btnGender.titleLabel?.text ?? "",
//                "device_token" : deviceToken
                
                    print(parametersToPost, terminator: "")
                    
                    Alamofire.request(.POST, registerUrlString, parameters: parametersToPost)
                        .responseJSON { response in
                            debugPrint(response)     // prints detailed description of all response properties
                            
                            print(response.request)  // original URL request
                            print(response.response) // URL response
                            print(response.data)     // server data
                            print(response.result)   // result of response serialization
                            
//                            if let JSON = response.result.value {
//                                print("JSON: \(JSON)")
//                            }
//                            
//                            
//                            
//                            if let HTTPResponse = response.response {
//                                
//                                let statusCode = HTTPResponse.statusCode
//                                
//                                if statusCode==200{
//                                    
//                                    let json = JSON(response.result.value!)
//                                    //let num = json["interest"].arrayObject
//                                    // let userids = json["user_id"].intValue
//                                    print(json)
//                                    let userid = json["results"]["user_id"].intValue
//                                    let fb_id = json["results"]["f_id"].stringValue
//                                    
//                                    print(fb_id)
//                                    //self.user_id = userid
//                                    
//                                    let defaults = NSUserDefaults.standardUserDefaults()
//                                    defaults.setInteger(userid, forKey: "user_id")
//                                    defaults.setValue(fb_id, forKey: "K_fb_id")
//                                    defaults.setValue("", forKey: "K_token")
//                                    
//                                    
//                                    defaults.synchronize()
//                                    // print(self.user_id)
//                                    
//                                    
//                                }else {
//                                    
//                                    
//                                    
//                                }
//                            }
                            
                            switch response.result {
                            case .Success(let data):
                                if let dict = data["user"] as? [String: AnyObject] {
                                    print(dict)
                                    let userInfoStruct = UserDataStruct()
                                    userInfoStruct.saveUserInfoFromJSON(jsonContainingUserInfo: dict)
                                    
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = storyBoard.instantiateViewControllerWithIdentifier("tabView")
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else {
                                    print(data)
                                    print("Invalid Username/Password: \(data["message"])")
                                }
                            case .Failure(let error):
                                print("Error in connection \(error)")
                            }

                    }
                
            } else{
                
                appDelegate.ShowAlertView("No Internet Connection", message: "Please enable internet connection.")
                return
                
            }}catch{
                
        }

}
}

