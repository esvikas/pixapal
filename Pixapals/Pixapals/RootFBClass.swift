//
//  RootFBClass.swift
//  Piper-Becon
//
//  Created by es-mac-02 on 5/8/15.
//  Copyright (c) 2015 es. All rights reserved.
//

import UIKit
import FBSDKLoginKit



protocol LoginSuccessDelegate{
    func loginSuccess()
}

class RootFBClass: NSObject,FBSDKLoginButtonDelegate {
    
    var delegate:LoginSuccessDelegate?
    @IBOutlet weak var FirstameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    

    func returnUserData(){
        
        //loginStatus.text = "You are currently Logged in as "
        
        // var token = FBSDKAccessToken.currentAccessToken()
        // //print("the tokent is \(token.tokenString)")
        
        //to get basic info
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({(connection,result,error)-> Void in
            ////print(result, terminator: "")
            
            let id : NSString = result.valueForKey("id") as! NSString
            ////print("id is: \(id)", terminator: "")
            
            let FName : NSString = result.valueForKey("name") as! NSString
            ////print("User name is: \(FName)", terminator: "")
            
            
            
            let userEmail : NSString = result.valueForKey("email") as! NSString
            ////print("User Email is: \(userEmail)", terminator: "")

            
//            let access_token : NSString = result.valueForKey("access_token") as! NSString
//            //print("access_token is: \(userEmail)")
            
        })
        
        //request for pages liked by user
        let LikesgraphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/likes", parameters: nil)
        LikesgraphRequest.startWithCompletionHandler({(connection,result,error)-> Void in
            
            ////print("\(result)", terminator: "")
            
        })
        
        
        //request for friends name
        let FriendsgraphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
        FriendsgraphRequest.startWithCompletionHandler({(connection,result,error)-> Void in
            
            ////print("\(result)", terminator: "")
            
            
        })
        
        //request for age because public profile doesnot returns it, so made a different request
        
        let AgegraphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me?fields=age_range", parameters: nil)
        AgegraphRequest.startWithCompletionHandler({(connection,result,error)-> Void in
            
            ////print("the age is \(result)", terminator: "")
            
        })

        
    }
    

    
    

    
        //delegate that returns the users info
    
    
        func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
    
    
            if error != nil{
                ////print("error might be of process", terminator: "")
    
            }else if result.isCancelled{
                ////print("user cancelled the permission", terminator: "")
    
            }else {
    
                if result.grantedPermissions.contains("public_profile") && result.grantedPermissions.contains("email") && result.grantedPermissions.contains("user_friends") {
    
                    ////print("public profile, email, user_friends info is granted", terminator: "")
                   
                    returnUserData()
                    
                    delegate?.loginSuccess()
    
                }else{
                    ////print("something is missing,please accept all ", terminator: "")
    
                }
    
            }
    
        }
    
    
    
   // delegate to know the user logout state
    
        func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
    
    
            ////print("user logs out now ", terminator: "")
           // loginStatus.text = "Successfully logged out"
           // name.text = ""
    
            FBSDKAccessToken.setCurrentAccessToken(nil)
            FBSDKProfile.setCurrentProfile(nil)
            
            let accesstoken: FBSDKLoginManager = FBSDKLoginManager()
            accesstoken.logOut()
            
            
        }
    

   
}
