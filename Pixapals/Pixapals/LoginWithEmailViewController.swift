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
    
    @IBOutlet weak var loginButton: UIButton!
    
    var password: String = ""
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.enabled = false
        loginButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        
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
        loadingNotification.labelText = "Logging In"
        
        let loginUrlString = "\(apiUrl)api/v1/login-using-email"
        
//        let validator = Validator()
//        if !validator.isValidEmail(emailTextfield.text!){
//            print("invalid email")
//            PixaPalsErrorType.InvalidEmailError.show(self)
//            //appDelegate.ShowAlertView("Error", message: "Invalid email address")
//            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//            self.blurEffectView.removeFromSuperview()
//            return
//        }
        
        
        let parametersToPost = [
            "email": emailTextfield.text!,
            "password": password,
            //"device_token" : appDelegate.deviceTokenString ?? "werrrrrr"
        ]
        
        requestWithDeviceTokenInParam(.POST, loginUrlString, parameters: parametersToPost)
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
                        //appDelegate.ShowAlertView("Error", message: "Invalid email address or password")
                        PixaPalsErrorType.InvalidEmailPasswordError.show(self)
                        
                    }
                case .Failure(let error):
                    //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
                    //print("Error in connection \(error)")
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.blurEffectView.removeFromSuperview()
                    PixaPalsErrorType.ConnectionError.show(self)
                }
        }
        
    }
    
    
 }
 
 extension LoginWithEmailViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        var textOfTextField = textField.text! + string
        textOfTextField = (range.length == 1) ? textOfTextField.substringToIndex(textOfTextField.endIndex.advancedBy(-1)) : textOfTextField
        let passwordText = (textField == passwordTextfield) ? textOfTextField : passwordTextfield.text!
        let emailText = (textField == emailTextfield) ? textOfTextField : emailTextfield.text!
        func isValidPassword() -> Bool {
            if passwordText.characters.count > 0 {
                return true
            } else {
                return false
            }
        }
        
        let validator = Validator()
        if isValidPassword() && validator.isValidEmail(emailText) {
            loginButton.enabled = true
        } else {
            loginButton.enabled = false
        }
        
        if textField == passwordTextfield {
            if(string != "") {
                
                password = password+string
                textField.text = textField.text!+"*"
                return false
                
            } else {
                
                if password.characters.count != 0 {
                    var truncated = password.substringToIndex(password.endIndex.predecessor())
                    password = truncated
                }
            }
        }
        return true
    }
    
 }
