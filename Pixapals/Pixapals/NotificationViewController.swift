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
    var pullToRefresh = UIRefreshControl()
    var refreshingStatus = false
    var hasMoreDataInServer = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.blurEffectView.alpha = 0.4
        blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        self.pullToRefresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.pullToRefresh.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(pullToRefresh)
        self.tableView.alwaysBounceVertical = true
        
        loadDataFromAPI()

        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //self.removeBadge()
    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.tabBarController?.navigationItem.title = "Notifications"
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    private func removeBadge(){
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.reduceBadge(notificationLimit)
        }
    }
    func refresh(sender:AnyObject) {
        pullToRefresh.endRefreshing()
        self.pageNumber = 1
        self.refreshingStatus = true
        self.loadDataFromAPI()
    }
    
    func loadMore() {
        self.pageNumber++
        self.loadDataFromAPI()
    }
    
    private func loadDataFromAPI() {
        let user = UserDataStruct()
        
        let urlString = (URLs().makeNotification(userId: user.id, pageNumber: self.pageNumber, notificationLimit: self.notificationLimit))(self.title == "YOU")
        //let urlString  = (URLs().makeURLByAddingTrailling(userId: user.id, pageNumber: self.pageNumber, limit: self.notificationLimit))(URLs.URLType.)
       // let urlString = (self.title == "YOU") ? url(true) : url(false)
        
        
//        if self.title == "YOU" {
//            urlString += "my"
//        }else {
//            urlString += "fed"
//        }
//        urlString += "-notifications/\(user.id)/\(pageNumber)/\(notificationLimit)"
        // {user_id}/{page}/{limit}
        
        
//        let headers = [
//            "X-Auth-Token" : user.api_token!,
//        ]
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, method: .GET).handleResponse(
            { (notificationResponseJSON: NotificationResponseJSON) -> Void in
                if let error = notificationResponseJSON.error where error == true {
                    PixaPalsErrorType.NoDataFoundError.show(self)
                    //showAlertView("Error", message: "Server Not Found. Try again.", controller: self)
                } else {
                    appDelegate.getNotificationCount()
                    if let _ = self.notifications {
                        if self.refreshingStatus == true {
                            self.refreshingStatus = false
                            self.notifications = notificationResponseJSON
                        } else {
                            if notificationResponseJSON.notifications?.count < self.notificationLimit && notificationResponseJSON.notifications?.count > 0{
                                self.notifications?.notifications?.appendContentsOf(notificationResponseJSON.notifications!)
                                self.hasMoreDataInServer = false
                            } else if notificationResponseJSON.notifications?.count > 0 {
                                self.notifications?.notifications?.appendContentsOf(notificationResponseJSON.notifications!)
                            }
                            else {
                                self.hasMoreDataInServer = false
                            }
                        }
                    }
                    else {
                        self.notifications = notificationResponseJSON
                    }
                    self.tableView.reloadData()
                }
            }, errorBlock: {self}, onResponse: {
                self.blurEffectView.removeFromSuperview()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.pullToRefresh.endRefreshing()
                self.tableView.emptyDataSetDelegate=self
                self.tableView.emptyDataSetSource=self
            }
        )
//        
//        requestWithHeaderXAuthToken(.GET, urlString)
//            //                        .responseJSON { response -> Void in
//            //                            //print(response.request)
//            //                            switch response.result {
//            //                            case .Success(let value):
//            //                                let json = (JSON(value))
//            //                                //print(json)
//            //                            case .Failure(let error):
//            //                                //print(error)
//            //                            }
//            //                        }
//            .responseObject { (response: Response<NotificationResponseJSON, NSError>) -> Void in
//                switch response.result {
//                    
//                case .Success(let notificationResponseJSON):
//                    
//                    if let error = notificationResponseJSON.error where error == true {
//                        PixaPalsErrorType.NoDataFoundError.show(self)
//                        //showAlertView("Error", message: "Server Not Found. Try again.", controller: self)
//                        self.pullToRefresh.endRefreshing()
//                    } else {
//                        if let _ = self.notifications {
//                            if self.refreshingStatus == true {
//                                self.refreshingStatus = false
//                                self.notifications = notificationResponseJSON
//                            } else {
//                                if notificationResponseJSON.notifications?.count < self.notificationLimit && notificationResponseJSON.notifications?.count > 0{
//                                    self.notifications?.notifications?.appendContentsOf(notificationResponseJSON.notifications!)
//                                    self.hasMoreDataInServer = false
//                                } else if notificationResponseJSON.notifications?.count > 0 {
//                                    self.notifications?.notifications?.appendContentsOf(notificationResponseJSON.notifications!)
//                                }
//                                else {
//                                    self.hasMoreDataInServer = false
//                                }
//                            }
//                        }
//                        else {
//                            self.notifications = notificationResponseJSON
//                        }
//                        self.tableView.reloadData()
//                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                        self.blurEffectView.removeFromSuperview()
//                        self.pullToRefresh.endRefreshing()
//                        
//                        self.tableView.emptyDataSetDelegate=self
//                        self.tableView.emptyDataSetSource=self
//                        
//                        //self.loadMoreActivityIndicator.stopAnimating()
//                    }
//                    
//                case .Failure(let error):
//                    //                appDelegate.ShowAlertView("Connection Error", message: "Try Again", handlerForOk: { (action) -> Void in
//                    //                    self.loadDataFromAPI()
//                    //                    }, handlerForCancel: nil)
//                    //self.loadMoreActivityIndicator.stopAnimating()
//                    //self.tryAgainButton.hidden = false
//                    ////print("ERROR: \(error)")
//                    //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
//                    PixaPalsErrorType.ConnectionError.show(self)
//                    self.pullToRefresh.endRefreshing()
//                }
//        }
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        ////print( hasMoreDataInServer)
        ////print(indexPath.section)
        ////print(indexPath.section == self.feedsFromResponseAsObject.feeds!.count)
        let sections = self.numberOfRowsInSections()
        
        if indexPath.section == (sections.count - 1) && indexPath.row == (sections[indexPath.section].numberOfRows - 1) && self.hasMoreDataInServer {
            self.loadMore()
        }
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
            cell.userButton.kf_setBackgroundImageWithURL(NSURL(string: cellData.user?.photo_thumb ?? "")!, forState: UIControlState.Normal, placeholderImage: UIImage(named: "view_lover_list_user"))
            if let isUser = cellData.item2?.isUser  where self.title == "YOU" && isUser == true {
                cell.item2Button.hidden = true
            } else {
                cell.item2Button.kf_setBackgroundImageWithURL(NSURL(string: cellData.item2?.photo_thumb ?? "")!, forState: UIControlState.Normal, placeholderImage: UIImage(named: "view_lover_list_user"))
                if let isUser = cellData.item2?.isUser where isUser == true {
                    cell.item2Button.layer.cornerRadius = cell.item2Button.frame.height / 2
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
        let str = "no notifications to show."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "logo")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = "try again"
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
                self.goToDetailFeedView(idOfItem2)
            }
        }
    }
    
    func goToDetailFeedView(feedId: Int) {
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let vc: DetailVIewViewController = storyboard.instantiateViewControllerWithIdentifier("DetailVIewViewController") as! DetailVIewViewController
        if let feed = UserFeedDistinction.sharedInstance.getFeedWithId(feedId) {
            vc.feed = feed
        } else {
            vc.feedId = feedId
        }
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

