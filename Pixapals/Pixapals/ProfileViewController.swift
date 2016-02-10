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
    let postLimit = 3
    
    var feedsFromResponseAsObject: ProfileResponseJSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        self.tabBarController?.navigationItem.title = "User Profile"
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "setting"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: Selector("action"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.tabBarController?.navigationItem.rightBarButtonItem = rightBarButton

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
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let vc: ProfileEditViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileEditViewController") as! ProfileEditViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
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
            print("no user id")
            return
        }
        if let _ = self.userId {
            id = self.userId!
        }
        let apiURLString = "\(apiUrl)api/v1/profile/\(id)/\(self.pageNumber)/\(self.postLimit)"
        print(apiURLString)
        guard let api_token = UserDataStruct().api_token else{
            print("no api token")
            return
        }
        
        let headers = [
            "X-Auth-Token" : String(api_token),
        ]
        print(api_token)
        
        
       requestWithHeaderXAuthToken(.GET, apiURLString)
            .responseJSON { response in
                print(response.request)
                switch response.result {
                case .Failure(let error):
                    print(error)
                case .Success(let value):
                    print(value)
                }
            }
            .responseObject { (response: Response<ProfileResponseJSON, NSError>) -> Void in
            switch response.result {
            case .Success(let feedsResponseJSON):
                
                if let error = feedsResponseJSON.error where error == true {
                    self.loadMoreActivityIndicator.stopAnimating()
                    self.tryAgainButton.hidden = false
                    //                    appDelegate.ShowAlertView("Connection Error", message: "Try Again", handlerForOk: { (action) -> Void in
                    //                        self.loadDataFromAPI()
                    //                        }, handlerForCancel: nil)
                    
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
                    
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.blurEffectView.removeFromSuperview()
                    self.tableViewRefreshControl.endRefreshing()
                    self.collectionViewRefreshContol.endRefreshing()
                    self.loadMoreActivityIndicator.stopAnimating()
                    self.footerView.hidden = true
                    self.tabBarController?.navigationItem.title = feedsResponseJSON.user.username
                }

//                let json = JSON(value)
//                print(json)
//                if !json["error"].boolValue {
//                    self.feedsToShow = json
                    self.setHeader()
//                    // print(self.feedsToShow)
//                    self.tableView.reloadData()
//                    self.collectionView.reloadData()
//                    self.tableViewFooterView.hidden = false
//                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                    self.blurEffectView.removeFromSuperview()
//                    self.refreshControl.endRefreshing()
//                } else {
//                    print("Error: \(json["message"])")
//                    self.refreshControl.endRefreshing()
//                }
            case .Failure(let error):
                print("ERROR: \(error)")
            }
            }.progress { (a, b, c) -> Void in
                print("\(a) -- \(b) -- \(c)")
        }
    }
    
    func setHeader() {
        if let username = UserDataStruct().username {
          self.username.text = username
        }else {
            print("no username")
        }
        
        self.userImage.kf_setImageWithURL(NSURL(string: self.feedsFromResponseAsObject.user.photo_thumb ?? "")!, placeholderImage: UIImage(named: "global_feed_user"))
        //print(self.feedsFromResponseAsObject.user.feeding_count)
        self.feeding.text = String(self.feedsFromResponseAsObject.user.feeding_count)
        self.feeders.text = String(self.feedsFromResponseAsObject.user.feeders_count)
        self.feeds.text = String(self.feedsFromResponseAsObject.user.feeds_count)

//        self.userImage.kf_setImageWithURL(NSURL(string: self.feedsToShow["photo_thumb"].string ?? "")!, placeholderImage: UIImage(named: "global_feed_user"))
//        print(self.feedsToShow["feeds_count"])
//        self.feeding.text = String(self.feedsToShow["feeding_count"].int!)
//        self.feeders.text = String(self.feedsToShow["feeders_count"].int!)
//        self.feeds.text = String(self.feedsToShow["feeds_count"].int!)
    }
    
    func refresh(sender: AnyObject) {
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
     
        cell.feedImage.kf_setImageWithURL(NSURL(string: self.feedsFromResponseAsObject?.feeds?[indexPath.row].photo_thumb ?? "")!, placeholderImage: UIImage(named: "post-feed-img"))

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
            print(indexPath.row)
            let feed = self.feedsFromResponseAsObject.feeds![indexPath.row - 1]
            let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewCell", forIndexPath: indexPath) as! GlobalFeedTableViewCell
            cell.feedImage.kf_setImageWithURL(NSURL(string: feed.photo ?? "" )!, placeholderImage: UIImage(named: "loading.png"))
            
            if let imagePresent = feed.photo_two?.isEmpty where imagePresent == false {
                cell.feedImage2.hidden = false
                cell.feedImage2.kf_setImageWithURL(NSURL(string: feed.photo_two ?? "")! , placeholderImage: UIImage(named: "loading.png"))
            } else {
                cell.feedImage2.hidden = true
            }
            cell.delegate = self
            cell.id = (indexPath.row - 1)
            cell.loved = feed.is_my_love
            cell.left = feed.is_my_left
            cell.loveCount.text = "\(feed.loveit ?? 0) loved it"
            cell.leftCount.text = "\(feed.leaveit ?? 0) left it"
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
                print("here")
            }
            //        cell.imageViewObject?.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section, "photo"].string!)!)
            //        cell.DynamicView.addSubview(cell.feedImage)
            return cell

        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //print(indexPath.row)
        //print(indexPath.section)
        //print( hasMoreDataInServer)
        //print(indexPath.section)
        //print(indexPath.section == self.feedsFromResponseAsObject.feeds!.count)
        //print((indexPath.row) == (self.feedsFromResponseAsObject.feeds!.count - 1))
        //print("\(indexPath.row) == \(self.feedsFromResponseAsObject.feeds!.count - 1)")
