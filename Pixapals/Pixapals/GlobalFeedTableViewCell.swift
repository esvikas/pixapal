//
//  GlobalFeedTableViewCell.swift
//  Pixapals
//
//  Created by DARI on 1/18/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
protocol CellImageSwippedDelegate {
    func imageSwipedLeft(id: Int, loved: Bool, left: Bool)
    func imageSwipedRight(id: Int, loved: Bool, left: Bool)
}

class GlobalFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var loveIcon: UIImageView!
    @IBOutlet weak var leftCount: UILabel!
    @IBOutlet weak var loveCount: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var feedImage2: UIImageView!
    
    @IBOutlet weak var timeElapsed: UILabel!

    var id: Int!
    var loved : Bool!
    var left : Bool!

    
    var delegate: CellImageSwippedDelegate!
    
//    var imageViewObject :UIImageView!

    
    var DynamicView=UIView()


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        

        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipeLeft)
        
        
//        imageViewObject = UIImageView(frame:CGRectMake(0, 0, self.DynamicView.frame.width, self.DynamicView.frame.height))

//        imageViewObject.image = UIImage(named:"afternoon")
        
//        self.DynamicView.addSubview(imageViewObject)
        
         CreateScreen()

    }

    
    func CreateScreen(){
        self.layoutIfNeeded()
        
        DynamicView.frame=(frame: CGRectMake(self.feedImage.layer.frame.origin.x, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
        //        DynamicView.layer.cornerRadius=25
        //        DynamicView.layer.borderWidth=2
        
        self.addSubview(DynamicView)
        
    }
    

    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                
                print(id)
                print(loved)
                print(left)
                
                if loved != true {
                
                DynamicView.backgroundColor=UIColor.blackColor()
                
                DynamicView.frame=(frame: CGRectMake(self.feedImage.layer.frame.origin.x, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                self.DynamicView.hidden=false
                
                UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseIn, animations: { () -> Void in
                    
                    self.DynamicView.frame=(frame: CGRectMake( self.frame.width, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                    
                    }, completion: { (Bool) -> Void in
                        self.DynamicView.hidden=true
                        
                })
                
                
 
                
                print("Swiped right")
                delegate.imageSwipedRight(self.id,loved: self.loved,left: self.left)
                }
                
            case UISwipeGestureRecognizerDirection.Left:
                if left != true {

                DynamicView.backgroundColor=UIColor.redColor()
                
                DynamicView.frame=(frame: CGRectMake(self.feedImage.layer.frame.origin.x, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                self.DynamicView.hidden=false
                
                UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseIn, animations: { () -> Void in
                    self.DynamicView.frame=(frame: CGRectMake( -self.frame.width, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                    
                    }, completion: { (Bool) -> Void in
                        self.DynamicView.hidden=true
                })
                print("swipe left")
                delegate.imageSwipedLeft(self.id,loved: self.loved,left: self.left)
                }
                
            default:
                break
            }
        }
    }
}