//
//  RegisterViewController.swift
//  Pixapals
//
//  Created by DARI on 1/11/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {

    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.navigationBarHidden = false
    }

    @IBAction func confirmButtonClicked(sender: AnyObject) {
        let registerUrlString = "192.168.0.77/API/public/api/v1/register"
        
        let nsUserDefault = NSUserDefaults.standardUserDefaults()
        let deviceToken = nsUserDefault.objectForKey("deviceTokenString") as! String

        let parameters: [String: AnyObject] =
        [
            "name": self.textFieldFullName.text!,
            "email": self.textFieldEmail.text!,
            "username": self.textFieldUsername.text!,
            "password": self.textFieldPassword.text!,
            "password_confirmation": self.textFieldConfirmPassword.text!,
            "latitude": "",
            "longitude": "",
            "website": "",
            "bio": "",
            "phone": "",
            "gender":"",
            "device_token" : deviceToken
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
