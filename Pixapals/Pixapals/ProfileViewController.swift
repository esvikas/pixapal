//
//  ProfileViewController.swift
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
//import obje

class ProfileViewController: UIViewController {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var feeding: UILabel!
    @IBOutlet weak var feeders: UILabel!
    @IBOutlet weak var feeds: UILabel!
    
    @IBOutlet weak var tryAgainButton: UIButton!
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    
    let tableViewRefreshControl = UIRefreshControl()
    let collectionViewRefreshContol = UIRefreshControl()
    
    var collectionViewHidden = false
    
    
    
    var feedsToShow: JSON!
    var refreshingStatus = false
    var hasMoreDataInServer = true
    
    var userId: Int?
    
    var pageNumber = 1
    let postLimit = 15
    
    var navTitle: String? = nil {
        didSet {
            self.navigationItem.title = self.navTitle ?? "Profile"
            if let index = self.tabBarController?.selectedIndex  where index == self.tabBarController!.viewControllers!.indexOf(self) {
                self.changeNavTitle()
            }
        }
    }
    
    var feedsFromResponseAsObject: ProfileResponseJSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.cornerRadius=userImage.frame.height/2
        userImage.clipsToBounds=true
        
        self.footerView.hidden = true
        
        self.loadMoreActivityIndicator.hidesWhenStopped = true
        self.loadDataFromAPI()
        
        self.blurEffectView.alpha = 0.4
        self.blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        
        self.tableViewRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.tableViewRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(tableViewRefreshControl)
        self.tableView.alwaysBounceVertical = true
        
        self.collectionViewRefreshContol.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.collectionViewRefreshContol.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.addSubview(collectionViewRefreshContol)
        self.collectionView.alwaysBounceVertical = true
        