//        print(hasMoreDataInServer)
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
        print("swipped leave (left)")
        //        print(id)
        //        print(loved)
        //        print(left)
        //left=true
        
        self.leaveit(id)
    }
    func imageSwipedRight(id: Int,  loved: Bool,  left: Bool) {
        print("swipped love (right)")
        //        print(loved)
        //        print(left)
        //        loved = true
        //        left = false
        self.loveFeed(id)
    }
    
    func loveFeed(id:Int){
        let feed = self.feedsFromResponseAsObject.feeds![id]
        let user = UserDataStruct()
        
        let registerUrlString = "\(apiUrl)api/v1/feeds/loveit"
        
        let parameters: [String: AnyObject] =
        [
            "user_id": user.id!,
            "post_id": feed.id!
            
        ]
        let headers = [
            "X-Auth-Token" : user.api_token!,
        ]
        
        
        
        //Alamofire.request(.GET, apiURLString, parameters: nil, headers: headers).responseObject { (response: Response<FeedsResponseJSON, NSError>) -> Void in
       requestWithHeaderXAuthToken(.POST, registerUrlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
            switch response.result {
            case .Success(let loveItObject):
                if !loveItObject.error! {
                    feed.is_my_love = true
                    feed.loveit = feed.loveit! + 1
                    if feed.is_my_left! {
                        feed.is_my_left = false
                        feed.leaveit = feed.leaveit! - 1
                    }
                    self.tableView.reloadData()
                } else {
                    print("Error: Love it error")
                }
            case .Failure(let error):
                print("Error in connection \(error)")
            }
        }
        //        Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers).responseJSON { response in
        //            switch response.result {
        //            case .Failure(let error):
        //                print(error)
        //            case .Success(let value):
        //                print(value)
        //            }
        //        }
        
    }
    
    
    func leaveit(id: Int){
        let feed = self.feedsFromResponseAsObject.feeds![id]
        let user = UserDataStruct()
        let registerUrlString = "\(apiUrl)api/v1/feeds/leaveit"
        
        let parameters: [String: AnyObject] =
        [
            "user_id": user.id!,
            "post_id": feed.id!
            
        ]
        let headers = [
            "X-Auth-Token" : user.api_token!,
        ]
        
        
        
        
        //        Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers).responseJSON { response in
        //            switch response.result {
        //            case .Failure(let error):
        //                print(error)
        //            case .Success(let value):
        //                print(value)
        //            }
        //        }
        
        requestWithHeaderXAuthToken(.POST, registerUrlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
            switch response.result {
            case .Success(let leaveItObject):
                if !leaveItObject.error! {
                    feed.is_my_left = true
                    feed.leaveit = feed.leaveit! + 1
                    if feed.is_my_love! {
                        feed.is_my_love = false
                        feed.loveit = feed.loveit! - 1
                    }
                    self.tableView.reloadData()
                } else {
                    print("Error: Leave it error")
                }
            case .Failure(let error):
                print("Error in connection \(error)")
            }
        }
        
        
    }
}

extension ProfileViewController: DetailViewViewControllerProtocol {
    func needReloadData() {
        self.tableView.reloadData()
    }
}
