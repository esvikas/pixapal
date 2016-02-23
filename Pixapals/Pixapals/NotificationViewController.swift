//
//  NotificationViewController.swift
//  Pixapals
//
//  Created by DARI on 2/15/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Alamofire
import SwiftyJSON
import Kingfisher
import MBProgressHUD


class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notifications: NotificationResponseJSON?
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    
    
    var pageNumber = 1
    let notificationLimit = 15
    var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.blurEffectView.alpha = 0.4
        blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        loadDataFromAPI()
        tableView.emptyDataSetDelegate=self
        tableView.emptyDataSetSource=self
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    private func loadDataFromAPI() {
        let user = UserDataStruct()
        
        var urlString = "\(apiUrl)api/v1/"
        
        if self.title == "YOU" {
            urlString += "my"
        }else {
            urlString += "fed"
        }
        urlString += "-notifications/\(user.id)/\(pageNumber)/\(notificationLimit)"
        // {user_id}/{page}/{limit}
        
        
        let headers = [
            "X-Auth-Token" : user.api_token!,
        ]
        
        requestWithHeaderXAuthToken(.GET, urlString)
            //                        .responseJSON { response -> Void in
            //                            print(response.request)
            //                            switch response.result {
            //                            case .Success(let value):
            //                                let json = (JSON(value))
            //                                print(json)
            //                            case .Failure(let error):
            //                                print(error)
            //                            }
            //                        }
            .responseObject { (response: Response<NotificationResponseJSON, NSError>) -> Void in
                switch response.result {
                case .Failure(let error):
                    print(error)
                case .Success(let notificationResponseJSON):
                    if !notificationResponseJSON.error! {
                        self.notifications = notificationResponseJSON
                        self.tableView.reloadData()
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.blurEffectView.removeFromSuperview()
                    }
                }
        }
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfRowsInSections().count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSections()[section].numberOfRows
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationTableViewHeaderCell") as! NotificationTableViewHeaderCell
        cell.timeElapsedLbl.text = self.numberOfRowsInSections()[section].sectionTitle
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 21
    }
    private func numberOfRowsInSections() -> [(sectionTitle: String, numberOfRows: Int)]{
        
        var numberOfRowsInSection = [(sectionTitle: String, numberOfRows: Int)]()
        let today = self.getRowsCount(lowerLimitInDaysFromToday: 0, upperLimitInDaysFromToday: -1)
        if today > 0 {
            numberOfRowsInSection.append(("TODAY", today))
        }
        let yesterday =  self.getRowsCount(lowerLimitInDaysFromToday: 1, upperLimitInDaysFromToday: 0)
        if yesterday > 0 {
            numberOfRowsInSection.append(("YESTERDAY", yesterday))
        }
        let aweekago = self.getRowsCount(lowerLimitInDaysFromToday: 7, upperLimitInDaysFromToday: 1)
        if aweekago > 0 {
            numberOfRowsInSection.append(("A WEEK AGO", aweekago ))
        }
        return numberOfRowsInSection
    }
    
    private func getRowsCount(lowerLimitInDaysFromToday lowerLimitInDaysFromToday: Int = 0 , upperLimitInDaysFromToday: Int = 0) -> Int {
        return self.getFilteredNotificationBetweenDates(lowerLimitInDaysFromToday: lowerLimitInDaysFromToday, upperLimitInDaysFromToday: upperLimitInDaysFromToday).count
    }
    
    private func getFilteredNotificationBetweenDates(lowerLimitInDaysFromToday lowerLimitInDaysFromToday: Int = 0 , upperLimitInDaysFromToday: Int = 0) -> [NotificationJSON] {
        if let notifications = self.notifications?.notifications {
            let notif =  notifications.filter
                {
                    let calender = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                    let startDate = calender.startOfDayForDate(NSDate())
                    if let created_at = $0.created_at?.created_at {
                        if NSComparisonResult.OrderedAscending == created_at.compare(startDate.dateByAddingTimeInterval(Double(-upperLimitInDaysFromToday) * 24 * 60 * 60)) && (NSComparisonResult.OrderedDescending == created_at.compare(startDate.dateByAddingTimeInterval(Double(-lowerLimitInDaysFromToday) * 24 * 60 * 60)) || NSComparisonResult.OrderedSame == created_at.compare(startDate.dateByAddingTimeInterval(Double(-lowerLimitInDaysFromToday) * 24 * 60 * 60))) {
                            return true
                        }
                    }
                    return false
            }
            return notif
        }
        return [NotificationJSON]()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationTableViewCell", forIndexPath: indexPath) as! NotificationTableViewCell
        
        self.configureCell(cell, cellData: self.getDataForCellAtIndexPath(indexPath))
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    private func configureCell(cell: NotificationTableViewCell, cellData: NotificationJSON?) {
        if let cellData = cellData {
            cell.messageLbl.text = cellData.message
            cell.usernameButton.setTitle(cellData.user?.username, forState: UIControlState.Normal)
            if cellData.user?.photo_thumb == "" {
                cell.userButton.setBackgroundImage(UIImage(named: "global_feed_user"), forState: UIControlState.Normal)
                
            } else {
                cell.userButton.kf_setBackgroundImageWithURL(NSURL(string: cellData.user?.photo_thumb ?? "")!, forState: UIControlState.Normal)
            }
            
            if self.title != "YOU" {
                cell.item2Button.kf_setBackgroundImageWithURL(NSURL(string: cellData.item2?.photo_thumb ?? "")!, forState: UIControlState.Normal)
            } else {
                if let action = cellData.action where action != "follows" {
                    cell.item2Button.hidden = true
                }
            }
        }
    }
    
    private func getDataForCellAtIndexPath(indexPath: NSIndexPath) -> NotificationJSON? {
        
        var filteredNotifications: [NotificationJSON]?
        
        let sectionTitle = self.numberOfRowsInSections()[indexPath.section].sectionTitle
        
        if sectionTitle == "TODAY" {
            filteredNotifications = self.getFilteredNotificationBetweenDates(lowerLimitInDaysFromToday: 0, upperLimitInDaysFromToday: -1)
        } else if sectionTitle == "YESTERDAY" {
            filteredNotifications = self.getFilteredNotificationBetweenDates(lowerLimitInDaysFromToday: 1, upperLimitInDaysFromToday: 0)
        } else if sectionTitle == "A WEEK AGO" {
            filteredNotifications = self.getFilteredNotificationBetweenDates(lowerLimitInDaysFromToday: 7, upperLimitInDaysFromToday: 1)
        }
        
        if let filteredNotifications = filteredNotifications where filteredNotifications.count > indexPath.row {
            return filteredNotifications[indexPath.row]
        }
        return nil
    }
}

