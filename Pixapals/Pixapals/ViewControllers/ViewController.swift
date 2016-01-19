//
//  ViewController.swift
//  Pixapals
//
//  Created by ak2g on 1/7/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
//        let userInfo = UserDataStruct()
//        
//        if !userInfo.username.isEmpty {
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyBoard.instantiateViewControllerWithIdentifier("tabView")
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        //self.navigationController?.navigationBar.tintColor = UIColor(red:1.000, green:1.000, blue:1.000, alpha:1.00)
       // x.layer.borderColor
        //x.layer.borderWidth
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
}

