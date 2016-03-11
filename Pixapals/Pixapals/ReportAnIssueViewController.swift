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
import Alamofire
import MBProgressHUD

class ReportAnIssueViewController: UIViewController {
    
    @IBOutlet weak var btnSelectRelatedTo: DesignableButton!
    @IBOutlet weak var iEnsureSwitch: SevenSwitch!
    @IBOutlet weak var txtComment: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func relatedToButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SelectionViewController") as! SelectionViewController
        vc.delegate = self
        vc.options = ["Spam or Abuse","Something Isn't Working","General Feedback"]
        
        //let nav = UINavigationController(rootViewController: vc)
        //nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        //let popover = nav.popoverPresentationController!
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = vc.popoverPresentationController!
        
        //let popover = UIPopoverPresentationController(presentedViewController: vc, presentingViewController: self)
        vc.preferredContentSize = CGSizeMake(self.view.layer.frame.width, 44.0 * CGFloat(vc.options.count) + 8)
        popover.delegate = self
        popover.sourceView = self.btnSelectRelatedTo
        popover.sourceRect = CGRect(x: self.btnSelectRelatedTo.frame.width/2 - 30, y: 0, width: self.btnSelectRelatedTo.frame.width, height: self.btnSelectRelatedTo.frame.height)
        //self.presentViewController(nav, animated: false, completion: nil)
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func reportThisButton(sender: AnyObject) {
        let comment = txtComment.text!
        let issue_type = btnSelectRelatedTo.titleLabel?.text
        
        if !["Spam or Abuse","Something Isn't Working","General Feedback"].contains(issue_type!) {
            PixaPalsErrorType.RelatedToNotSelectedError.show(self)
            return
        }
        
        if comment.isEmpty {
            PixaPalsErrorType.CommentBoxIsEmptyError.show(self)
            return
        }
        
        if !iEnsureSwitch.on {
            PixaPalsErrorType.ReportNotEnsuredError.show(self)
            return
        }
        
        let urlString = URLType.AppIssue.make()
        
        let parameters: [String: AnyObject] =
        [
            "issue_type": issue_type!,
            "comment": comment,
        ]
        
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        blurEffectView.alpha = 0.4
        blurEffectView.frame = view.bounds
        self.view.addSubview(blurEffectView)
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Reporting"
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters: parameters).handleResponse(
            { (getFeed: SuccessFailJSON) -> Void in
                if !getFeed.error! {
                    PixaPalsErrorType.ReportIssueSuccessful.show(self, afterCompletion: {
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    //print("Reporting issue")
                } else {
                    print("Error: reporting error")
                    PixaPalsErrorType.CantReportIssueError.show(self)
                }
            }, errorBlock: {self}, onResponse: {
                loadingNotification.removeFromSuperview()
                blurEffectView.removeFromSuperview()
            }
        )
        
//        requestWithHeaderXAuthToken(.POST, urlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
//            loadingNotification.removeFromSuperview()
//            blurEffectView.removeFromSuperview()
//            switch response.result {
//            case .Success(let getFeed):
//                if !getFeed.error! {
//                    PixaPalsErrorType.ReportIssueSuccessful.show(self)
//                    //print("Reporting issue")
//                } else {
//                    print("Error: reporting error")
//                    PixaPalsErrorType.CantReportIssueError.show(self)
//                }
//            case .Failure(let error):
//                PixaPalsErrorType.ConnectionError.show(self)
//            }
//        }
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