        //FOR WHAT??
        self.navigationItem.hidesBackButton = false
        
        
        self.headerView.frame.size.width = self.view.frame.width
        self.collectionView.hidden = true
        
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        self.btnEdit.setTitle("Processing", forState: UIControlState.Disabled)
        if let userId = userId  where userId != UserDataStruct().id{
            checkIfUserIsMyFed()
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        //self.tableView.reloadData()
        self.changeNavTitle()
        
        self.tableView.reloadData()
        self.collectionView.reloadData()
        if userId == nil {
            let btnName = UIButton()
            btnName.setImage(UIImage(named: "setting"), forState: .Normal)
            btnName.frame = CGRectMake(0, 0, 30, 30)
            btnName.addTarget(self, action: Selector("action"), forControlEvents: .TouchUpInside)
            
            //.... Set Right/Left Bar Button item
            let rightBarButton = UIBarButtonItem()
            rightBarButton.customView = btnName
            self.tabBarController?.navigationItem.rightBarButtonItem = rightBarButton
        } else {
            let btnName = UIButton()
            btnName.setImage(UIImage(named: "dotwhite"), forState: .Normal)
            btnName.frame = CGRectMake(0, 0, 30, 30)
            btnName.addTarget(self, action: Selector("more"), forControlEvents: .TouchUpInside)
            
            //.... Set Right/Left Bar Button item
            let rightBarButton = UIBarButtonItem()
            rightBarButton.customView = btnName
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        self.checkIfUserIsMyFed()
        //        let camera = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: Selector("btnOpenCamera"))
        //        self.navigationItem.rightBarButtonItem = camera
    }
    
    
    @IBAction func gridView(sender: AnyObject) {
        collectionView.hidden = false
        tableView.hidden = true
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    @IBAction func listView(sender: AnyObject) {
        collectionView.hidden = true
        tableView.hidden = false
        tableView.reloadData()
    }
    
    @IBAction func btnEditProgileSender(sender: AnyObject) {
        if let userId = userId  where userId != UserDataStruct().id{
            self.followUser(userId)
            return
        }
        
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let vc: ProfileEditViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileEditViewController") as! ProfileEditViewController
        vc.delegate = self
        vc.userDataAsObject=feedsFromResponseAsObject.user
        
        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func more(){
        let actionsheet = UIAlertController(title: "Choose Action", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let report = UIAlertAction(title: "Report User", style: .Default, handler: { (_) -> Void in
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("ReportAnIssueViewController") as! ReportAnIssueViewController
            vc.type = ReportAnIssueViewController.ReportType.User(self.userId!)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let block = UIAlertAction(title: "Block User", style: UIAlertActionStyle.Destructive) { (_) -> Void in
            let alertView = UIAlertController(title: "Confirmation", message: "Are you sure want to block?", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Yes", style: .Destructive, handler: { _ in
                self.blockUser()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertView.addAction(okAction)
            alertView.addAction(cancelAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
        actionsheet.addAction(cancel)
        actionsheet.addAction(report)
        actionsheet.addAction(block)
        self.presentViewController(actionsheet, animated: true, completion: nil)
    }
    
    func blockUser(){
        let urlString = URLType.BlockUserFeed.make()
        let parameters: [String: AnyObject] =
        [
            "type" : "user",
            "blocked_id" : String(self.userId!),
            "comments" : "User Block"
        ]
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        blurEffectView.alpha = 0.4
        blurEffectView.frame = self.view.bounds
        self.view.addSubview(blurEffectView)
        
        self.navigationItem.hidesBackButton = true
        self.view.userInteractionEnabled=false
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Blocking User"
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters:  parameters).handleResponse({ (successOrFail: ReportResponseJSON) -> Void in
            self.navigationItem.hidesBackButton = false
            self.view.userInteractionEnabled=true
            if successOrFail.error! {
                PixaPalsErrorType.CantBlockTheUserError.show(self, title: "Error", message: successOrFail.message.first, afterCompletion: nil)
            }else {
                PixaPalsErrorType.ReportIssueSuccessful.show(self, title: "User Blocked", message: "User is blocked successfully.")
                self.btnEdit.setTitle("Blocked", forState: .Disabled)
                self.btnEdit.enabled = false
            }
            }, errorBlock: {self}, onResponse: {
                loadingNotification.removeFromSuperview()
                blurEffectView.removeFromSuperview()
                self.navigationItem.hidesBackButton = false
                self.view.userInteractionEnabled=true
                self.navigationItem.rightBarButtonItem?.enabled = true
        })
    }
    func checkIfUserIsMyFed() {
        self.btnEdit.enabled = true
        if let userId = userId {
            if let existingUser = UserFeedDistinction.sharedInstance.getUserWithId(userId) {
                if existingUser.is_my_fed! {
                    //self.btnEdit.enabled = false
                    self.btnEdit.setTitle("UNFEED", forState: UIControlState.Normal)
                } else {
                    self.btnEdit.setTitle("GET FEED", forState: UIControlState.Normal)
                }
            }
        }
    }
    
    func followUser(id: Int){
        let user = UserDataStruct()
        
        let urlString = URLType.GetFed.make()
        
        let parameters: [String: AnyObject] =
        [
            "user_id": user.id!,
            "fed_id": id,
        ]
        
        let existingUser = UserFeedDistinction.sharedInstance.getUserWithId(id)
        
        //        if let existingUser = existingUser {
        //            existingUser.is_my_fed = true
        //        }
        self.btnEdit.enabled = false
        self.tableView.reloadData()
        let headers = [
            "X-Auth-Token" : user.api_token!,
        ]
        
        //        Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers)
        //            .responseJSON { response in
        //            switch response.result {
        //            case .Failure(let error):
        //                //print("ERROR: \(error)")
        //            case .Success(let value):
        //                //print(value)
        //            }
        //        }
        
        func enableDisableEditButton() {
            self.btnEdit.enabled = true
            if let existingUser = existingUser {
                existingUser.is_my_fed = false
                //checkIfUserIsMyFed()
            }
        }
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters:  parameters).handleResponse(
            { (getFeed: SuccessFailJSON) -> Void in
                if !getFeed.error! {
                    
                    ////print("getting feed")
                    existingUser?.is_my_fed = !(existingUser?.is_my_fed)!
                    //appDelegate.ShowAlertView("Success", message: "You are now following to \( (self.feed.user?.username)!)")
                } else {
                    enableDisableEditButton()
                    //showAlertView("Error", message: "Can't get feeds from the user. Try again.", controller: self)
                    ////print("Error: Love it error")
                    PixaPalsErrorType.CantFedTheUserError.show(self)
                }
            }, errorBlock: {
                enableDisableEditButton()
                return self
            }, onResponse: {
                self.checkIfUserIsMyFed()
                self.tableView.reloadData()
            }
        )
        
        //        requestWithHeaderXAuthToken(.POST, urlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
        //            switch response.result {
        //            case .Success(let getFeed):
        //                if !getFeed.error! {
        //                    ////print("getting feed")
        //
        //                    //appDelegate.ShowAlertView("Success", message: "You are now following to \( (self.feed.user?.username)!)")
        //                } else {
        //                    self.btnEdit.enabled = true
        //                    if let existingUser = existingUser {
        //                        existingUser.is_my_fed = false
        //                    }
        //                    //showAlertView("Error", message: "Can't get feeds from the user. Try again.", controller: self)
        //                    ////print("Error: Love it error")
        //                    PixaPalsErrorType.CantFedTheUserError.show(self)
        //                }
        //            case .Failure(let error):
        //                self.btnEdit.enabled = true
        //                if let existingUser = existingUser {
        //                    existingUser.is_my_fed = false
        //                }
        //                //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
        //                ////print("Error in connection \(error)")
        //                PixaPalsErrorType.ConnectionError.show(self)
        //            }
        //            self.tableView.reloadData()
        //        }
    }
    
    func changeNavTitle(){
        self.tabBarController?.navigationItem.title = self.navTitle ?? "Profile"
        self.navigationItem.title = self.navTitle ?? "Profile"
    }
    
    func action(){
        
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let vc: SettingsTableViewController = storyboard.instantiateViewControllerWithIdentifier("SettingsTableViewController") as! SettingsTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tryAgainPressed(sender: AnyObject) {
        if let btn = sender as? UIButton {
            btn.hidden = true
        }
        self.loadDataFromAPI()
    }
    
    private func loadDataFromAPI(){
        guard var id = UserDataStruct().id else {
            ////print("no user id")
            return
        }
        if let _ = self.userId {
            id = self.userId!
        }
        ////print(id)
        //let apiURLString = "\(apiUrl)api/v1/profile/\(id)/\(self.pageNumber)/\(self.postLimit)"
        let apiURLString = (URLs().makeURLByAddingTrailling(userId: id, pageNumber: self.pageNumber, limit: self.postLimit))(.Profile)
        ////print(apiURLString)
        guard let api_token = UserDataStruct().api_token else{
            ////print("no api token")
            return
        }
        
        let headers = [
            "X-Auth-Token" : String(api_token),
        ]
        // //print(api_token)
        
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: apiURLString, method: .GET).handleResponse(
            { (feedsResponseJSON: ProfileResponseJSON) -> Void in
                if let error = feedsResponseJSON.error where error == true {
                    self.tryAgainButton.hidden = false
                    //showAlertView("Error", message: "Error loading data from server.", controller: self)
                    
                    ////print("Error: \(feedsResponseJSON.message)")
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
                    
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    self.footerView.hidden = true
                    ////print(feedsResponseJSON.user.username)
                    self.navTitle = feedsResponseJSON.user.username
                    self.setHeader()
                }
            }, errorBlock: {
                return self
            }, onResponse: {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.blurEffectView.removeFromSuperview()
                self.tableViewRefreshControl.endRefreshing()
                self.collectionViewRefreshContol.endRefreshing()
                self.loadMoreActivityIndicator.stopAnimating()
            }
        )
        
        
        //        requestWithHeaderXAuthToken(.GET, apiURLString)
        //            //            .responseJSON { response in
        //            //                //print(response.request)
        //            //                switch response.result {
        //            //                case .Failure(let error):
        //            //                    //print(error)
        //            //                case .Success(let value):
        //            //                    //print(value)
        //            //                }
        //            //            }
        //            .responseObject { (response: Response<ProfileResponseJSON, NSError>) -> Void in
        //                switch response.result {
        //                case .Success(let feedsResponseJSON):
        //
        //                    if let error = feedsResponseJSON.error where error == true {
        //                        self.loadMoreActivityIndicator.stopAnimating()
        //                        self.tryAgainButton.hidden = false
        //                        //showAlertView("Error", message: "Error loading data from server.", controller: self)
        //
        //                        ////print("Error: \(feedsResponseJSON.message)")
        //                    } else {
        //                        if let _ = self.feedsFromResponseAsObject {
        //                            if self.refreshingStatus == true {
        //                                self.refreshingStatus = false
        //                                self.feedsFromResponseAsObject = feedsResponseJSON
        //                            } else {
        //                                if feedsResponseJSON.feeds?.count < self.postLimit && feedsResponseJSON.feeds?.count > 0{
        //                                    self.feedsFromResponseAsObject.feeds?.appendContentsOf(feedsResponseJSON.feeds!)
        //                                    self.hasMoreDataInServer = false
        //                                } else if feedsResponseJSON.feeds?.count > 0 {
        //                                    self.feedsFromResponseAsObject.feeds?.appendContentsOf(feedsResponseJSON.feeds!)
        //                                }
        //                                else {
        //                                    self.hasMoreDataInServer = false
        //                                }
        //                            }
        //                        }
        //                        else {
        //                            self.feedsFromResponseAsObject = feedsResponseJSON
        //                        }
        //
        //                        self.tableView.reloadData()
        //                        self.collectionView.reloadData()
        //                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        //                        self.blurEffectView.removeFromSuperview()
        //                        self.tableViewRefreshControl.endRefreshing()
        //                        self.collectionViewRefreshContol.endRefreshing()
        //                        self.loadMoreActivityIndicator.stopAnimating()
        //                        self.footerView.hidden = true
        //                        ////print(feedsResponseJSON.user.username)
        //                        self.navTitle = feedsResponseJSON.user.username
        //                        self.setHeader()
        //                    }
        //                case .Failure(let error):
        //                    //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
        //                    // //print("ERROR: \(error)")
        //                    PixaPalsErrorType.ConnectionError.show(self)
        //                }
        //        }
    }
    
    func setHeader() {
        self.username.text = (feedsFromResponseAsObject.user.name)!
        
        self.userImage.kf_setImageWithURL(NSURL(string: feedsFromResponseAsObject.user.photo_thumb ?? "")!, placeholderImage: UIImage(named: "global_feed_user"))
        ////print(self.feedsFromResponseAsObject.user.feeding_count)
        self.feeding.text = String(feedsFromResponseAsObject.user.feeding_count)
        self.feeders.text = String(feedsFromResponseAsObject.user.feeders_count)
        self.feeds.text = String(feedsFromResponseAsObject.user.feeds_count)
    }
    
    func refresh(sender: AnyObject) {
        
        tableViewRefreshControl.endRefreshing()
        
        // Code to refresh table view
        self.pageNumber = 1
        self.refreshingStatus = true
        self.hasMoreDataInServer = true
        loadDataFromAPI()
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

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let feed = self.feedsFromResponseAsObject?.feeds?[indexPath.row]
        self.goToDetailFeedView(feed!)
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.feedsFromResponseAsObject.feeds!.count - 1 && self.hasMoreDataInServer {
            self.loadMore()
        }
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((self.view.frame.width - 8)/3, (self.view.frame.width - 8)/3)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let ret =  self.feedsFromResponseAsObject?.feeds?.count ?? 0
        return ret
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("globalFeedCollectionViewCell", forIndexPath: indexPath) as! GlobalFeedCollectionViewCell
        
        cell.feedImage.kf_setImageWithURL(NSURL(string: self.feedsFromResponseAsObject?.feeds?[indexPath.row].photo_thumb ?? "")!,
            placeholderImage: nil,
            optionsInfo: nil,
            progressBlock: { (receivedSize, totalSize) -> () in
            },
            completionHandler: { (image, error, imageURL, String ) -> () in
                
                cell.loadingView.hideLoading()
            }
        )
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerViewOfCollectionView", forIndexPath: indexPath)
            header.addSubview(headerView)
            return header
        }
        return UICollectionReusableView()
    }
}
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 0 {
            //tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let feed = self.feedsFromResponseAsObject.feeds![indexPath.row - 1]
            self.goToDetailFeedView(feed)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
            return 320
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
            return 320
        }
        return UITableViewAutomaticDimension
    }
    
    
}
extension ProfileViewController: UITableViewDataSource {
    //    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //
    //
    //    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ret = self.feedsFromResponseAsObject?.feeds?.count ?? 0
        if ret > 0 {
            return ret + 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("profileFeedTableViewHeader")
            cell?.addSubview(headerView)
            return cell!
        } else {
            ////print(indexPath.row)
            let feed = self.feedsFromResponseAsObject.feeds![indexPath.row - 1]
            let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewCell", forIndexPath: indexPath) as! GlobalFeedTableViewCell
            //            cell.feedImage.kf_setImageWithURL(NSURL(string: feed.photo ?? "" )!, placeholderImage: UIImage(named: "loading.png"))
            
            
            cell.feedImage.kf_setImageWithURL(NSURL(string: feed.photo ?? "")!,
                placeholderImage: nil,
                optionsInfo: nil,
                progressBlock: { (receivedSize, totalSize) -> () in
                },
                completionHandler: { (image, error, imageURL, String ) -> () in
                    
                    cell.loadingView.hideLoading()
                    //                            self.blurEffectView.removeFromSuperview()
                    //                            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            })
            
            if let imagePresent = feed.photo_two?.isEmpty where imagePresent == false {
                cell.feedImage2.hidden = false
                cell.feedImage2.kf_setImageWithURL(NSURL(string: feed.photo_two ?? "")! , placeholderImage: UIImage(named: "loading.png"))
                
            } else {
                cell.feedImage2.hidden = true
            }
            cell.delegate = self
            if feed.is_my_feed! {
                cell.moreButton.hidden = true
            }else {
                cell.moreButton.hidden = false
            }
            cell.feedId = feed.id
            cell.id = (indexPath.row - 1)
            cell.loved = feed.is_my_love
            cell.left = feed.is_my_left
            cell.mode = feed.mode
            cell.loveCount.text = "\(feed.loveit ?? 0) Loved it"
            cell.loveIcon.image = UIImage(named: self.getIconName(feed.loveit ?? 0))
            if feed.mode == 1 {
                cell.leftCount.text = "\(feed.leaveit ?? 0) Left it"
                cell.leftIcon.image = UIImage(named: self.getIconName(feed.leaveit ?? 0, love: false))
            } else {
                cell.leftCount.text = "\(feed.leaveit ?? 0) Loved it"
                cell.leftIcon.image = UIImage(named: self.getIconName(feed.leaveit ?? 0))
            }
            cell.comment.text = "\(feed.comment ?? "")"
            cell.selectionStyle =  UITableViewCellSelectionStyle.None
            
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
            } else {
                ////print("here")
            }
            //        cell.imageViewObject?.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section, "photo"].string!)!)
            //        cell.DynamicView.addSubview(cell.feedImage)
            return cell
            
        }
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
        ////print(indexPath.row)
        ////print(indexPath.section)
        ////print( hasMoreDataInServer)
        ////print(indexPath.section)
        ////print(indexPath.section == self.feedsFromResponseAsObject.feeds!.count)
        ////print((indexPath.row) == (self.feedsFromResponseAsObject.feeds!.count - 1))
        ////print("\(indexPath.row) == \(self.feedsFromResponseAsObject.feeds!.count - 1)")
        //        //print(hasMoreDataInServer)
        if indexPath.row == 0 {
            return
        }
        if (indexPath.row) == (self.feedsFromResponseAsObject.feeds!.count - 1) && self.hasMoreDataInServer {
            self.loadMore()
        }
    }
    
}
extension ProfileViewController: CellImageSwippedDelegate {
    func imageSwipedLeft(id: Int, loved: Bool, left:Bool) {
        ////print("swipped love (left)")
        //        //print(id)
        //        //print(loved)
        //        //print(left)
        //left=true
        // self.loveFeed(id)
        let feed = self.feedsFromResponseAsObject.feeds![id]
        feed.loveFeed(self) {self.tableView.reloadData()}
        
    }
    func imageSwipedRight(id: Int, loved: Bool, left: Bool, mode: Int) {
        ////print("swipped leave (right)")
        //        //print(loved)
        //        //print(left)
        //        loved = true
        //        left = false
        //self.leaveit(id)
        ////print(mode)
        let feed = self.feedsFromResponseAsObject.feeds![id]
        feed.leaveFeed(self) {self.tableView.reloadData()}
        
    }
    
    func SegueToLoverList(id: Int?) {
        segueToLoverListViewController(usersArrayToDisplay: getFeedWithId(id).lovers!)
    }
    func SegueToLeaverList(id: Int?) {
        segueToLoverListViewController(usersArrayToDisplay: getFeedWithId(id).leavers!)
    }
    func SegueToProfile(id: Int?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ProfileViewController = storyBoard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        vc.userId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func segueToLoverListViewController(usersArrayToDisplay users: [UserJSON]) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("LoverListViewController") as! LoverListViewController
        vc.users = users
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getFeedWithId(id: Int?) -> FeedJSON {
        return self.feedsFromResponseAsObject.feeds![id!]
    }
    
    //    func loveFeed(id:Int){
    //        let feed = self.feedsFromResponseAsObject.feeds![id]
    //        let user = UserDataStruct()
    //
    //        let registerUrlString = "\(apiUrl)api/v1/feeds/loveit"
    //
    //        let parameters: [String: AnyObject] =
    //        [
    //            "user_id": String(user.id!),
    //            "post_id": String(feed.id!)
    //        ]
    //        let headers = [
    //            "X-Auth-Token" : user.api_token!,
    //        ]
    //
    //        self.loveCountIncrease(feed)
    //
    //        requestWithHeaderXAuthToken(.POST, registerUrlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
    //            switch response.result {
    //            case .Success(let loveItObject):
    //                if !loveItObject.error! {
    //                    feed.lovers?.append(loveItObject.user!)
    //                    feed.leavers = feed.leavers!.filter{$0.id! != loveItObject.user!.id!}
    //                } else {
    //                    self.leaveCountIncrease(feed)
    //                    //print("Error: Love it error")
    //                    PixaPalsErrorType.CantLoveItLeaveItError.show(self)
    //                }
    //            case .Failure(let error):
    //                self.leaveCountIncrease(feed)
    //                //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
    //                ////print("Error in connection \(error)")
    //                PixaPalsErrorType.ConnectionError.show(self)
    //            }
    //        }
    //    }
    //
    //
    //    func leaveit(id: Int){
    //        let feed = self.feedsFromResponseAsObject.feeds![id]
    //        let user = UserDataStruct()
    //        let registerUrlString = "\(apiUrl)api/v1/feeds/leaveit"
    //
    //        let parameters: [String: AnyObject] =
    //        [
    //            "user_id": String(user.id!),
    //            "post_id": String(feed.id!)
    //        ]
    //        let headers = [
    //            "X-Auth-Token" : user.api_token!,
    //        ]
    //
    //        self.leaveCountIncrease(feed)
    //
    //        //                Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers).responseJSON { response in
    //        //                    //print(response.request)
    //        //                    switch response.result {
    //        //                    case .Failure(let error):
    //        //                        //print(error)
    //        //                    case .Success(let value):
    //        //                        //print(value)
    //        //                    }
    //        //                }
    //
    //        requestWithHeaderXAuthToken(.POST, registerUrlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
    //            switch response.result {
    //            case .Success(let leaveItObject):
    //                if !leaveItObject.error! {
    //                    feed.leavers?.append(leaveItObject.user!)
    //                    feed.lovers = feed.lovers!.filter{$0.id! != leaveItObject.user!.id!}
    //                } else {
    //                    //print("Error: Love it error")
    //                    self.loveCountIncrease(feed)
    //                    PixaPalsErrorType.CantLoveItLeaveItError.show(self)
    //                }
    //
    //            case .Failure(let error):
    //                //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
    //                ////print("Error in connection \(error)")
    //                self.loveCountIncrease(feed)
    //                PixaPalsErrorType.ConnectionError.show(self)
    //
    //            }
    //        }
    //    }
    //
    //    func loveCountIncrease(feed: FeedJSON){
    //        feed.is_my_love = true
    //        feed.loveit = feed.loveit! + 1
    //        if feed.is_my_left! {
    //            feed.is_my_left = false
    //            feed.leaveit = feed.leaveit! - 1
    //        }
    //        self.tableView.reloadData()
    //        
    //    }
    //    
    //    func leaveCountIncrease(feed: FeedJSON){
    //        feed.is_my_left = true
    //        feed.leaveit = feed.leaveit! + 1
    //        if feed.is_my_love! {
    //            feed.is_my_love = false
    //            feed.loveit = feed.loveit! - 1
    //        }
    //        self.tableView.reloadData()
    //    }
}

extension ProfileViewController: DetailViewViewControllerProtocol {
    func needReloadData() {
        self.tableView.reloadData()
    }
}

extension ProfileViewController: ProfileEditViewControllerDelegate {
    func reloadDataAfterProfileEdit() {
        self.setHeader()
        self.navTitle = self.feedsFromResponseAsObject.user.username
    }
}
