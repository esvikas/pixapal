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


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonClicked(sender: AnyObject)  {
    let registerUrlString = "192.168.0.77/API/public/api/v1/register"
    
    let nsUserDefault = NSUserDefaults.standardUserDefaults()
    
    let parameters: [String: AnyObject] =
        [
    "user_id": "\(nsUserDefault.objectForKey("user_id") as! Int)",
    "username": self.userNameTextField.text!,
    "website": self.webSiteTextField.text!,
    "bio": self.bioTextField.text!,
    "email": self.emailTextField.text!,
    "phone": self.phoneTextField.text!,
    "gender": self.genderTextField.text!
        ]

  
    
    
    Alamofire.request(.POST, registerUrlString, parameters: parameters)
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
    
    
    
    }else  {
    
    
    
    
    }
    }
    }
    
    }


}
