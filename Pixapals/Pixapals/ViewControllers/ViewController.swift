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
import FBSDKShareKit
import TwitterKit


class ViewController: UIViewController {
    
    var manager = CLLocationManager()
    var location: CLLocationCoordinate2D!
    
    var dict = NSMutableDictionary()
    
    var friendsList = NSMutableDictionary()

    //var loginUsingFB = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideBackButtonTitle()
        
        self.checkLogin()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.prepareWhenCommingToThisView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.prepareWhenGoingToOtherView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.prepareWhenGoingToOtherView()
    }
    
    func prepareWhenCommingToThisView() {
        self.hideNavigationBar(true)
        self.changeStatusBarStyle(.Default)
    }
    
    func prepareWhenGoingToOtherView(){
        self.hideNavigationBar(false)
        self.changeStatusBarStyle(.LightContent)
    }
    
    func changeStatusBarStyle(style: UIStatusBarStyle){
        UIApplication.sharedApplication().statusBarStyle = style
    }
    
    func changeStatusBarStyleToDefault(){
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    func hideNavigationBar(status: Bool) {
        self.navigationController?.navigationBarHidden = status
    }
    
    func checkLogin() {
        if self.isUserAlreadyLoggedIn() {
            self.openTabView()
        } else {
            self.setLocationManager()
            self.changeBackgroundColorToDefault()
        }
    }
    
    func openTabView(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("tabView")
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func changeBackgroundColorToDefault(){
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }
    
    func setLocationManager(){
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
    }
    
    func hideBackButtonTitle(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    func isUserAlreadyLoggedIn() -> Bool{
        let userInfo = UserDataStruct()
        if let _ = userInfo.id {
            return true
        }
        return false
    }
    
    @IBAction func twitterLogin(sender: AnyObject) {
        if !checkForLocationAccess() {
            return
        }
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                //self.dict.setValue(session!.userName, forKey: "username")
                //self.dict.setValue(session!.userID, forKey: "id")
                print(session?.userID)
                let client = TWTRAPIClient()
                client.loadUserWithID(session!.userID) { (user, error) -> Void in
                    self.dict.setValue(session?.userID, forKey: "id")
                    self.dict.setValue(session?.userName, forKey: "username")
                    self.dict.setValue(user?.profileImageMiniURL, forKey: "profileImage")
                    self.dict.setValue("Twitter", forKey: "type")
                    
                    self.loginFbUser()
                }
            } else {
                print("error: \(error?.localizedDescription)");
            }
        }
    }
    
    @IBAction func btnFbLogin(sender: AnyObject) {
        if !checkForLocationAccess() {
            return
        }
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            if reachability.isReachable()  {
                
                let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                
                fbLoginManager .logInWithReadPermissions(["public_profile", "email"], handler: {
                    (result, error) -> Void in
                    
                    if result == nil{
                        return
                    }
                    
                    if result.isCancelled {
                        // Handle cancellations
                        fbLoginManager.logOut()
                    }else if (error != nil) {
                        //showAlertView("Error", message: "Sorry! Can't connect through facebook.", controller: self)
                        PixaPalsErrorType.FacebookLoginConnectionError.show(self)
                    }else{
                        let fbloginresult : FBSDKLoginManagerLoginResult = result
                        
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            self.getFBUserData()
                        }
                    }
                })
                
            } else{
                
                
                return
                
            }
        }catch{
            PixaPalsErrorType.FacebookLoginConnectionError.show(self)
            //showAlertView("Error", message: "Sorry! Can't connect through facebook.", controller: self)
        }
    }
    
    func checkForLocationAccess() -> Bool {
        if let _ = location {
            return true
        }
        PixaPalsErrorType.LocationNotEnabledError.show(self)
        return false
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(thumb), email, website, gender, hometown, birthday"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                print(FBSDKAccessToken.currentAccessToken().tokenString)

                if (error == nil){
                    print(result)
                    self.dict = result as! NSMutableDictionary
                    self.dict.setValue("facebook", forKey: "type")
                    
                    if let _ = self.location {
                        self.loginFbUser()
                    }
                    
                    NSLog(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                } else {
                    PixaPalsErrorType.CantGetUserInfoFromFacebookError.show(self)
                    //showAlertView("Error", message: "Sorry! Can't connect through facebook. Can't access your information.", controller: self)
                }
            })
        }

        let request = FBSDKGraphRequest(graphPath:"me/taggable_friends", parameters: ["limit" : "1000","fields": "id"]);
        
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                //print("Friends are : \(result)")

               // print("Friends are : \(result.count)")
                
                self.friendsList = result as! NSMutableDictionary

                
            } else {
                PixaPalsErrorType.CantGetFriendInfoFromFacebookError.show(self)
                print("Error Getting Friends \(error)");
            }
        }

        
        var requestx = FBSDKGraphRequest(graphPath:"me/friends", parameters: nil);
        
        requestx.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                print("Friends are : \(result)")
                print("Friends are : \(result.count)")
                


            } else {
                PixaPalsErrorType.CantGetFriendInfoFromFacebookError.show(self)
                print("Error Getting Friends \(error)");
            }
        }
}
    
    func loginFbUser(){
        
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            if reachability.isReachable()  {
                
                
                var registerUrlString = "\(apiUrl)api/v1/login"
                
                registerUrlString = registerUrlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                let name = self.dict.objectForKey("name") as? String ?? (self.dict.objectForKey("username") as? String ?? "")
                let username = self.dict.objectForKey("username") as? String ?? name.stringByReplacingOccurrencesOfString(" ", withString: "_")
                let id = self.dict.objectForKey("id") as! String
                let type = self.dict.objectForKey("type") as! String
                
                let parametersToPost: [String: AnyObject] = [
                    "profileid": id,
                    "name": name,
                    "type": type,
                    "gender": self.dict["gender"] ?? "Don't Share",
                    "latitude": String(location.latitude),
                    "longitude": String(location.longitude),
                    "email": self.dict["email"] ?? "",
                    "username": username
                ]
                
                //print(parametersToPost, terminator: "")
                
                requestWithDeviceTokenInParam(.POST, registerUrlString, parameters: parametersToPost)
                    .responseJSON { response in
                        debugPrint(response)
                        
                        switch response.result {
                        case .Success(let data):
                            if let dict = data["user"] as? [String: AnyObject] {
                                UserDataStruct().saveUserInfoFromJSON(jsonContainingUserInfo: dict)
                                self.openTabView()
                            }
                            else {
                                print("Invalid Username/Password: \(data["message"])")
                                //showAlertView("Error", message: "The email or password you have entered does not match any account.", controller: self)
                                //print("Invalid Username/Password: \(data["message"])")
                                PixaPalsErrorType.CantAuthenticateError.show(self)
                                
                            }
                        case .Failure(let error):
                            //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
                            //print("Error in connection \(error)")
                            PixaPalsErrorType.ConnectionError.show(self)
                        }
                        
                }
                
            } else{
                
                //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
                PixaPalsErrorType.ConnectionError.show(self)
                return
                
            }}catch{
                PixaPalsErrorType.ConnectionError.show(self)
                //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
        }
        
    }
    
    
}


extension ViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.location = newLocation.coordinate
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.Denied.rawValue {
            //showAlertView("Access Denied", message: "Location access is denied. You can't proceed. Please change location preference to this app from setting.", controller: self)
            self.manager.stopUpdatingLocation()
            PixaPalsErrorType.LocationAccessDeniedError.show(self)
        }
    }
}

