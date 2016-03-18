//
//  GlobalFeedTableViewCell.swift
//  Pixapals
//
//  Created by DARI on 1/18/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Spring

protocol CellImageSwippedDelegate {
    func imageSwipedLeft(id: Int, loved: Bool, left: Bool)
    func imageSwipedRight(id: Int, loved: Bool, left: Bool, mode : Int)
    
    func SegueToProfile(id: Int?)
    func SegueToLoverList(id: Int?)
    func SegueToLeaverList(id: Int?)
    
}

class GlobalFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var loveIcon: UIImageView!
    @IBOutlet weak var leftCount: UILabel!
    @IBOutlet weak var loveCount: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var feedImage2: UIImageView!
    @IBOutlet weak var timeElapsed: UILabel!
    @IBOutlet weak var leftIcon: UIImageView!
    
    @IBOutlet var loadingView: SpringView!
    @IBOutlet weak var moreButton: UIButton!
    
    var feedId: Int!
    var id: Int!
    var loved : Bool!
    var left : Bool!
    var mode : Int!
    
    var delegate: CellImageSwippedDelegate!
    var DynamicView=UIImageView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        loadingView.showLoading()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipeLeft)
        CreateScreen()
        
        loveCount.userInteractionEnabled = true
        loveIcon.userInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("labelPressed"))
        loveCount.addGestureRecognizer(gestureRecognizer)
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: Selector("labelPressed"))
        loveIcon.addGestureRecognizer(gestureRecognizer2)
        
        leftCount.userInteractionEnabled = true
        leftIcon.userInteractionEnabled = true
        let gestureRecognizerLeft1 = UITapGestureRecognizer(target: self, action: Selector("leftLabelPressed"))
        leftCount.addGestureRecognizer(gestureRecognizerLeft1)
        let gestureRecognizerLeft2 = UITapGestureRecognizer(target: self, action: Selector("leftLabelPressed"))
        loveIcon.addGestureRecognizer(gestureRecognizerLeft2)
        
    }
    
    func labelPressed(){
        
        delegate.SegueToLoverList(id)
    }
    
    func leftLabelPressed(){
        if mode == 2 {
            delegate.SegueToLeaverList(id)
        }
    }
    
    func   UserIconAndLabelPressed(){
        
        delegate.SegueToProfile(id)
        
    }
    
    func CreateScreen(){
        self.layoutIfNeeded()
        
        DynamicView.frame=(frame: CGRectMake(self.feedImage.layer.frame.origin.x, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
        DynamicView.contentMode = .ScaleAspectFit
        self.addSubview(DynamicView)
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                
                //                print(id)
                //                print(loved)
                //                print(left)
                
                print(mode)
                if left != true {
                    
                    print(mode)
                    if mode == 1 {
                        DynamicView.image=UIImage(named: "leaveit")
                        
                    } else {
                        
                        DynamicView.image=UIImage(named: "loveit2")
                        
                        
                    }
                    
                    DynamicView.frame=(frame: CGRectMake(self.feedImage.layer.frame.origin.x, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                    
                    self.DynamicView.hidden=false
                    
                    UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseIn, animations: { () -> Void in
                        
                        self.DynamicView.frame=(frame: CGRectMake( self.frame.width, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                        
                        }, completion: { (Bool) -> Void in
                            self.DynamicView.hidden=true
                            self.delegate.imageSwipedRight(self.id,loved: self.loved,left: self.left, mode: self.mode)
                    })
                    self.left = true
                    
                    
                }
                
            case UISwipeGestureRecognizerDirection.Left:
                if loved != true {
                    DynamicView.image=UIImage(named: "loveit")
                    DynamicView.frame=(frame: CGRectMake(self.feedImage.layer.frame.origin.x, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                    self.DynamicView.hidden=false
                    
                    UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseIn, animations: { () -> Void in
                        self.DynamicView.frame=(frame: CGRectMake( -self.frame.width, self.feedImage.layer.frame.origin.y, self.feedImage.frame.width, self.feedImage.frame.height))
                        }, completion: { (Bool) -> Void in
                            self.DynamicView.hidden=true
                            
                            self.delegate.imageSwipedLeft(self.id,loved: self.loved,left: self.left)
                    })
                    self.loved = true
                    
                }
            default:
                break
            }
        }
    }
    
    @IBAction func moreButton(sender: AnyObject) {
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewControllerWithIdentifier("SelectionViewController") as! SelectionViewController
        //        vc.delegate = self
        //        vc.options = ["Spam or Abuse","Something Isn't Working","General Feedback"]
        //
        //        //let nav = UINavigationController(rootViewController: vc)
        //        //nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        //        //let popover = nav.popoverPresentationController!
        //        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        //        let popover = vc.popoverPresentationController!
        //
        //        //let popover = UIPopoverPresentationController(presentedViewController: vc, presentingViewController: self)
        let viewControllerInWhichToDisplay = appDelegate.getCurrentViewController() as! UINavigationController
        //        vc.preferredContentSize = CGSizeMake(viewControllerInWhichToDisplay!.view.layer.frame.width, 44.0 * CGFloat(vc.options.count) + 8)
        //        popover.delegate = self
        //        popover.sourceView = self.loveIcon
        //        popover.sourceRect = self.loveIcon.frame
        //                popover.sourceRect = CGRect(x: self.moreButton.frame.origin.x, y: 0, width: viewControllerInWhichToDisplay!.view.frame.width, height: viewControllerInWhichToDisplay!.view.frame.height)
        //viewControllerInWhichToDisplay!.presentViewController(vc, animated: true, completion: nil)
        
        
        let popoverContent = (viewControllerInWhichToDisplay.storyboard?.instantiateViewControllerWithIdentifier("SelectionViewController"))! as! SelectionViewController
        popoverContent.delegate = self
        popoverContent.options = ["Spam or Abuse","Something Isn't Working","General Feedback"]
        
        //let nav = UINavigationController(rootViewController: popoverContent)
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = popoverContent.popoverPresentationController
        
        popoverContent.preferredContentSize = CGSizeMake(viewControllerInWhichToDisplay.view.layer.frame.width,170)
        popover!.delegate = self
        popover!.sourceView = viewControllerInWhichToDisplay.view
        popover!.sourceRect = self.moreButton.frame
        //viewControllerInWhichToDisplay!.presentViewController(popoverContent, animated: false, completion: nil)
        
        let actionsheet = UIAlertController(title: "Choose Action", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let report = UIAlertAction(title: "Report Feed", style: .Default, handler: { (_) -> Void in
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("ReportAnIssueViewController") as! ReportAnIssueViewController
            vc.type = ReportAnIssueViewController.ReportType.Feed(self.feedId)
            viewControllerInWhichToDisplay.pushViewController(vc, animated: true)
        })
        actionsheet.addAction(cancel)
        actionsheet.addAction(report)
        viewControllerInWhichToDisplay.presentViewController(actionsheet, animated: true, completion: nil)
    }
}
extension GlobalFeedTableViewCell: SelectionViewControllerDelegate {
    func selectedOptionText(text: String) {
        
    }
}

extension GlobalFeedTableViewCell: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
}