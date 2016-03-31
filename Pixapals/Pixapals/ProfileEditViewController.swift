//
//  ProfileEditViewController.swift
//  Pixapals
//
//  Created by ak2g on 1/19/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import ImagePicker
import Kingfisher

protocol ProfileEditViewControllerDelegate {
    func reloadDataAfterProfileEdit()
}


class ProfileEditViewController: UIViewController, UINavigationControllerDelegate, ImagePickerDelegate, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var webSiteTextField: UITextField!
    @IBOutlet var bioTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var btnChangePic: UIButton!
    @IBOutlet var userProfilePic: UIImageView!
    @IBOutlet var btnGender: UIButton!
    @IBOutlet weak var btnEditProfileImage: UIButton!
    @IBOutlet var conformPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    
    var delegate: ProfileEditViewControllerDelegate!
    
    let nsUserDefault = NSUserDefaults.standardUserDefaults()
    
    var userDataAsObject: UserInDetailJSON!
    
    
    var dataSource=UserDataStruct()
    var newBackButton = UIBarButtonItem()
    var newDoneButton = UIBarButtonItem()
    
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfilePic.layer.cornerRadius=userProfilePic.frame.height/2
        userProfilePic.clipsToBounds=true
        
        //        btnEditProfileImage.layer.cornerRadius = btnEditProfileImage.frame.height/2
        //        btnEditProfileImage.clipsToBounds = true
        //        btnEditProfileImage.layer.borderColor = UIColor.grayColor().CGColor
        //        btnEditProfileImage.layer.borderWidth = 1
        
        userNameTextField.text=userDataAsObject.username
        emailTextField.text=userDataAsObject.email
        bioTextField.text = userDataAsObject.bio
        phoneTextField.text = userDataAsObject.phone
        webSiteTextField.text = userDataAsObject.website
        btnGender.setTitle(userDataAsObject.gender, forState: .Normal)
        btnGender.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        let lbl = UILabel(frame: CGRect(x: phoneTextField.frame.origin.x, y: phoneTextField.frame.origin.y, width: 15.0, height: phoneTextField.frame.height))
        lbl.text = "+"
        lbl.textAlignment = .Right
        phoneTextField.leftViewMode = .Always
        phoneTextField.leftView = lbl
        
        ////print(userDataAsObject.gender)
        //        genderTextField.text = userDataAsObject.gender ?? ""
        
        ////print(userDataAsObject.photo_thumb)
        userProfilePic.kf_setImageWithURL(NSURL(string: userDataAsObject.photo_thumb ?? "")!, placeholderImage: UIImage(named: "global_feed_user"))
        
        ////print(userDataAsObject.photo_thumb)
        
        self.navigationItem.hidesBackButton = true
        newDoneButton = UIBarButtonItem(image: UIImage(named: "tick_green"), style: UIBarButtonItemStyle.Plain, target: self, action: "done:")
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = newDoneButton;
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        
        newBackButton = UIBarButtonItem(image: UIImage(named: "close"), style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = newBackButton;
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
    }
    
    func back(sender: UIBarButtonItem) {
        
        self.navigationController!.popViewControllerAnimated(true)
        
        
    }
    
    @IBAction func btnChangePic(sender: AnyObject) {
        
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            if reachability.isReachable()  {
                
                
                let imagePickerController = ImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.imageLimit = 1
                presentViewController(imagePickerController, animated: true, completion: nil)
                Configuration.doneButtonTitle = "Next"
                Configuration.noImagesTitle = "Sorry! There are no images here!"
                
            }
            
        } catch {
            ////print("Unable to create Reachability")
            return
        }
        
    }
    
    @IBAction func btnGender(sender: AnyObject) {
        
        abc()
        
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
        popover!.sourceRect = CGRect(x: self.view.layer.frame.width, y: self.view.layer.frame.height/2, width: 10, height: 10)
        self.presentViewController(nav, animated: false, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
    
    func changeProfilePic(image: UIImage){
        
        self.navigationItem.hidesBackButton = true
        newDoneButton.enabled=false
        newBackButton.enabled=false
        
        btnChangePic.enabled=false
        
        
        
        let fieldNameArray = "photo"
        
        
        
        let parameters = [
            "user_id" : String(UserDataStruct().id!)
            
        ]
        let headers = [
            "X-Auth-Token" : UserDataStruct().api_token!,
        ]
        
        // example image data
        
//        print(parameters)
//        //print(headers)
        
        // CREATE AND SEND REQUEST ----------
        
        var  imageData=((data:(UIImageJPEGRepresentation(image , 1))!))
        
        
        self.blurEffectView.alpha = 0.4
        self.blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Uploading"
        self.navigationItem.hidesBackButton = true
        
        
        
        SRWebClient.POST(URLType.ProfilePhoto.make())
            
            .data(imageData, fieldName:fieldNameArray, data:parameters)
            .headers(headers)
            
            .send({(response:AnyObject!, status:Int) -> Void in
                
                //                    _ = JSON(response)
                ////print(response)
                
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.blurEffectView.removeFromSuperview()
                
                //                self.navigationItem.hidesBackButton = false
                self.newBackButton.enabled=true
                self.newDoneButton.enabled=true
                self.userProfilePic.image=image
                
                
                },failure:{(response:AnyObject!, error:NSError!) -> Void in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.blurEffectView.removeFromSuperview()
                    
                    //                    self.navigationItem.hidesBackButton = false
                    self.newBackButton.enabled=true
                    self.newDoneButton.enabled=true
                    
                    PixaPalsErrorType.ConnectionError.show(self)
            })
        
    }
    
    func done(sender: UIBarButtonItem) {
        
        self.navigationItem.hidesBackButton = true
        //newDoneButton.enabled=false
        //newBackButton.enabled=false
        
        if !Validator().isValidEmail(emailTextField.text!) {
            PixaPalsErrorType.InvalidEmailError.show(self)
            return
        }
        if (newPasswordTextField.text! != "" || conformPasswordTextField.text! != "") || (oldPasswordTextField.text! != ""){
            func emptyTextFields(){
                conformPasswordTextField.text=""
                newPasswordTextField.text=""
                oldPasswordTextField.text=""
            }
            if oldPasswordTextField.text! == "" {
                emptyTextFields()
                PixaPalsErrorType.EmptyPasswordFieldError.show(self, message: "Old Password is required.")
            }
            if newPasswordTextField.text! == ""{
                PixaPalsErrorType.EmptyPasswordFieldError.show(self, message: "New password is required.")
                emptyTextFields()
                return
            }
            if newPasswordTextField.text != conformPasswordTextField.text {
                
                PixaPalsErrorType.PasswordNotConfirmedError.show(self)
                //appDelegate.ShowAlertView("Sorry", message: "Password didn't match")
                emptyTextFields()
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
        
        self.blurEffectView.alpha = 0.4
        self.blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Updating"
        
        self.navigationItem.hidesBackButton = true
        newDoneButton.enabled=false
        newBackButton.enabled=false
        
        
        let urlString = URLType.ProfileUpdate.make()
        
        
        let parameters: [String: AnyObject] =
        [
            "user_id": userDataAsObject.id!,
            "username": self.userNameTextField.text!,
            "website": self.webSiteTextField.text!,
            "bio": self.bioTextField.text!,
            "email": self.emailTextField.text!,
            "phone": self.phoneTextField.text!,
            
            "gender": self.btnGender.titleLabel?.text ?? "",
            "old_password" : oldPasswordTextField.text!,
            "new_password" : newPasswordTextField.text!
        ]
        
        let headers = [
            "X-Auth-Token" : String(UserDataStruct().api_token!),
        ]
        
        
        ////print(parameters)
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters:  parameters).giveResponseJSON(
            { (data) -> Void in
                if let isError = data["error"] as? Bool where isError == false{
                    self.userDataAsObject.username = self.userNameTextField.text
                    self.userDataAsObject.email = self.emailTextField.text
                    self.userDataAsObject.gender = self.btnGender.titleLabel?.text
                    self.userDataAsObject.phone = self.phoneTextField.text
                    self.userDataAsObject.website = self.webSiteTextField.text
                    self.userDataAsObject.bio = self.bioTextField.text
                    
                    self.delegate.reloadDataAfterProfileEdit()
                    //let user = UserFeedDistinction.sharedInstance.getUserWithId(self.userDataAsObject.id!)
                    UserFeedDistinction.sharedInstance.checkDistinctUser(self.userDataAsObject)

                    self.navigationController!.popViewControllerAnimated(true)
                }else {
                    
                    self.newBackButton.enabled=true
                    self.newDoneButton.enabled=true
                    func message() -> String? {
                        if let message = data["message"] as? [String] {
                            let msg = message.reduce("", combine: {
                                if $1 == "Old password didn't match." {
                                    self.oldPasswordTextField.text = ""
                                    self.newPasswordTextField.text = ""
                                    self.conformPasswordTextField.text = ""	
                                }
                                return $0 + "\n" + $1
                            })
                            return msg
                        }
                        return nil
                    }
                    ////print("Invalid Username/Password: \(data["message"])")
                    PixaPalsErrorType.CantAuthenticateError.show(self, title: nil, message: message())
                }
            }, errorBlock: {self}, onResponse: {
                //self.navigationItem.hidesBackButton = false
                self.newDoneButton.enabled=true
                self.newBackButton.enabled=true
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.blurEffectView.removeFromSuperview()
            }
            )
        
//        requestWithHeaderXAuthToken(.POST, urlString, parameters: parameters)
//            .responseJSON { response in
//                //                debug//print(response)     // //prints detailed description of all response properties
//                //
//                //                //print(response.request)  // original URL request
//                //                //print(response.response) // URL response
//                //                //print(response.data)     // server data
//                //                //print(response.result)   // result of response serialization
//                
//                //                if let JSON = response.result.value {
//                //                    //print("JSON: \(JSON)")
//                //                }
//                //
//                //                if let HTTPResponse = response.response {
//                //
//                //                    let statusCode = HTTPResponse.statusCode
//                //
//                //                    if statusCode==200{
//                //                        self.userDataAsObject.username = self.userNameTextField.text
//                //                        self.userDataAsObject.email = self.emailTextField.text
//                //                        self.userDataAsObject.gender = self.btnGender.titleLabel?.text
//                //                        self.userDataAsObject.phone = self.phoneTextField.text
//                //                        self.userDataAsObject.website = self.webSiteTextField.text
//                //                        self.userDataAsObject.bio = self.bioTextField.text
//                //
//                //                        self.delegate.reloadDataAfterProfileEdit()
//                //                        //let user = UserFeedDistinction.sharedInstance.getUserWithId(self.userDataAsObject.id!)
//                //                        UserFeedDistinction.sharedInstance.checkDistinctUser(self.userDataAsObject)
//                //
//                //                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                //                        self.blurEffectView.removeFromSuperview()
//                //                        self.navigationController!.popViewControllerAnimated(true)
//                //                    }else  {
//                //
//                //
//                //                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                //                        self.blurEffectView.removeFromSuperview()
//                //
//                //                        //self.navigationItem.hidesBackButton = false
//                //                        self.newBackButton.enabled=true
//                //                        self.newDoneButton.enabled=true
//                //                    }
//                //                }
//                
//                switch response.result {
//                case .Success(let data):
//                    //print(data)
//                    //let data = JSON(nsdata)
//                    if let isError = data["error"] as? Bool where isError == false{
//                        self.userDataAsObject.username = self.userNameTextField.text
//                        self.userDataAsObject.email = self.emailTextField.text
//                        self.userDataAsObject.gender = self.btnGender.titleLabel?.text
//                        self.userDataAsObject.phone = self.phoneTextField.text
//                        self.userDataAsObject.website = self.webSiteTextField.text
//                        self.userDataAsObject.bio = self.bioTextField.text
//                        
//                        self.delegate.reloadDataAfterProfileEdit()
//                        //let user = UserFeedDistinction.sharedInstance.getUserWithId(self.userDataAsObject.id!)
//                        UserFeedDistinction.sharedInstance.checkDistinctUser(self.userDataAsObject)
//                        
//                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                        self.blurEffectView.removeFromSuperview()
//                        self.navigationController!.popViewControllerAnimated(true)
//                    }else {
//                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                        self.blurEffectView.removeFromSuperview()
//                        
//                        //self.navigationItem.hidesBackButton = false
//                        self.newBackButton.enabled=true
//                        self.newDoneButton.enabled=true
//                        
////                        func message() -> String? {
////                            if let message = data["message"] as? [String: [String]] {
////                                let msg  = message.reduce("", combine: { (msg, message) -> String in
////                                    return msg + message.1.reduce("", combine: { (indivMsg, msg) -> String in
////                                        return indivMsg + "\n" + msg
////                                    })
////                                })
////                                return msg
////                            }
////                            return nil
////                        }
//                        func message() -> String? {
//                            if let message = data["message"] as? [String] {
//                                let msg = message.reduce("", combine: {
//                                    $0 + "\n" + $1
//                                })
//                                return msg
//                            }
//                           return nil
//                        }
//                        ////print("Invalid Username/Password: \(data["message"])")
//                        PixaPalsErrorType.CantAuthenticateError.show(self, title: nil, message: message())
//                    }
//                case .Failure(let error):
//                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                    self.blurEffectView.removeFromSuperview()
//                    PixaPalsErrorType.ConnectionError.show(self)
//                }
//        }
        
        
    }
    
    
    
    
    
}

extension ProfileEditViewController: UIImagePickerControllerDelegate{
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker .dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func wrapperDidPress(images: [UIImage]){
        
    }
    func doneButtonDidPress(images: [UIImage]){
        self.dismissViewControllerAnimated(false, completion: nil)
        
        
        let uploadLiamge:UIImage = images[0].fixOrientation()
        
        changeProfilePic(uploadLiamge)
        
        
        
        
        
    }
    func cancelButtonDidPress(){
        
    }
    
    
}

extension ProfileEditViewController : funcDelegate {
    func chooseSex(sex:String) {
        
        let btnTitle = sex ?? ""
        btnGender.setTitle(btnTitle, forState: .Normal)
        btnGender.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        
    }
}

extension ProfileEditViewController : UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        func checkLength(length: Int)->Bool {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            //            if newLength == length {
            //                appDelegate.ShowAlertView("Sorry", message: "Maximum 15 characters allowed.")
            //            }
            if newLength > length {
                let text = textField.text! + string
                textField.text = text.stringByReplacingCharactersInRange(text.startIndex.advancedBy(length)...text.endIndex.advancedBy(-1), withString: "")
                return true
            }
            return newLength == length
        }
        if textField == userNameTextField {
            //            let currentCharacterCount = textField.text?.characters.count ?? 0
            //            if (range.length + range.location > currentCharacterCount){
            //                return false
            //            }
            //            let newLength = currentCharacterCount + string.characters.count - range.length
            
            if checkLength(16) {
                appDelegate.ShowAlertView("Error", message: "Maximum 15 characters allowed.")
                return false
            }
        } else if textField == phoneTextField {
            if nil == Int(string) && string != ""{
                return false
            }
            if checkLength(14) {
                appDelegate.ShowAlertView("Error", message: "Maximum 13 digits allowed.")
                return false
            }
        }
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == phoneTextField {
            if (textField.text?.length < 11 || textField.text?.length > 13) && textField.text?.length > 0 {
                appDelegate.ShowAlertView("Error", message: "Minimum 11 digits allowed.")
                textField.text = ""
            }
        } else if textField == userNameTextField {
            if textField.text!.characters.count > 15 {
                let text = textField.text!
                textField.text = text.stringByReplacingCharactersInRange(text.startIndex.advancedBy(15)...text.endIndex.advancedBy(-1), withString: "")
            } else if textField.text! == "" {
                PixaPalsErrorType.EmptyUsernameFieldError.show(self)
            }
        }
    }
    
}
