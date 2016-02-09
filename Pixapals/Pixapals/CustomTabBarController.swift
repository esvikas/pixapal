//
//  CustomTabBarController.swift
//  Pixapals
//
//  Created by DARI on 1/12/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    var counter: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        
        //self.selectedViewController?.tabBarItem
        // Do any additional setup after loading the view.
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if !counter {
            counter = !counter
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewControllerWithIdentifier("globalFeedVC")
            
            controller.title = "Personalized Feeds" //view = self.viewControllers?[0].view
            
            let icon1 = UITabBarItem(title: "", image: UIImage(named: "profile_menu"), selectedImage: nil)
            icon1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            controller.tabBarItem = icon1
            var controllers = self.viewControllers  //array of the root view controllers displayed by the tab bar interface
            controllers?.insert(controller, atIndex: 1)
            self.viewControllers = controllers
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