extension NotificationViewController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Sorry"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "There are no posts to show."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "logo")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = "Try Again"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        //        let ac = UIAlertController(title: "Info will be listed here", message: nil, preferredStyle: .Alert)
        //        ac.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
        //        presentViewController(ac, animated: true, completion: nil)
        tableView.reloadData()
    }
}

extension NotificationViewController: NotificationTableViewCellDelegate {
    
    func item2ImageTapped(indexPath: NSIndexPath) {
        let cellData = self.getDataForCellAtIndexPath(indexPath)
        let idOfItem2 = cellData?.item2?.id
        if let isUser = cellData?.item2?.isUser, let idOfItem2 = idOfItem2 where isUser == true{
            self.showUserProfile(idOfItem2)
        }else {
            if let idOfItem2 = idOfItem2 {
                print("Janxa")
                //self.goToDetailFeedView(<#T##feed: FeedJSON##FeedJSON#>)
            }
        }
    }
    
    func goToDetailFeedView(feed: FeedJSON) {
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let vc: DetailVIewViewController = storyboard.instantiateViewControllerWithIdentifier("DetailVIewViewController") as! DetailVIewViewController
        vc.feed = feed
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userInfoTapped(indexPath: NSIndexPath) {
        let cellData = self.getDataForCellAtIndexPath(indexPath)
        let userId = cellData?.user?.id
        if let userId = userId {
            self.showUserProfile(userId)
        }
    }
    
    func showUserProfile(id: Int?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        vc.userId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

