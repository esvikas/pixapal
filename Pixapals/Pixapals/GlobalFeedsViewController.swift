//
//  GlobalFeedsViewController.swift
//  Pixapals
//
//  Created by DARI on 1/12/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import MBProgressHUD
import AlamofireObjectMapper
import DZNEmptyDataSet

class GlobalFeedsViewController: UIViewController {
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tryAgainButton: UIButton!
    
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    
    var tableViewRefreshControl = UIRefreshControl()
    var collectionViewRefreshControl = UIRefreshControl()
    
    var refreshingStatus = false
    var hasMoreDataInServer = true
    var collectionViewHidden = false
    
    var pageNumber = 1
    let postLimit = 15
    
    var feedsFromResponseAsObject: FeedsResponseJSON!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manageNavBar()
        
        self.footerView.hidden = true
        
        self.loadMoreActivityIndicator.hidesWhenStopped = true
        self.loadDataFromAPI()
        self.changeViewMode(self)
        //        tableView.emptyDataSetDelegate=self
        //        tableView.emptyDataSetSource=self
        //        collectionView.emptyDataSetSource=self
        //        collectionView.emptyDataSetDelegate=self
        
        
        self.blurEffectView.alpha = 0.4
        blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        
        self.tableViewRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.tableViewRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(tableViewRefreshControl)
        self.tableView.alwaysBounceVertical = true
        
        
        self.collectionViewRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.collectionViewRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.addSubview(collectionViewRefreshControl)
        self.collectionView.alwaysBounceVertical = true
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        self.manageNavBar()
    }
    
    func manageNavBar() {
        var nameOfNavbarButtonImage = ""
        if self.tableView.hidden == true {
            nameOfNavbarButtonImage = "global_feed_grid_menu"
            
        } else {
            nameOfNavbarButtonImage = "square"
        }
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: nameOfNavbarButtonImage), style: .Plain, target: self, action: "changeViewMode:")
        self.tabBarController?.navigationItem.title = self.title ?? "Global Feed"
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func swipedLeft(sender: AnyObject) {
        print("Swiped left")
    }
    
    @IBAction func swipedRight(sender: AnyObject) {
        print("Swiped right")
    }
    
    @IBAction func tryAgainPressed(sender: AnyObject) {
        if let btn = sender as? UIButton {
            btn.hidden = true
        }
        self.loadMoreActivityIndicator.startAnimating()
        self.loadDataFromAPI()
    }
    
    private func loadDataFromAPI(){
        guard let id = UserDataStruct().id else {
            print("no user id")
            return
        }
        
        var apiURLString = ""
        if let _ = self.title {
            //api/v1/feeds/all/
            apiURLString = "\(apiUrl)api/v1/feeds/all/\(id)/\(self.pageNumber)/\(self.postLimit)"
        }
            
        else {
            apiURLString = "\(apiUrl)api/v1/feeds/global/\(id)/\(self.pageNumber)/\(self.postLimit)"
        }
        //print(apiURLString)
        guard let api_token = UserDataStruct().api_token else{
            print("no api token")
            return
        }
        
        let headers = [
            "X-Auth-Token" : String(api_token),
        ]
        
        Alamofire.request(.GET, apiURLString, parameters: nil, headers: headers)
            //requestWithHeaderXAuthToken(.GET, apiURLString)
            .responseJSON { response -> Void in
                print(response.request)
                switch response.result {
                case .Success(let value):
                    print(JSON(value))
                case .Failure(let error):
                    print(error)
                }
        }
        
        //Alamofire.request(.GET, apiURLString, parameters: nil, headers: headers).responseArray { (response: Response<[FeedJSON], NSError>) -> Void in
        requestWithHeaderXAuthToken(.GET, apiURLString).responseObject { (response: Response<FeedsResponseJSON, NSError>) -> Void in
            
            switch response.result {
                
            case .Success(let feedsResponseJSON):
                
                if let error = feedsResponseJSON.error where error == true {
                    self.loadMoreActivityIndicator.stopAnimating()
                    self.tryAgainButton.hidden = false
                    
                    print("Error: \(feedsResponseJSON.message)")
                } else {
                    if let _ = self.feedsFromResponseAsObject {
                        if self.refreshingStatus == true {
                            self.refreshingStatus = false
                            self.feedsFromResponseAsObject = feedsResponseJSON
                        } else {
                            if feedsResponseJSON.feeds?.count < self.postLimit && feedsResponseJSON.feeds?.count > 0{
                                self.feedsFromResponseAsObject.feeds?.appendContentsOf(feedsResponseJSON.feeds!)
                                self.hasMoreDataInServer = false
                            } else if feedsResponseJSON.feeds?.count > 0 {
                                self.feedsFromResponseAsObject.feeds?.appendContentsOf(feedsResponseJSON.feeds!)
                            }
                            else {
                                self.hasMoreDataInServer = false
                            }
                        }
                    }
                    else {
                        self.feedsFromResponseAsObject = feedsResponseJSON
                    }
                    print(feedsResponseJSON.feeds?.count)
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.blurEffectView.removeFromSuperview()
                    self.tableViewRefreshControl.endRefreshing()
                    self.collectionViewRefreshControl.endRefreshing()
                    self.loadMoreActivityIndicator.stopAnimating()
                    self.footerView.hidden = true
                }
                
                // self.feedsFromResponseAsObject = feedsResponseJSON
                //print(json)
                //                if !json["error"].boolValue {
                //                    if let _ = self.feedsToShow {
                //                        if self.refreshingStatus == true {
                //                            self.refreshingStatus = false
                //                            self.feedsToShow = json
                //                        } else {
                //                            self.feedsToShow = JSON(self.feedsToShow.arrayObject! + json.arrayObject!)
                //                            if json.count == 0 {
                //                                self.hasMoreDataInServer = false
                //                            }
                //                        }
                //                    } else {
                //                        self.feedsToShow = json
                //                    }
                //
                //                    self.tableView.reloadData()
                //                    self.collectionView.reloadData()
                //                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                //                    self.blurEffectView.removeFromSuperview()
                //                    self.refreshControl.endRefreshing()
                //                    self.loadMoreActivityIndicator.stopAnimating()
                //                    self.footerView.hidden = true
                //                } else {
                //                    self.loadMoreActivityIndicator.stopAnimating()
                //                    self.tryAgainButton.hidden = false
                //                    //                    appDelegate.ShowAlertView("Connection Error", message: "Try Again", handlerForOk: { (action) -> Void in
                //                    //                        self.loadDataFromAPI()
                //                    //                        }, handlerForCancel: nil)
                //
                //                    print("Error: \(json["message"])")
                //                }
            case .Failure(let error):
                //                appDelegate.ShowAlertView("Connection Error", message: "Try Again", handlerForOk: { (action) -> Void in
                //                    self.loadDataFromAPI()
                //                    }, handlerForCancel: nil)
                self.loadMoreActivityIndicator.stopAnimating()
                self.tryAgainButton.hidden = false
                print("ERROR: \(error)")
                self.tableViewRefreshControl.endRefreshing()
                self.collectionViewRefreshControl.endRefreshing()
            }
            
            }.progress { (a, b, c) -> Void in
                // print("\(a) -- \(b) -- \(c)")
        }
        //        Alamofire.request(.GET, apiURLString, parameters: nil, headers: headers).responseJSON { response -> Void in
        //
        //            switch response.result {
        //            case .Success(let value):
        //                let json = JSON(value)
        //                print(json)
        //                if !json["error"].boolValue {
        //                    if let _ = self.feedsToShow {
        //                        if self.refreshingStatus == true {
        //                            self.refreshingStatus = false
        //                            self.feedsToShow = json
        //                        } else {
        //                            self.feedsToShow = JSON(self.feedsToShow.arrayObject! + json.arrayObject!)
        //                            if json.count == 0 {
        //                                self.hasMoreDataInServer = false
        //                            }
        //                        }
        //                    } else {
        //                        self.feedsToShow = json
        //                    }
        //
        //                    self.tableView.reloadData()
        //                    self.collectionView.reloadData()
        //                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        //                    self.blurEffectView.removeFromSuperview()
        //                    self.refreshControl.endRefreshing()
        //                    self.loadMoreActivityIndicator.stopAnimating()
        //                    self.footerView.hidden = true
        //                } else {
        //                    self.loadMoreActivityIndicator.stopAnimating()
        //                    self.tryAgainButton.hidden = false
        ////                    appDelegate.ShowAlertView("Connection Error", message: "Try Again", handlerForOk: { (action) -> Void in
        ////                        self.loadDataFromAPI()
        ////                        }, handlerForCancel: nil)
        //
        //                    print("Error: \(json["message"])")
        //                }
        //            case .Failure(let error):
        ////                appDelegate.ShowAlertView("Connection Error", message: "Try Again", handlerForOk: { (action) -> Void in
        ////                    self.loadDataFromAPI()
        ////                    }, handlerForCancel: nil)
        //                self.loadMoreActivityIndicator.stopAnimating()
        //                self.tryAgainButton.hidden = false
        //                print("ERROR: \(error)")
        //                self.refreshControl.endRefreshing()
        //            }
        //
        //            }.progress { (a, b, c) -> Void in
        //               // print("\(a) -- \(b) -- \(c)")
        //        }
    }
    
    func changeViewMode(sender: AnyObject) {
        if self.collectionViewHidden {
            self.collectionView.hidden = false
            self.tableView.hidden = true
            if let count = self.feedsFromResponseAsObject?.feeds?.count where count > 0 {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }
            self.tabBarController?.navigationItem.rightBarButtonItem?.image = UIImage(named: "global_feed_grid_menu")
        } else {
            self.collectionView.hidden = true
            self.tableView.hidden = false
            if let count = self.feedsFromResponseAsObject?.feeds?.count where count > 0 {
                self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
            }
            self.tabBarController?.navigationItem.rightBarButtonItem?.image = UIImage(named: "square")
            
        }
        self.collectionViewHidden = !self.collectionViewHidden
    }
    
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        
        tableViewRefreshControl.endRefreshing()

        self.pageNumber = 1
        self.refreshingStatus = true
        self.hasMoreDataInServer = true
        self.loadDataFromAPI()
    }
    
    func loadMore() {
        self.footerView.hidden = false
        self.pageNumber++
        self.loadMoreActivityIndicator.startAnimating()
        self.loadDataFromAPI()
    }
    
    func goToDetailFeedView(feed: FeedJSON) {
        
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let vc: DetailVIewViewController = storyboard.instantiateViewControllerWithIdentifier("DetailVIewViewController") as! DetailVIewViewController
        vc.feed = feed
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GlobalFeedsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        print(self.feedsFromResponseAsObject?.feeds?.count)
        return self.feedsFromResponseAsObject?.feeds?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewCell", forIndexPath: indexPath) as! GlobalFeedTableViewCell
        
        let feed = (self.feedsFromResponseAsObject.feeds?[indexPath.section])!
        
        //cell.feedImage.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section, "photo"].string!)!, placeholderImage: UIImage(named: "loading.png"))
        cell.feedImage.kf_setImageWithURL(NSURL(string: feed.photo ?? "")!, placeholderImage: UIImage(named: "loading.png"))
        
        if let imagePresent = feed.photo_two?.isEmpty where imagePresent == false {
            cell.feedImage2.hidden = false
            cell.feedImage2.kf_setImageWithURL(NSURL(string: feed.photo_two ?? "")! , placeholderImage: UIImage(named: "loading.png"))
        } else {
            cell.feedImage2.hidden = true
        }
        //        if let imagePresent = feedsToShow[indexPath.section,"photo_two"].string?.isEmpty where imagePresent == false {
        //            cell.feedImage2.hidden = false
        //            cell.feedImage2.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section,"photo_two"].string!)! , placeholderImage: UIImage(named: "loading.png"))
        //        } else {
        //            cell.feedImage2.hidden = true
        //        }
        
        cell.delegate = self
        
        cell.id = indexPath.section
        cell.left = feed.is_my_left
        cell.loved = feed.is_my_love
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        
        cell.loveCount.text = "\(feed.loveit ?? 0) loved it"
        cell.loveIcon.image = UIImage(named: self.getIconName(feed.loveit ?? 0))
        cell.leftCount.text = "\(feed.leaveit ?? 0) left it"
        cell.leftIcon.image = UIImage(named: self.getIconName(feed.leaveit ?? 0, love: false))
        cell.comment.text = "\(feed.comment ?? "")"
        //print(feedsToShow)
        return cell
    }
    
    
    func getIconName(count: Int, love: Bool = true) -> String {
        var iconName = ""
        if love {
            iconName = "love"
        } else {
            iconName = "left"
        }
        if count <= 10 {
            iconName += "1"
        } else if count <= 50 {
            iconName += "2"
        } else if count <= 100 {
            iconName += "3"
        } else if count <= 200 {
            iconName += "4"
        } else {
            iconName += "5"
        }
        return iconName
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //print( hasMoreDataInServer)
        //print(indexPath.section)
        //print(indexPath.section == self.feedsFromResponseAsObject.feeds!.count)
        if indexPath.section == self.feedsFromResponseAsObject.feeds!.count - 1 && self.hasMoreDataInServer {
            self.loadMore()
        }
    }
    
}

