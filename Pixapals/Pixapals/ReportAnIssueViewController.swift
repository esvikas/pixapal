//
//  ReportAnIssueViewController.swift
//  Pixapals
//
//  Created by DARI on 3/2/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Spring
import SevenSwitch
import MBProgressHUD

class ReportAnIssueViewController: UIViewController {
    
    enum ReportType {
        case User(Int), Feed(Int), App
    }
    
    @IBOutlet weak var btnSelectRelatedTo: DesignableButton!
    @IBOutlet weak var iEnsureSwitch: SevenSwitch!
    @IBOutlet weak var lblLetterCount: UILabel!
    @IBOutlet weak var txtComment: DesignableTextView!
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var dropDownView: UIView!
    
    var type: ReportType = .App
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkShouldHideOrUnhideDropDown()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func relatedToButton(sender: AnyObject) {
        let alertViewController = UIAlertController(title: "Related to?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let actionSpam = UIAlertAction(title: "Spam or abuse", style: .Default) { action -> Void in
            self.btnSelectRelatedTo.setTitle(action.title, forState: .Normal)
        }
        let actionSthNotWorking = UIAlertAction(title: "Something isn't working", style: .Default) { action -> Void in
            self.btnSelectRelatedTo.setTitle(action.title, forState: .Normal)
        }
        
        let actionFeedback = UIAlertAction(title: "General feedback", style: .Default) { action -> Void in
            self.btnSelectRelatedTo.setTitle(action.title, forState: .Normal)
        }
        
        alertViewController.addAction(actionSpam)
        alertViewController.addAction(actionSthNotWorking)
        alertViewController.addAction(actionFeedback)
        
        self.presentViewController(alertViewController, animated: true, completion: nil)
        
        
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
//        vc.preferredContentSize = CGSizeMake(self.view.layer.frame.width, 44.0 * CGFloat(vc.options.count) + 8)
//        popover.delegate = self
//        popover.sourceView = self.btnSelectRelatedTo
//        popover.sourceRect = CGRect(x: self.btnSelectRelatedTo.frame.width/2 - 30, y: 0, width: self.btnSelectRelatedTo.frame.width, height: self.btnSelectRelatedTo.frame.height)
//        //self.presentViewController(nav, animated: false, completion: nil)
//        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func reportThisButton(sender: AnyObject) {
        let comment = txtComment.text!
        let issue_type = btnSelectRelatedTo.titleLabel?.text
        
        if case ReportType.App = self.type {
            if !["Spam or Abuse","Something Isn't Working","General Feedback"].contains(issue_type!) {
                PixaPalsErrorType.RelatedToNotSelectedError.show(self)
                return
            }
        }
        if comment.isEmpty || comment == "Comments .." {
            PixaPalsErrorType.CommentBoxIsEmptyError.show(self)
            return
        }
        
        if !iEnsureSwitch.on {
            PixaPalsErrorType.ReportNotEnsuredError.show(self)
            return
        }
        
        var urlString = URLType.AppIssue.make()
        var parameters: [String: AnyObject] =
        [
            "issue_type": issue_type!,
            "comment": comment,
        ]
        
        
        switch self.type {
        case .App: break
        case .Feed(let id):
            urlString = URLType.BlockUserFeed.make()
            parameters =
                [
                    "type" : "post",
                    "blocked_id" : id,
                    "comments" : comment
            ]
        case .User(let id):
            parameters["commented_user_id"] = id
        }
        
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        blurEffectView.alpha = 0.4
        blurEffectView.frame = view.bounds
        self.view.addSubview(blurEffectView)
        
        self.navigationItem.hidesBackButton = true
        self.view.userInteractionEnabled=false
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Reporting"
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters: parameters).handleResponse(
            { (getFeed: SuccessFailJSON) -> Void in
                
                self.navigationItem.hidesBackButton = false
                self.view.userInteractionEnabled=true
                if !getFeed.error! {
                    PixaPalsErrorType.ReportIssueSuccessful.show(self, afterCompletion: {
//                        switch self.type{
//                        case .User(let id):
//                            UserFeedDistinction.sharedInstance.removeUserWithId(id)
//                        case .Feed(let id):
//                            UserFeedDistinction.sharedInstance.removeFeedWithId(id)
//                        case .App: break
//                        }
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    ////print("Reporting issue")
                } else {
                    ////print("Error: reporting error")
                    PixaPalsErrorType.CantReportIssueError.show(self)
                }
            }, errorBlock: {self}, onResponse: {
                loadingNotification.removeFromSuperview()
                blurEffectView.removeFromSuperview()
                self.navigationItem.hidesBackButton = false
                self.view.userInteractionEnabled=true
            }
        )
        
        //        requestWithHeaderXAuthToken(.POST, urlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
        //            loadingNotification.removeFromSuperview()
        //            blurEffectView.removeFromSuperview()
        //            switch response.result {
        //            case .Success(let getFeed):
        //                if !getFeed.error! {
        //                    PixaPalsErrorType.ReportIssueSuccessful.show(self)
        //                    ////print("Reporting issue")
        //                } else {
        //                    //print("Error: reporting error")
        //                    PixaPalsErrorType.CantReportIssueError.show(self)
        //                }
        //            case .Failure(let error):
        //                PixaPalsErrorType.ConnectionError.show(self)
        //            }
        //        }
    }
    
    func checkShouldHideOrUnhideDropDown(){
        
        self.hideUnhideDropDown()(true)
        
        switch type {
        case .App:
            self.hideUnhideDropDown()(false)
        case .User:
            self.lblComment.text = "Why are you reporting this user?"
            
        case .Feed:
            self.lblComment.text = "Why are you reporting this feed?"
        }
    }
    
    func hideUnhideDropDown() -> Bool -> Void {
        return {
            hide in
            self.dropDownView.hidden = hide
        }
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
//MARK:- selectionview delegate
extension ReportAnIssueViewController: SelectionViewControllerDelegate {
    func selectedOptionText(text: String) {
        self.btnSelectRelatedTo.setTitle(text, forState: .Normal)
    }
}

//MARK:- Popover presentationcontroller delegate
extension ReportAnIssueViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
}

extension ReportAnIssueViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let currentCharacterCount = textView.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + text.characters.count - range.length
        return newLength <= 240
        
    }
    
    
    func textViewDidChange(textView: UITextView) {
        
        
        ////print(commentTextField.text.characters.count)
        
        lblLetterCount.text="\(240 - txtComment.text.characters.count) Characters Left"
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if txtComment.text == "Comments .." {
            txtComment.text=""
        }
    }
    
}
