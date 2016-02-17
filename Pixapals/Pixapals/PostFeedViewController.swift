//
//  PostFeedViewController.swift
//  Pixapals
//
//  Created by DARI on 1/13/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD



class PostFeedViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var btnPostFeed: UIButton!
    @IBOutlet weak var singleModeImageView: UIImageView!
    @IBOutlet weak var doubleModeImageView1: UIImageView!
    @IBOutlet weak var doubleModeImageView2: UIImageView!
    @IBOutlet var commentViewHeightConstrant: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var characterCountLabel: UILabel!


    @IBOutlet weak var doubleModeStackView: UIStackView!
    @IBOutlet weak var doubleModeSwipeImageInstructionLabel: UILabel!
    @IBOutlet var commentTextField: UITextView!
    
    
    var image1: UIImage!
    var image2: UIImage!
    var image3: UIImage!
    var imageData : NSData!
    
    var comment:String!
    
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))

    var imageMode: Int! // 1 single mode  2 double mode


    
    var DynamicView:UIImageView!

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.delegate=self

        if self.image2 == nil {
            doubleModeStackView.hidden = true
            doubleModeSwipeImageInstructionLabel.hidden = true
            singleModeImageView.hidden = false
            singleModeImageView.image=image1
            
        } else  {
            singleModeImageView.hidden = true
            doubleModeStackView.hidden = false
            doubleModeImageView1.image=image1
            doubleModeImageView2.image=image2



            doubleModeSwipeImageInstructionLabel.hidden = false

            self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)


        }

    
    
        DynamicView=UIImageView(frame: CGRectMake(self.doubleModeImageView1.layer.frame.origin.x, self.doubleModeImageView1.layer.frame.origin.y, self.doubleModeImageView1.frame.width, self.doubleModeImageView1.frame.height))
        //        DynamicView.layer.cornerRadius=25
        //        DynamicView.layer.borderWidth=2
        
        self.doubleModeStackView.addSubview(DynamicView)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        


    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnPostFeed(sender: AnyObject) {
        PostFeed()
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                //    DynamicView.backgroundColor=UIColor.blackColor()
                DynamicView.image=doubleModeImageView1.image
                
                DynamicView.frame=(frame: CGRectMake(self.doubleModeImageView1.layer.frame.origin.x, self.doubleModeImageView1.layer.frame.origin.y, self.doubleModeImageView1.frame.width, self.doubleModeImageView1.frame.height))
                self.DynamicView.hidden=false
                
                UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                    
                    self.DynamicView.frame=(frame: CGRectMake( self.doubleModeImageView1.frame.width, self.doubleModeImageView1.layer.frame.origin.y, self.doubleModeImageView1.frame.width, self.doubleModeImageView1.frame.height))
                    
                    }, completion: { (Bool) -> Void in
                        self.DynamicView.hidden=true
                        self.doubleModeImageView1.image=self.image2
                        self.doubleModeImageView2.image=self.image1
                        
                        self.swapImage()

                        
                })
                
                print("Swiped right")

            case UISwipeGestureRecognizerDirection.Left:
                DynamicView.image=image2
                
                DynamicView.frame=(frame: CGRectMake(self.doubleModeImageView2.layer.frame.origin.x, self.doubleModeImageView2.layer.frame.origin.y, self.doubleModeImageView2.frame.width, self.doubleModeImageView1.frame.height))
                self.DynamicView.hidden=false
              
                
                UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                    self.DynamicView.frame=(frame: CGRectMake( 0, self.doubleModeImageView1.layer.frame.origin.y, self.doubleModeImageView1.frame.width, self.doubleModeImageView2.frame.height))
                    
                    }, completion: { (Bool) -> Void in
                        self.DynamicView.hidden=true
                        self.doubleModeImageView1.image=self.image2
                        self.doubleModeImageView2.image=self.image1
                        self.swapImage()


                        
                })
                
                print("Swiped left")

                
            default:
                break
            }
        }
    }
    
    func swapImage() {
        let intermediateImage = self.image1
        self.image1 = self.image2
        self.image2 = intermediateImage
    }
 
    
    func PostFeed(){
        
btnPostFeed.enabled=false

        
        
        let fieldNameArray = "photo"

        if commentTextField.text == "Comments" {
            
          comment =  ""
        } else {
            
            comment = commentTextField.text!
        }
        
        let parameters = [
            "user_id" : String(UserDataStruct().id!),
            "comment" : comment!
            
        ]
        let headers = [
            "X-Auth-Token" : UserDataStruct().api_token!,
        ]
        
        // example image data
        
        print(parameters)
        print(headers)
        
        // CREATE AND SEND REQUEST ----------
        doubleModeStackView.layoutIfNeeded()
        doubleModeImageView1.layoutIfNeeded()
        if imageMode==2{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.doubleModeStackView.frame.width-40,self.doubleModeStackView.layer.frame.height/2), false, 0);
        self.view.drawViewHierarchyInRect(CGRectMake(self.doubleModeStackView.layer.frame.origin.x-20,self.doubleModeStackView.layer.frame.origin.y-44,self.doubleModeStackView.bounds.size.width,self.doubleModeStackView.layer.frame.height), afterScreenUpdates: true)
        let imagex:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        image1=imagex


        
         imageData=((data:(UIImageJPEGRepresentation(imagex , 1))!))
        }else{
            
             imageData=((data:(UIImageJPEGRepresentation(image1 , 1))!))

        }
        
        self.blurEffectView.alpha = 0.4
        self.blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Posting"
        self.navigationItem.hidesBackButton = true
        self.view.userInteractionEnabled=false



        
        SRWebClient.POST("\(apiUrl)api/v1/feeds")
            
            .data(imageData, fieldName:fieldNameArray, data:parameters)
            .headers(headers)
            
            .send({(response:AnyObject!, status:Int) -> Void in
                
                //                    _ = JSON(response)
                print(response)
                print(self.imageData)

                print("success")
                self.image1=nil
                self.image2=nil

                let alertController = UIAlertController(title: "success", message: "Your post successfully posted", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    print(action)
                    
                    
//                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//                    self.navigationController!.popToViewController(viewControllers[2], animated: true);
//                    self.tabBarController?.selectedIndex = 0
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.blurEffectView.removeFromSuperview()
                    self.btnPostFeed.enabled=true
//                    self.navigationItem.hidesBackButton = false



                    self.view.userInteractionEnabled=true

                    let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
                    let vc: CustomTabBarController = storyboard.instantiateViewControllerWithIdentifier("tabView") as! CustomTabBarController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                alertController.addAction(cancelAction)
                

                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
                
                
                
                },failure:{(response:AnyObject!, error:NSError!) -> Void in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.blurEffectView.removeFromSuperview()
                    self.btnPostFeed.enabled=true
                    self.navigationItem.hidesBackButton = false
                    self.view.userInteractionEnabled=true


                    appDelegate.ShowAlertView("Sorry", message: "Something Went Wrong")
                    print("Failure")
                    print(response)
                    print(error)
            })
        
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        
scrollView.contentOffset = CGPoint(x: 0, y: 0)

        self.scrollView.layoutIfNeeded()
        scrollView.scrollEnabled=true

    

    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let currentCharacterCount = textView.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + text.characters.count - range.length
        return newLength <= 240
        
    }

    
    func textViewDidChange(textView: UITextView) {
        
      
        print(commentTextField.text.characters.count)
        
        characterCountLabel.text="\(240 - commentTextField.text.characters.count) Characters Left"
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
scrollView.scrollEnabled=false
        if commentTextField.text == "Comments" {
            commentTextField.text=""

        }
    }
}



