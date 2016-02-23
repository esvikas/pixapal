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


class ViewController: UIViewController {
    
    var manager = CLLocationManager()
    var location: CLLocationCoordinate2D!
    
    var dict : NSDictionary!
    
    var friendsList : NSDictionary!

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
    
    
    @IBAction func btnFbLogin(sender: AnyObject) {
        
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
                        showAlertView("Error", message: "Sorry! Can't connect through facebook.", controller: self)
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
            
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, website, gender, hometown, birthday"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                print(FBSDKAccessToken.currentAccessToken().tokenString)

                if (error == nil){
                    print(result)
                    self.dict = result as! NSDictionary
                    
                    if let _ = self.location {
                        self.loginFbUser()
                    }
                    
                    NSLog(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                }
            })
        }

        let request = FBSDKGraphRequest(graphPath:"me/taggable_friends", parameters: ["limit" : "1000","fields": "id"]);
        
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                print("Friends are : \(result)")

                print("Friends are : \(result.count)")
                
                self.friendsList = result as! NSDictionary

                
            } else {
                print("Error Getting Friends \(error)");
            }
        }

        
        var requestx = FBSDKGraphRequest(graphPath:"me/friends", parameters: nil);
        
        requestx.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                print("Friends are : \(result)")
                print("Friends are : \(result.count)")
                


            } else {
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
                
                let fbName: String = self.dict.objectForKey("name") as! String
                let userName = fbName.stringByReplacingOccurrencesOfString(" ", withString: "_")
                let fbId: String = self.dict.objectForKey("id") as! String
                
                let parametersToPost: [String: AnyObject] = [
                    "profileid": fbId,
                    "name": fbName,
                    "type":"facebook",
                    "gender": self.dict["gender"]!,
                    "latitude": String(location.latitude),
                    "longitude": String(location.longitude),
                    "email": self.dict["email"]!,
                    "username": userName
                ]
                
                print(parametersToPost, terminator: "")
                
                requestWithDeviceTokenInParam(.POST, registerUrlString, parameters: parametersToPost)
                    .responseJSON { response in
                        debugPrint(response)     // prints detailed description of all response properties
                        
                        //                        print(response.request)  // original URL request
                        //                        print(response.response) // URL response
                        //                        print(response.data)     // server data
                        //                        print(response.result)   // result of response serialization
                        
                        switch response.result {
                        case .Success(let data):
                            if let dict = data["user"] as? [String: AnyObject] {
                                print(dict)
                                UserDataStruct().saveUserInfoFromJSON(jsonContainingUserInfo: dict)
                                self.openTabView()
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


extension ViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.location = newLocation.coordinate
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.Denied.rawValue {
            appDelegate.ShowAlertView("Access Denied", message: "Location access is denied. You can't proceed. Please change location preference to this app from setting.")
            self.manager.stopUpdatingLocation()
        }
    }
}

