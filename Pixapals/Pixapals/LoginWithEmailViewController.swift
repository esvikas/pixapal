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
 import MBProgressHUD


class LoginWithEmailViewController: UIViewController {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    var password: String = ""
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))


    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextfield.delegate=self
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogin(sender: AnyObject) {
        
        if appDelegate.internetConnected() == true{
        loginWithEmail()
        }
        

    }
    
    func loginWithEmail(){
        
        
        self.blurEffectView.alpha = 0.4
        self.blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Posting"

        let loginUrlString = "\(apiUrl)api/v1/login-using-email"
        
        let validator = Validator()
        if !validator.isValidEmail(emailTextfield.text!){
            print("invalid email")
            
            appDelegate.ShowAlertView("Error", message: "Invalid email address")
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.blurEffectView.removeFromSuperview()
            return
        }
        
        let parametersToPost = [
            "email": emailTextfield.text!,
            "password": password,
            "device_token" : appDelegate.deviceTokenString ?? "werrrrrr"
        ]
        
        Alamofire.request(.POST, loginUrlString, parameters: parametersToPost)
            .responseJSON { response in
                
                switch response.result {
                case .Success(let data):
                    if let dict = data["user"] as? [String: AnyObject] {
                        print(dict)
                        let userInfoStruct = UserDataStruct()
                        userInfoStruct.saveUserInfoFromJSON(jsonContainingUserInfo: dict)
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewControllerWithIdentifier("tabView")
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.blurEffectView.removeFromSuperview()

                        
                    } else {
                        print(data)
                        print("Invalid Username/Password: \(data["message"])")
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.blurEffectView.removeFromSuperview()
                        appDelegate.ShowAlertView("Error", message: "Invalid email address or password")
       

                    }
                case .Failure(let error):
                    showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
                    //print("Error in connection \(error)")
                }
        }
        
    }

    
}
 
 extension LoginWithEmailViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        
        if(string != "") {
//
//            print("Backspace pressed");
//            return true;
//        }
//    }
        password = password+string
        textField.text = textField.text!+"*"
        print("\(password)")
            return false

        } else {
            
            if password.characters.count != 0 {
            var truncated = password.substringToIndex(password.endIndex.predecessor())
password = truncated
            print("\(password)")
        }
            return true
        }
    }
        
 }
