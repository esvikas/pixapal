//
//  ForgotPasswordViewController.swift
//  Pixapals
//
//  Created by DARI on 3/11/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmail(sender: AnyObject) {
        let button = sender as! UIButton
        button.setTitle("Sending an email", forState: UIControlState.Disabled)
        
        button.enabled = false
        
        let validator = Validator()
        if validator.isValidEmail(emailTextField.text!) {
            
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
            blurEffectView.alpha = 0.4
            blurEffectView.frame = view.bounds
            self.view.addSubview(blurEffectView)
            
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Sending an Email"
            
            let parameters: [String: AnyObject] = ["email": emailTextField.text!]
            APIManager(requestType: RequestType.WithDeviceTokenInParam, urlString: URLType.ForgotPassword.make(), parameters: parameters).handleResponse(
                { (response: SuccessFailJSON) -> Void in
                    if response.error! {
                        PixaPalsErrorType.InvalidEmailError.show(self, message: response.message, afterCompletion: {self.emailTextField.text = ""})
                        button.enabled = true
                    }else {
                        PixaPalsErrorType.InvalidEmailError.show(self, message: "\(response.message!) Check your email.", title: "Email Sent", afterCompletion: {self.navigationController?.popViewControllerAnimated(true)})
                    }
                }, errorBlock: {
                    button.enabled = true
                    return self
                }) {
                    blurEffectView.removeFromSuperview()
                    loadingNotification.removeFromSuperview()
            }
        }else {
            button.enabled = true
            PixaPalsErrorType.InvalidEmailError.show(self)
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
