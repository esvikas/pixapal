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

class RegisterViewController: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet var btnGender: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldFullName.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        textFieldEmail.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        textFieldUsername.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        textFieldPassword.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        textFieldConfirmPassword.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.navigationBarHidden = false
    }
    @IBAction func btnGender(sender: AnyObject) {
        
        abc()
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
        //let registerUrlString = "\(apiUrl)api/v1/login-using-email"
        let registerUrlString = "\(apiUrl)api/v1/register"
        
        let nsUserDefault = NSUserDefaults.standardUserDefaults()
        // let deviceToken = nsUserDefault.objectForKey("deviceTokenString") as! String
        let deviceToken = "ff34dsft53fsdds33"
        if !Validator().isValidEmail(self.textFieldEmail.text!) {
            print("invalid email")
            return
        }
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
                            let userInfoStruct = UserDataStruct()
                            userInfoStruct.saveUserInfoFromJSON(jsonContainingUserInfo: dict)
                            
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
    func abc (){
        

        
        let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("GenderSelectionView"))! as UIViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(self.view.layer.frame.width,120)
        popover!.delegate = self
        popover!.sourceView = self.btnGender
        popover!.sourceRect = self.btnGender.frame
        
        self.presentViewController(nav, animated: false, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        abc()
    }
    
}
