//
//  AppDelegate.swift
//  Pixapals
//
//  Created by ak2g on 1/7/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var deviceTokenString: String!
    var numberOfNotificationBadge: Int?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "report_form_left_arrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "report_form_left_arrow")
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        // Override point for customization after application launch.
        
        let types: UIUserNotificationType = [UIUserNotificationType.Badge,
            UIUserNotificationType.Alert,
            UIUserNotificationType.Sound]
        
        
        

        
        let settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        
        Fabric.with([Crashlytics.self])
        
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        deviceTokenString = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        let nsUserDefault = NSUserDefaults.standardUserDefaults()
        nsUserDefault.setObject(deviceTokenString, forKey: "deviceTokenString")
        print(deviceTokenString)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if application.applicationState == UIApplicationState.Inactive || application.applicationState == UIApplicationState.Background {
            
            
            
        }
        
        if let numberOfNotificationBadge = self.numberOfNotificationBadge {
            self.numberOfNotificationBadge = numberOfNotificationBadge + 1
        } else {
            self.numberOfNotificationBadge = 1
        }
        
        
//        let alertController = UIAlertController(title: userInfo["aps"]?["alert"]?!["title"] as? String, message: userInfo["aps"]?["alert"]?!["body"] as? String, preferredStyle: .Alert)
//        
//        
//        
//        let OKAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
//        
//        }
//        alertController.addAction(OKAction)
//        let currentController = self.getCurrentViewController()
//        
//        currentController?.presentViewController(alertController, animated: true, completion: nil)
        
        
        
    }
    
    func ShowAlertView(title:String, message:String, handlerForOk: ((UIAlertAction) -> Void)? = nil, handlerForCancel: ((UIAlertAction) -> Void)? = nil){
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        func okAction() {
            let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: handlerForOk)
            alertController.addAction(okAction)
        }
        
        if let _ = handlerForOk {
            okAction()
        }
        
        if let _ = handlerForCancel {
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: handlerForCancel)
            alertController.addAction(cancelAction)
        }
        
        if handlerForCancel == nil && handlerForOk == nil {
            okAction()
        }
        
        let currentController = self.getCurrentViewController()
        
        if (currentController?.isKindOfClass(UIAlertController) != true){
            currentController?.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            while( currentController.presentedViewController != nil ) {
                
                currentController = currentController.presentedViewController
            }
            return currentController
            
        }
        return nil
        
    }
    
    func internetConnected() -> Bool{
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            if reachability.isReachable()  {
                
                return true

            } else {
                
                ShowAlertView("Sorry ", message: "you are not conected with internet")
            }
            
        } catch {
            print("Unable to create Reachability")
            return false
        }
        return false
    }
    
    
}

