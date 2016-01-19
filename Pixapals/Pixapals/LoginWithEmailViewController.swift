//
//  LoginWithEmailViewController.swift
//  Pixapals
//
//  Created by DARI on 1/12/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire

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
        loginWithEmail()
    }

    func loginWithEmail(){
        
        
        
        let registerUrlString = "\(apiUrl)api/v1/login-using-email"
        
        let parametersToPost = [
            "email": emailTextfield.text!,
            "password": passwordTextfield.text!
 
        ]
        
        print(parametersToPost, terminator: "")

        
        
        
        Alamofire.request(.POST, registerUrlString, parameters: parametersToPost)
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
