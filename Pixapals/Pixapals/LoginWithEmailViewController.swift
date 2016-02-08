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
        
        if appDelegate.internetConnected() == true{
        loginWithEmail()
        }
        

    }
    
    func loginWithEmail(){

        let loginUrlString = "\(apiUrl)api/v1/login-using-email"
        
        let validator = Validator()
        if !validator.isValidEmail(emailTextfield.text!){
            print("invalid email")
            return
        }
        
        let parametersToPost = [
            "email": emailTextfield.text!,
            "password": passwordTextfield.text!
        ]
        
        Alamofire.request(.POST, loginUrlString, parameters: parametersToPost)
            .responseJSON { response in
                
                switch response.result {
                case .Success(let data):
                    if let dict = data["user"] as? [String: AnyObject] {
                        
                        let userInfoStruct = UserDataStruct()
                        userInfoStruct.saveUserInfoFromJSON(jsonContainingUserInfo: dict)
                        
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
        }
        
    }
    
    
    
}
