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



class ProfileEditViewController: UIViewController, UINavigationControllerDelegate, ImagePickerDelegate {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var webSiteTextField: UITextField!
    @IBOutlet var bioTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var btnChangePic: UIButton!
    @IBOutlet var userProfilePic: UIImageView!

    
    @IBOutlet var conformPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
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
        
        userNameTextField.text=userDataAsObject.username
        emailTextField.text=userDataAsObject.email
        bioTextField.text = userDataAsObject.bio
        phoneTextField.text = userDataAsObject.phone
        webSiteTextField.text = userDataAsObject.website
        genderTextField.text = userDataAsObject.gender
        
        print(userDataAsObject.photo_thumb)
        userProfilePic.kf_setImageWithURL(NSURL(string: userDataAsObject.photo_thumb ?? "")!, placeholderImage: UIImage(named: "global_feed_user"))
        
        print(userDataAsObject.photo_thumb)
        
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
            print("Unable to create Reachability")
            return
        }
        
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
        
        print(parameters)
        print(headers)
        
        // CREATE AND SEND REQUEST ----------
        
          var  imageData=((data:(UIImageJPEGRepresentation(image , 1))!))
            
    
        self.blurEffectView.alpha = 0.4
        self.blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Uploading"
        self.navigationItem.hidesBackButton = true
        
        
        
        SRWebClient.POST("\(apiUrl)api/v1/profile/photo")
            
            .data(imageData, fieldName:fieldNameArray, data:parameters)
            .headers(headers)
            
            .send({(response:AnyObject!, status:Int) -> Void in
                
                //                    _ = JSON(response)
                print(response)

                
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
            })
        
    }
    
    func done(sender: UIBarButtonItem) {
        
        self.navigationItem.hidesBackButton = true
                newDoneButton.enabled=false
        newBackButton.enabled=false


        
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
 
        self.blurEffectView.alpha = 0.4
        self.blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Posting"

        
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
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.blurEffectView.removeFromSuperview()
                        self.navigationController!.popViewControllerAnimated(true)
                    }else  {
                        
                    
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.blurEffectView.removeFromSuperview()
                    
                        self.navigationItem.hidesBackButton = false
                        self.newBackButton.enabled=false
                        self.newDoneButton.enabled=true

                        


                        
                    }
                }
        }
        
        
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