extension GlobalFeedsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let feed = (self.feedsFromResponseAsObject.feeds?[indexPath.section])!
        
        
        self.goToDetailFeedView(feed)
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        //return self.view.frame.height - (20 + 44 + 49)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let feed = self.feedsFromResponseAsObject.feeds![section]
        let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewHeaderCell") as! GlobalFeedTableViewHeaderCell
        cell.userProfilePic.kf_setImageWithURL(NSURL(string: feed.user!.photo_thumb!)!, placeholderImage: cell.userProfilePic.image)
        cell.username.text = feed.user?.username
        if let createdAt = feed.created_at {
            //let dateFormatter = NSDateFormatter()
            //dateFormatter.dateFormat = "y-MM-dd HH:mm:ss"
            // if let date = dateFormatter.dateFromString(createdAt) {
            var textTimeElapsed = ""
            let timeInSecond = Int(NSDate().timeIntervalSinceDate(createdAt))
            if timeInSecond/60 < 0 {
                textTimeElapsed = "\(timeInSecond) sec ago"
            } else if timeInSecond/(60*60) < 1 {
                textTimeElapsed = "\(timeInSecond/60) mins ago"
            }else if timeInSecond/(60*60*24) < 1 {
                textTimeElapsed = "\(timeInSecond/(60*60)) hrs ago"
            }else if timeInSecond/(60*60*24*7) < 1 {
                textTimeElapsed = "\(timeInSecond/(60*60*24)) days ago"
            }else if timeInSecond/(60*60*24*7) >= 1 {
                textTimeElapsed = "\(timeInSecond/(60*60*24*7)) weeks ago"
            }
            cell.timeElapsed.text = textTimeElapsed
            //}
        }
        
        return cell
    }
    
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //        if let tblView = scrollView as? UITableView where tblView == self.tableView {
    //            if (scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height && hasMoreDataInServer)
    //            {
    //                self.loadMore()
    //                print("here")
    //            }
    //        }
    //    }
    
    
    
}

