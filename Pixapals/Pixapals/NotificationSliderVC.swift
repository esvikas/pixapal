//
//  ViewController.swift
//  PageMenuDemoStoryboard
//
//  Created by Niklas Fahl on 12/19/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

import UIKit

class NotificationSliderVC: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: - UI Setup
        
//        self.title = "Lovers"
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 153/255, green: 200/255, blue: 71/255, alpha: 1)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
////        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItemStyle.Done, target: self, action: "didTapGoToLeft")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItemStyle.Done, target: self, action: "didTapGoToRight")
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewControllerWithIdentifier("NotificationViewController")
        let controller2 = storyBoard.instantiateViewControllerWithIdentifier("NotificationViewController")

        
        
        controller.title = "FEEDERS"
        controllerArray.append(controller)
//        let controller4 : TestViewController = noti(nibName: "TestViewController", bundle: nil)
        controller2.title = "YOU"
        controllerArray.append(controller2)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor(red: 153/255, green: 200/255, blue: 71/255, alpha: 1)),
//            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 15.0)!),
            .MenuHeight(40.0),
            .SelectedMenuItemLabelColor(UIColor(red: 153/255, green: 200/255, blue: 71/255, alpha: 1)),
            .UnselectedMenuItemLabelColor(UIColor.blackColor()),

            .MenuItemWidth(self.view.frame.width/2),
            .CenterMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)

		self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
		
		pageMenu!.didMoveToParentViewController(self)
    }
    
    
    
    
    func didTapGoToLeft() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
	
	// MARK: - Container View Controller
	override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
		return true
	}
	
	override func shouldAutomaticallyForwardRotationMethods() -> Bool {
		return true
	}
}


