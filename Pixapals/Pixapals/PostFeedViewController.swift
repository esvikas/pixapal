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

enum imageMode: String {
    
    case singleImage
    case doubleImage
}

class PostFeedViewController: UIViewController {

    @IBOutlet weak var singleModeImageView: UIImageView!
    @IBOutlet weak var doubleModeStackView: UIStackView!
    @IBOutlet weak var doubleModeSwipeImageInstructionLabel: UILabel!
    @IBOutlet var commentTextField: UITextField!
    
    
    var image2: UIImage!
    var image1: UIImage!
    
    let imageModes = imageMode.singleImage
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.image2 == nil {
            doubleModeStackView.hidden = true
            doubleModeSwipeImageInstructionLabel.hidden = true
            singleModeImageView.hidden = false
            singleModeImageView.image=image1

        } else {
            singleModeImageView.hidden = true
            doubleModeStackView.hidden = false
            doubleModeSwipeImageInstructionLabel.hidden = false

        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnPostFeed(sender: AnyObject) {
        PostFeed()
    }


    
    func PostFeed(){
        
        let parameters = [
            "user_id" : "1",
            "comment" : "This is the body text."

        ]
        let headers = [
            "X-Auth-Token" : "c353c462bb19d45f5d60d14ddf7ec3664c0eeaaaede6309c03dd8129df745b91",

        ]

        // example image data
        let image = image1
        let imageData = NSData(data:(UIImageJPEGRepresentation(image, 1))!)
        
        print(parameters)
        print(headers)
        
        // CREATE AND SEND REQUEST ----------
        

            SRWebClient.POST("\(apiUrl)api/v1/feeds")
                
                .data(imageData, fieldName:"photo", data:parameters)
                .headers(headers)
                .send({(response:AnyObject!, status:Int) -> Void in
                    
//                    _ = JSON(response)
                     print(response)
                    
print("Sucess")
                    
                    
                    },failure:{(response:AnyObject!, error:NSError!) -> Void in
                        
                 print("Failure")
                        print(response)
                        print(error)
        })
            
        }
}


