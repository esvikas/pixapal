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
//        let email = self.textFieldEmail.text
//        let password = self.textFieldPassword.text
//        let confirmPassword = self.textFieldConfirmPassword.text
//        let name = self.textFieldFullName.text
//        let username = self.textFieldUsername.text
//        
//        let validator = Validator()
//        print(validator.isValidEmail(email!))
        
        let registerUrlString = "http://192.168.0.77/API/public/api/v1/register"
        
        let nsUserDefault = NSUserDefaults.standardUserDefaults()
        // let deviceToken = nsUserDefault.objectForKey("deviceTokenString") as! String
        let deviceToken = "ff34dsft53fsdds33"
        
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
                
                switch response.result {
                case .Success(let data):
                        if let dict = data["user"] as? [String: AnyObject] {
                            var newDict = [String: AnyObject]()
                            for (item, value) in dict where "<null>" != "\(value.description)" {
                                newDict[item] = "\(value)"
                            }
                            print(newDict)
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            userDefaults.setObject(newDict, forKey: "user_info")
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyBoard.instantiateViewControllerWithIdentifier("tabView")
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    else {
                        print(data)
                        print("Invalid Username/Password: \(data["message"])")
                    }
                case .Failure(let error):
                    print("Error in connection \(error)")
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
