//
//  ForgotPasswordViewController.swift
//  Pixapals
//
//  Created by DARI on 3/11/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

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
            })
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
