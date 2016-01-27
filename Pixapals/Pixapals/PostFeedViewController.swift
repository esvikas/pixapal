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

enum imageMode: String {
    
    case singleImage
    case doubleImage
}

class PostFeedViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var singleModeImageView: UIImageView!
    @IBOutlet weak var doubleModeImageView1: UIImageView!
    @IBOutlet weak var doubleModeImageView2: UIImageView!
    @IBOutlet var commentViewHeightConstrant: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!


    @IBOutlet weak var doubleModeStackView: UIStackView!
    @IBOutlet weak var doubleModeSwipeImageInstructionLabel: UILabel!
    @IBOutlet var commentTextField: UITextView!
    
    
    var image1: UIImage!
    var image2: UIImage!
    var image3: UIImage!
    
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))




    
    var DynamicView:UIImageView!

    
    let imageModes = imageMode.singleImage
    
    
    
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
        
        
        let fieldNameArray = "photo"


        
        let parameters = [
            "user_id" : "1",
            "comment" : commentTextField.text!
            
        ]
        let headers = [
            "X-Auth-Token" : "c353c462bb19d45f5d60d14ddf7ec3664c0eeaaaede6309c03dd8129df745b91",
        ]
        
        // example image data
        
        print(parameters)
        print(headers)
        
        // CREATE AND SEND REQUEST ----------
        doubleModeStackView.layoutIfNeeded()
        doubleModeImageView1.layoutIfNeeded()
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.doubleModeStackView.frame.width-40,self.doubleModeStackView.layer.frame.height/2), false, 0);
        self.view.drawViewHierarchyInRect(CGRectMake(self.doubleModeStackView.layer.frame.origin.x-20,self.doubleModeStackView.layer.frame.origin.y-44,self.doubleModeStackView.bounds.size.width,self.doubleModeStackView.layer.frame.height), afterScreenUpdates: true)
        let imagex:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        image1=imagex
        
        
//        UIGraphicsBeginImageContext(CGSizeMake(self.doubleModeStackView.frame.width-40, self.doubleModeStackView.layer.frame.height))
//
//        imagex.drawInRect(CGRectMake(0, 0, self.doubleModeStackView.frame.width-40, self.doubleModeStackView.layer.frame.height))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        print(doubleModeStackView.frame.height)
//        print(doubleModeStackView.frame.width)

        
        let imageData=((data:(UIImageJPEGRepresentation(imagex , 1))!))


        
        SRWebClient.POST("\(apiUrl)api/v1/feeds")
            
            .data(imageData, fieldName:fieldNameArray, data:parameters)
            .headers(headers)
            .send({(response:AnyObject!, status:Int) -> Void in
                
                //                    _ = JSON(response)
                print(response)
                
                print("Sucess")
                self.image1=nil
                self.image2=nil

                let alertController = UIAlertController(title: "Sucess", message: "Your post sucessfuly posted", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    print(action)
                    
                    
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    self.navigationController!.popToViewController(viewControllers[2], animated: true);
                    self.tabBarController?.selectedIndex = 0
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.blurEffectView.removeFromSuperview()


                }
                alertController.addAction(cancelAction)
                

                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
                
                
                
                },failure:{(response:AnyObject!, error:NSError!) -> Void in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

                    
                    print("Failure")
                    print(response)
                    print(error)
            })
//        doubleModeStackView.hidden=true
//        singleModeImageView.hidden=false
//        singleModeImageView.image=imagex
        
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        
scrollView.contentOffset = CGPoint(x: 0, y: 0)

        self.scrollView.layoutIfNeeded()
    

    }
}