extension GlobalFeedsViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(feedsToShow?.count)
        return self.feedsFromResponseAsObject?.feeds?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("globalFeedCollectionViewCell", forIndexPath: indexPath) as! GlobalFeedCollectionViewCell
        if let image_url = self.feedsFromResponseAsObject.feeds?[indexPath.row].photo_thumb {
            cell.feedImage.kf_setImageWithURL(NSURL(string: image_url)!)
        } else {
            cell.feedImage.image = UIImage(named: "post-feed-img")
        }
        return cell
    }
    //    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    //        if kind == UICollectionElementKindSectionFooter {
    //            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "loadMoreCollectionReusableView", forIndexPath: indexPath)
    //            footer.addSubview(footerView)
    //            return footer
    //        }
    //        return UICollectionReusableView()
    //    }
}
extension GlobalFeedsViewController: UICollectionViewDelegate{
    //    func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
    //        if elementKind == UICollectionElementKindSectionFooter {
    //            if hasMoreDataInServer {
    //                self.loadMore()
    //            }
    //        }
    //    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.feedsFromResponseAsObject.feeds!.count - 1 && self.hasMoreDataInServer {
            self.loadMore()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let feed = self.feedsFromResponseAsObject.feeds?[indexPath.row]
        self.goToDetailFeedView(feed!)
    }
}

