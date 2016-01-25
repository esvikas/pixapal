//
//  GlobalFeedTableViewCell.swift
//  Pixapals
//
//  Created by DARI on 1/18/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class GlobalFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var loveIcon: UIImageView!
    @IBOutlet weak var leftCount: UILabel!
    @IBOutlet weak var loveCount: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var feedImage2: UIImageView!
//    var imageViewObject :UIImageView!

    
    var DynamicView=WobbleView()


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
        DynamicView.frame=(frame: CGRectMake(self.feedImage.layer.frame.origin.x, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
        //        DynamicView.layer.cornerRadius=25
        //        DynamicView.layer.borderWidth=2
        
        DynamicView.edges=ViewEdge.None
        self.addSubview(DynamicView)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipeLeft)
        
        
//        imageViewObject = UIImageView(frame:CGRectMake(0, 0, self.DynamicView.frame.width, self.DynamicView.frame.height))

//        imageViewObject.image = UIImage(named:"afternoon")
        
//        self.DynamicView.addSubview(imageViewObject)

    }
    

    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                DynamicView.backgroundColor=UIColor.blackColor()
                
                DynamicView.frame=(frame: CGRectMake(self.feedImage.layer.frame.origin.x, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                self.DynamicView.hidden=false
                
                UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseIn, animations: { () -> Void in
                    
                    self.DynamicView.frame=(frame: CGRectMake( self.frame.width, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                    
                    }, completion: { (Bool) -> Void in
                        self.DynamicView.hidden=true
                        
                })
                
                
                
                
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Left:
                DynamicView.backgroundColor=UIColor.redColor()
                
                DynamicView.frame=(frame: CGRectMake(self.feedImage.layer.frame.origin.x, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                self.DynamicView.hidden=false
                
                UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseIn, animations: { () -> Void in
                    self.DynamicView.frame=(frame: CGRectMake( -self.frame.width, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                    
                    }, completion: { (Bool) -> Void in
                        self.DynamicView.hidden=true
                })
                
                print("Swiped left")
                
            default:
                break
            }
        }
    }
}