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
import CoreLocation

class RegisterViewController: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, CLLocationManagerDelegate {
    
    var manager = CLLocationManager()
    var location: CLLocationCoordinate2D!
    var lo = false
    
    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet var btnGender: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        textFieldUsername.delegate=self
        
        textFieldFullName.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        textFieldEmail.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        textFieldUsername.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        textFieldPassword.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        textFieldConfirmPassword.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        let btnTitle = userGender ?? "Sex"
        btnGender.setTitle(btnTitle, forState: .Normal)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.location = newLocation.coordinate
        print(newLocation.coordinate.longitude)
        print(newLocation.coordinate.latitude)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.Denied.rawValue {
            //appDelegate.ShowAlertView("Access Denied", message: "Location access is denied. You can't proceed. Please change location preference to this app from setting.")
            self.manager.stopUpdatingLocation()
            PixaPalsErrorType.LocationAccessDeniedError.show(self)
        }
    }
    
    
    @IBAction func btnGender(sender: AnyObject) {
        
        abc()
        
    }
    
    @IBAction func confirmButtonClicked(sender: AnyObject) {
        if let _ = location {
            self.registerWithEmail()
            //self.registerWithEmailStatus = true
        } else {
            PixaPalsErrorType.LocationNotEnabledError.show(self)
            //appDelegate.ShowAlertView("Location not Enabled", message: "Please enable location. Also allow app to access location from settings.")
        }
    }
    
    func registerWithEmail(){
        let registerUrlString = "\(apiUrl)api/v1/register"
        
        // let deviceToken = nsUserDefault.objectForKey("deviceTokenString") as! String
        let deviceToken = appDelegate.deviceTokenString ?? "wewrwer"
        
        if self.textFieldFullName.text!.isEmpty {
            PixaPalsErrorType.EmptyFullNameError.show(self)
            //appDelegate.ShowAlertView("Full Name Empty", message: "Fullname field is empty.")
            return
        }
        
        if !Validator().isValidEmail(self.textFieldEmail.text!) {
            PixaPalsErrorType.InvalidEmailError.show(self)
            //appDelegate.ShowAlertView("Invalid Email", message: "Please enter valid email address.")
            return
        }
        
        if self.textFieldUsername.text!.isEmpty {
            PixaPalsErrorType.EmptyUsernameFieldError.show(self)
            //appDelegate.ShowAlertView("Username Empty", message: "Username field is empty.")
            return
        }
       
        if self.textFieldPassword.text!.isEmpty {
            PixaPalsErrorType.EmptyPasswordFieldError.show(self)
            //appDelegate.ShowAlertView("Password Empty", message: "Password field is empty.")
            return
        }
        
        if self.textFieldPassword.text! != self.textFieldConfirmPassword.text! {
            //appDelegate.ShowAlertView("Password Not Confirmed", message: "Password and Confirm Password doesn't match.")
            PixaPalsErrorType.PasswordNotConfirmedError.show(self)
            return
        }
        
        if !(self.btnGender.titleLabel?.text == "Male" || self.btnGender.titleLabel?.text == "Female" || self.btnGender.titleLabel?.text == "Don't Share")  {
            PixaPalsErrorType.GenderNotSelectedError.show(self)
            //appDelegate.ShowAlertView("Gender Not Selected", message: "Gender is not selected.")
            return
        }
        
        //let location = LocationManager().getLocation()
        //LocationManager(manager: CLLocationManager() ,afterLocationRetrived: { (location) -> () in
        let parameters: [String: AnyObject] =
        [
            "name": self.textFieldFullName.text!,
            "email": self.textFieldEmail.text!,
            "username": self.textFieldUsername.text!,
            "password": self.textFieldPassword.text!,
            "password_confirmation": self.textFieldConfirmPassword.text!,
            "latitude": location.latitude,
            "longitude": location.longitude,
            "website": "",
            "bio": "",
            "phone": "",
            "gender": self.btnGender.titleLabel?.text ?? "",
        ]
        
        requestWithDeviceTokenInParam(.POST, registerUrlString, parameters: parameters)
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
                    }
                    else {
                        print(data)
                        print("Invalid Username/Password: \(data["message"])")
                        PixaPalsErrorType.CantAuthenticateError.show(self)
                    }
                case .Failure(let error):
                    //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
                    //print("Error in connection \(error)")
                    PixaPalsErrorType.ConnectionError.show(self)
                }
        }
        
//=======
//        LocationManager(manager: CLLocationManager() ,afterLocationRetrived: { (location) -> () in
//            let parameters: [String: AnyObject] =
//            [
//                "name": self.textFieldFullName.text!,
//                "email": self.textFieldEmail.text!,
//                "username": self.textFieldUsername.text!,
//                "password": self.textFieldPassword.text!,
//                "password_confirmation": self.textFieldConfirmPassword.text!,
//                "latitude": location.latitude,
//                "longitude": location.longitude,
//                "website": "",
//                "bio": "",
//                "phone": "",
//                "gender":"",
//                "device_token" : deviceToken
//            ]
//            print(parameters)
//            Alamofire.request(.POST, registerUrlString, parameters: parameters)
//                .responseJSON { response in
//                    
//                    switch response.result {
//                    case .Success(let data):
//                        if let dict = data["user"] as? [String: AnyObject] {
//                            let userInfoStruct = UserDataStruct()
//                            userInfoStruct.saveUserInfoFromJSON(jsonContainingUserInfo: dict)
//                            
//                            self.loginWithEmail = true
//                        }
//                        else {
//                            print(data)
//                            print("Invalid Username/Password: \(data["message"])")
//                        }
//                    case .Failure(let error):
//                        print("Error in connection \(error)")
//                    }
//            }
//        })

    }
    func abc (){
        let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("GenderSelectionView"))! as! GenderSelectionView
        popoverContent.delegate = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        
        popoverContent.preferredContentSize = CGSizeMake(self.view.layer.frame.width,170)
        popover!.delegate = self
        popover!.sourceView = self.btnGender
        popover!.sourceRect = self.btnGender.frame
        self.presentViewController(nav, animated: false, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }

}
extension RegisterViewController : UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        
        if newLength == 10 {
            appDelegate.ShowAlertView("Sorry", message: "Maxum 10 characters allowed")
        }
        return newLength <= 10
    }
    
}
extension RegisterViewController : funcDelegate {
    func chooseSex(sex:String) {
        
        let btnTitle = sex ?? ""
        btnGender.setTitle(btnTitle, forState: .Normal)
        btnGender.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)

        
    }
}
