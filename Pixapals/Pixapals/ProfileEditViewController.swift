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
    
    let nsUserDefault = NSUserDefaults.standardUserDefaults()
    var dataSource=UserDataStruct()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text=dataSource.username
        emailTextField.text=dataSource.email
        
        
        
        //        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "tick_green"), style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = newBackButton;
        
    }
    
    
    
    
    func back(sender: UIBarButtonItem) {
        
        
        
        
        let registerUrlString = "\(apiUrl)api/v1/profile/update"
        
        
        
        
        let parameters: [String: AnyObject] =
        [
            "user_id": "\(dataSource.id)",
            "username": self.userNameTextField.text!,
            "website": self.webSiteTextField.text!,
            "bio": self.bioTextField.text!,
            "email": self.emailTextField.text!,
            "phone": self.phoneTextField.text!,
            "gender": self.genderTextField.text!
        ]
        
        let headers = [
            "X-Auth-Token" : "c353c462bb19d45f5d60d14ddf7ec3664c0eeaaaede6309c03dd8129df745b91",
        ]
        
        
        
        
        Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers)
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
