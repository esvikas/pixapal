//
//  ProfileEditViewController.swift
//  Pixapals
//
//  Created by ak2g on 1/19/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire

class ProfileEditViewController: UIViewController {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var webSiteTextField: UITextField!
    @IBOutlet var bioTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var oldPasswordTextField: UITextField!
    
    @IBOutlet var conformPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    let nsUserDefault = NSUserDefaults.standardUserDefaults()
    var dataSource=UserDataStruct()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text=dataSource.username
        emailTextField.text=dataSource.email
        bioTextField.text = dataSource.bio
        phoneTextField.text = dataSource.phone
        webSiteTextField.text = dataSource.website
        genderTextField.text = dataSource.gender.rawValue
        
        //        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "tick_green"), style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = newBackButton;
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)

    }
    
    
    
    
    func back(sender: UIBarButtonItem) {
        
        if newPasswordTextField != nil && conformPasswordTextField != nil {
        if newPasswordTextField.text != conformPasswordTextField.text {
            
            appDelegate.ShowAlertView("Sorry", message: "Password didn't match")
            conformPasswordTextField.text=""
            newPasswordTextField.text=""
            oldPasswordTextField.text=""
            return
            }}
        
        if newPasswordTextField == nil {
           newPasswordTextField.text=""
        }
        
       if conformPasswordTextField == nil {
        conformPasswordTextField.text=""

        }
        if oldPasswordTextField == nil {
            oldPasswordTextField.text=""

        }
        
        let registerUrlString = "\(apiUrl)api/v1/profile/update"
        
        
        
        
        let parameters: [String: AnyObject] =
        [
            "user_id": "\(dataSource.id)",
            "username": self.userNameTextField.text!,
            "website": self.webSiteTextField.text!,
            "bio": self.bioTextField.text!,
            "email": self.emailTextField.text!,
            "phone": self.phoneTextField.text!,
            "gender": self.genderTextField.text!,
            "old_password" : oldPasswordTextField.text!,
            "new_password" : newPasswordTextField.text!

        ]
        
        let headers = [
            "X-Auth-Token" : String(UserDataStruct().api_token!),
        ]
        
        
        
        
        requestWithHeaderXAuthToken(.POST, registerUrlString, parameters: parameters)
            .responseJSON { response in
                debugPrint(response)     // prints detailed description of all response properties
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                
                
                if let HTTPResponse = response.response {
                    
                    let statusCode = HTTPResponse.statusCode
                    
                    if statusCode==200{
                        
                        self.navigationController!.popViewControllerAnimated(true)
                        
                    }else  {
                        
                    
                        
                        
                    }
                }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
