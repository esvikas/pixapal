//
//  CustomTabBarController.swift
//  Pixapals
//
//  Created by DARI on 1/12/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

protocol CustomTabBarControllerDelegate {
    func fromNotificationClick()
    func changeBadge()
}

class CustomTabBarController: UITabBarController {
    var counter: Bool = false
    
    var initalTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.tabBarDelegate = self
        //self.navigationItem.hidesBackButton = true
        
        //self.selectedViewController?.tabBarItem
        // Do any additional setup after loading the view.
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)

        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(UIColor.lightGrayColor(), size: tabBarItemSize).resizableImageWithCapInsets(UIEdgeInsetsZero)
        
        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
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
        changeBadge()
        if appDelegate.fromNotification {
            appDelegate.fromNotification = false
            self.selectedIndex = 3
        }
    }
    
    
    func changeBadge() {
        if let numberOfNotificationBadge = appDelegate.numberOfNotificationBadge {
            let tabArray = self.tabBar.items as NSArray!
            let tabItem = tabArray.objectAtIndex(3) as! UITabBarItem
            tabItem.badgeValue = String(numberOfNotificationBadge)
            if numberOfNotificationBadge <= 0 {
                self.removeBadge()
            }
        }
    }
    
    func removeBadge(){
        let tabArray = self.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(3) as! UITabBarItem
        tabItem.badgeValue = nil
        appDelegate.numberOfNotificationBadge = nil
    }
    func reduceBadge(by: Int) {
        if let numberOfNotificationBadge = appDelegate.numberOfNotificationBadge {
            let tabArray = self.tabBar.items as NSArray!
            let tabItem = tabArray.objectAtIndex(3) as! UITabBarItem
            appDelegate.numberOfNotificationBadge = appDelegate.numberOfNotificationBadge! - by
            if appDelegate.numberOfNotificationBadge! <= 0 {
                self.removeBadge()
            }
            tabItem.badgeValue = String(numberOfNotificationBadge - by)
        }
    }
}

extension CustomTabBarController: CustomTabBarControllerDelegate {
    func fromNotificationClick() {
        appDelegate.fromNotification = false
        self.selectedIndex = 3
    }
}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}