extension GlobalFeedsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((self.view.frame.width - 8)/3, (self.view.frame.width - 8)/3)
    }
    
}

extension GlobalFeedsViewController: CellImageSwippedDelegate {
    func imageSwipedLeft(id: Int, loved: Bool, left:Bool) {
        print("swipped leave (left)")
        //        print(id)
        //        print(loved)
        //        print(left)
        //left=true
        self.loveFeed(id)
        
        
    }
    func imageSwipedRight(id: Int, loved: Bool, left: Bool) {
        print("swipped love (right)")
        //        print(loved)
        //        print(left)
        //        loved = true
        //        left = false
        self.leaveit(id)
        
    }
    
    func SegueToLoverList(id: Int?) {
        let feed = self.feedsFromResponseAsObject.feeds![id!]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("LoverListViewController") as! LoverListViewController
        vc.users = feed.lovers
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func SegueToProfile(id: Int?) {
        let feed = self.feedsFromResponseAsObject.feeds![id!]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ProfileViewController = storyBoard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        vc.userId = feed.user?.id
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func loveFeed(id:Int){
        let feed = self.feedsFromResponseAsObject.feeds![id]
        let user = UserDataStruct()
        
        let registerUrlString = "\(apiUrl)api/v1/feeds/loveit"
        
        let parameters: [String: AnyObject] =
        [
            "user_id": String(user.id!),
            "post_id": String(feed.id!)
        ]
        let headers = [
            "X-Auth-Token" : user.api_token!,
        ]
        
        self.loveCountIncrease(feed)
        
        requestWithHeaderXAuthToken(.POST, registerUrlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
            switch response.result {
            case .Success(let loveItObject):
                if !loveItObject.error! {
                    
                } else {
                    self.leaveCountIncrease(feed)
                    print("Error: Love it error")
                }
            case .Failure(let error):
                self.leaveCountIncrease(feed)
                print("Error in connection \(error)")
            }
        }
    }
    
    
    func leaveit(id: Int){
        let feed = self.feedsFromResponseAsObject.feeds![id]
        let user = UserDataStruct()
        let registerUrlString = "\(apiUrl)api/v1/feeds/leaveit"
        
        let parameters: [String: AnyObject] =
        [
            "user_id": String(user.id!),
            "post_id": String(feed.id!)
        ]
        let headers = [
            "X-Auth-Token" : user.api_token!,
        ]
        
        self.leaveCountIncrease(feed)
        
        //                Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers).responseJSON { response in
        //                    print(response.request)
        //                    switch response.result {
        //                    case .Failure(let error):
        //                        print(error)
        //                    case .Success(let value):
        //                        print(value)
        //                    }
        //                }
        
        requestWithHeaderXAuthToken(.POST, registerUrlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
            switch response.result {
            case .Success(let loveItObject):
                if !loveItObject.error! {
                    
                } else {
                    print("Error: Love it error")
                    self.loveCountIncrease(feed)
                }
                
            case .Failure(let error):
                print("Error in connection \(error)")
                self.loveCountIncrease(feed)
                
            }
        }
    }
    
    func loveCountIncrease(feed: FeedJSON){
        feed.is_my_love = true
        feed.loveit = feed.loveit! + 1
        if feed.is_my_left! {
            feed.is_my_left = false
            feed.leaveit = feed.leaveit! - 1
        }
        self.tableView.reloadData()
        
    }
    
    func leaveCountIncrease(feed: FeedJSON){
        feed.is_my_left = true
        feed.leaveit = feed.leaveit! + 1
        if feed.is_my_love! {
            feed.is_my_love = false
            feed.loveit = feed.loveit! - 1
        }
        self.tableView.reloadData()
    }
}

extension GlobalFeedsViewController: DetailViewViewControllerProtocol {
    func needReloadData() {
        self.tableView.reloadData()
    }
}

//extension GlobalFeedsViewController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
//
//
//    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//        let str = "Sorrry"
//        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
//
//    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//        let str = "There are no posts to show"
//        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
//
//    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "logo")
//    }
//
////    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
////        let str = "More info"
////        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
////        return NSAttributedString(string: str, attributes: attrs)
////    }
//
//    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
//        let ac = UIAlertController(title: "Info will be listed here", message: nil, preferredStyle: .Alert)
//        ac.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
//        presentViewController(ac, animated: true, completion: nil)
//    }
//}


extension GlobalFeedsViewController : UIScrollViewDelegate {
    
    
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        


        if(velocity.y>0){
            
            self.tableViewRefreshControl.endRefreshing()

            NSLog("dragging Up");
        }else{
            NSLog("dragging Down");
        }
        
    }
    

    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
    }
    

    
   
}

