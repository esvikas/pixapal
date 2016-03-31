//
//  DetailVIewViewController.swift
//  Pixapals
//
//  Created by ak2g on 2/3/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import MBProgressHUD
//import ObjectMapper
import AlamofireObjectMapper
import Spring

protocol DetailViewViewControllerProtocol {
    func needReloadData();
}

class DetailVIewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var getFeedButton: DesignableButton!
    
    @IBOutlet weak var refeedButton: DesignableButton!
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    var delegate: DetailViewViewControllerProtocol!
    
    //let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    
    //var refreshControl:UIRefreshControl!
    
    //var refreshingStatus = false
    //var hasMoreDataInServer = true
    
    var feed: FeedJSON?
    
    var cellIndex: NSIndexPath?
    
    var feedId: Int?
    //var collectionViewHidden = false
    
    //var feedsFromResponseAsObject: FeedsResponseJSON!
    
    //var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userProfilePic.layer.cornerRadius = self.userProfilePic.frame.height / 2
        
        self.getFeedButton.setTitle("Feeding", forState: UIControlState.Disabled)
        
        usernameLbl.userInteractionEnabled = true
        userProfilePic.userInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("labelPressed"))
        usernameLbl.addGestureRecognizer(gestureRecognizer)
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: Selector("labelPressed"))
        userProfilePic.addGestureRecognizer(gestureRecognizer2)
        
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        if feed == nil {
            self.loadDataFromAPI()
        } else {
            self.feedIsNotNil()
        }
        
        
        if navigationController!.respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            navigationController!.view.removeGestureRecognizer(navigationController!.interactivePopGestureRecognizer!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        checkIfToEnableOrDisableGetFeedButton()
    }
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem?.enabled=false
    }
    
    @IBAction func refeedFeed(sender: AnyObject) {
        guard let feed = feed else {
            return
        }
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        blurEffectView.alpha = 0.4
        blurEffectView.frame = view.bounds
        self.view.addSubview(blurEffectView)
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Re-feeding"
        
        let refeedUrl = URLType.Refeed.make()
        let parameters: [String: AnyObject] =
        [
            "post_id": feed.id!
        ]
        self.refeedButton.enabled = false
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: refeedUrl, parameters: parameters).handleResponse(
            { (refeedResponse: SuccessFailJSON) -> Void in
                if refeedResponse.error! {
                    PixaPalsErrorType.CantRefeedError.show(self)
                } else {
                    self.refeedButton.hidden = true
                }
            }, errorBlock: {
                return self
            }, onResponse: {
                blurEffectView.removeFromSuperview()
                loadingNotification.removeFromSuperview()
                self.refeedButton.enabled = true
            }
        )
        
        //        requestWithHeaderXAuthToken(.POST, refeedUrl, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
        //            switch response.result {
        //            case .Success(let refeedResponse):
        //                if refeedResponse.error! {
        //                    PixaPalsErrorType.CantRefeedError.show(self)
        //                } else {
        //                    self.refeedButton.hidden = true
        //                }
        //            case .Failure(let error):
        //                print(error)
        //                PixaPalsErrorType.ConnectionError.show(self)
        //            }
        //
        //        }
        //        .responseJSON { response in
        //                    switch response.result {
        //                    case .Failure(let error):
        //                        print("ERROR: \(error)")
        //                    case .Success(let value):
        //                        print(value)
        //                    }
        //                }
        //
    }
    
    @IBAction func btnFollowUser(sender: AnyObject) {
        
        guard let feed = feed else {
            return
        }
        let user = UserDataStruct()
        
        let urlString = URLType.GetFed.make()
        
        let parameters: [String: AnyObject] =
        [
            "user_id": user.id!,
            "fed_id": (feed.user?.id!)!,
        ]
        self.getFeedButton.enabled = false
        feed.user?.is_my_fed = true
        //.responseJSON { response in
        //            switch response.result {
        //            case .Failure(let error):
        //                print("ERROR: \(error)")
        //            case .Success(let value):
        //                print(value)
        //            }
        //        }
        
        func getFeedButtonEnabled() {
            self.getFeedButton.enabled = true
            feed.user?.is_my_fed = false
        }
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters: parameters).handleResponse(
            { (getFeed: SuccessFailJSON) -> Void in
                if !getFeed.error! {
                    //print("getting feed")
                    self.triggerDelegateNeedReloadData()
                    //appDelegate.ShowAlertView("Success", message: "You are now following to \( (self.feed.user?.username)!)")
                } else {
                    getFeedButtonEnabled()
                    //print(getFeed.message)
                    //print("Error: feeding error")
                    PixaPalsErrorType.CantFedTheUserError.show(self)
                }
            }, errorBlock: {
                getFeedButtonEnabled()
                return self
            }
        )
        
        
        //        requestWithHeaderXAuthToken(.POST, urlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
        //            switch response.result {
        //            case .Success(let getFeed):
        //                if !getFeed.error! {
        //                    print("getting feed")
        //                    self.triggerDelegateNeedReloadData()
        //                    //appDelegate.ShowAlertView("Success", message: "You are now following to \( (self.feed.user?.username)!)")
        //                } else {
        //                    self.getFeedButton.enabled = true
        //                    feed.user?.is_my_fed = false
        //                    print(getFeed.message)
        //                    print("Error: feeding error")
        //                    PixaPalsErrorType.CantFedTheUserError.show(self)
        //                }
        //            case .Failure(let error):
        //                self.getFeedButton.enabled = true
        //                feed.user?.is_my_fed = false
        //                PixaPalsErrorType.ConnectionError.show(self)
        //                //print("Error in connection \(error)")
        //            }
        //        }
        
    }
    private func feedIsNotNil() {
        if let _ = feed {
            self.checkIfToEnableOrDisableGetFeedButton()
            self.setUserInfo()
        }
    }
    
    private func setUserInfo() {
        self.usernameLbl.text = (feed!.user!.is_my_profile!) ? (feed?.user?.username)! + " (YOU)" : feed!.user?.username
        //self.usernameLbl.text = feed!.user?.username
        self.userProfilePic.kf_setImageWithURL(NSURL(string: feed!.user!.photo_thumb!)!, placeholderImage: self.userProfilePic.image)
    }
    private func triggerDelegateNeedReloadData() {
        if let _ = self.delegate {
            self.delegate.needReloadData()
        }
    }
    
    func labelPressed() {
        guard let feed = feed else {
            return
        }
        if !feed.is_my_feed! {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc: ProfileViewController = storyBoard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            vc.userId = feed.user?.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func checkIfToEnableOrDisableGetFeedButton () {
        guard let feed = feed else {
            return
        }
        self.refeedButton.hidden = true
        if feed.is_my_feed! {
            self.getFeedButton.hidden = true
            if feed.is_outdated! {
                self.refeedButton.hidden = false
            }
        }else if (feed.user?.is_my_fed)!{
            self.getFeedButton.enabled = false
        }
    }
    
    func loadDataFromAPI() {
        guard let feedId = feedId else {
            return
        }
        
        let urls: Int -> String = {
            id in
            return URLType.Feed.make() + String(id)
        }
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urls(feedId), method: .GET).handleResponse(
            { (getFeed: FeedsResponseJSON) -> Void in
                if let count = getFeed.feeds?.count where count > 0{
                    //print("getting feed")
                    self.feed = getFeed.feeds?.first
                    self.feedIsNotNil()
                    self.tableView.reloadData()
                    //appDelegate.ShowAlertView("Success", message: "You are now following to \( (self.feed.user?.username)!)")
                } else {
                    PixaPalsErrorType.CantFedTheUserError.show(self)
                    //print("Error: getting feed error")
                }
            }, errorBlock: {self})
        
        //        requestWithHeaderXAuthToken(.GET, urlString)
        //            //            .responseJSON { response in
        //            //                switch response.result {
        //            //                case .Failure(let error):
        //            //                    print("ERROR: \(error)")
        //            //                case .Success(let value):
        //            //                    print(value)
        //            //                }
        //            //            }
        //            .responseObject { (response: Response<FeedsResponseJSON, NSError>) -> Void in
        //                switch response.result {
        //                case .Success(let getFeed):
        //                    if let count = getFeed.feeds?.count where count > 0{
        //                        print("getting feed")
        //                        self.feed = getFeed.feeds?.first
        //                        self.feedIsNotNil()
        //                        self.tableView.reloadData()
        //                        //appDelegate.ShowAlertView("Success", message: "You are now following to \( (self.feed.user?.username)!)")
        //                    } else {
        //                        PixaPalsErrorType.CantFedTheUserError.show(self)
        //                        print("Error: getting feed error")
        //                    }
        //                case .Failure(let error):
        //                    PixaPalsErrorType.ConnectionError.show(self)
        //                    print("Error in connection \(error)")
        //                }
        //        }
    }
}

extension DetailVIewViewController: UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = feed {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewCell", forIndexPath: indexPath) as! GlobalFeedTableViewCell
        
        
        //cell.feedImage.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section, "photo"].string!)!, placeholderImage: UIImage(named: "loading.png"))
        //        cell.feedImage.kf_setImageWithURL(NSURL(string: feed.photo ?? "")!, placeholderImage: UIImage(named: "loading.png"))
        
        
        cell.feedImage.kf_setImageWithURL(NSURL(string: feed!.photo ?? "")!,
            placeholderImage: nil,
            optionsInfo: nil,
            progressBlock: { (receivedSize, totalSize) -> () in
            },
            completionHandler: { (image, error, imageURL, String ) -> () in
                
                cell.loadingView.hideLoading()
        })
        
        if let imagePresent = feed!.photo_two?.isEmpty where imagePresent == false {
            cell.feedImage2.hidden = false
            cell.feedImage2.kf_setImageWithURL(NSURL(string: feed!.photo_two ?? "")! , placeholderImage: UIImage(named: "loading.png"))
        } else {
            cell.feedImage2.hidden = true
        }
        //        if let imagePresent = feedsToShow[indexPath.section,"photo_two"].string?.isEmpty where imagePresent == false {
        //            cell.feedImage2.hidden = false
        //            cell.feedImage2.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section,"photo_two"].string!)! , placeholderImage: UIImage(named: "loading.png"))
        //        } else {
        //            cell.feedImage2.hidden = true
        //        }
        if feed!.is_my_feed! {
            cell.moreButton.hidden = true
        }
        cell.delegate = self
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        cell.feedId = feed!.id
        cell.id = feed!.id
        cell.left = feed!.is_my_left
        cell.loved = feed!.is_my_love
        cell.mode = feed!.mode
        cell.loveCount.text = "\(feed!.loveit ?? 0) Loved it"
        cell.loveIcon.image = UIImage(named: self.getIconName(feed!.loveit ?? 0))
        if feed!.mode == 1 {
            cell.leftCount.text = "\(feed!.leaveit ?? 0) Left it"
            cell.leftIcon.image = UIImage(named: self.getIconName(feed!.leaveit ?? 0, love: false))
        } else {
            cell.leftCount.text = "\(feed!.leaveit ?? 0) Loved it"
            cell.leftIcon.image = UIImage(named: self.getIconName(feed!.leaveit ?? 0))
        }
        cell.comment.text = "\(feed!.comment ?? "")"
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
    
    
}

extension DetailVIewViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        //return self.view.frame.height - (20 + 44 + 49)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    
}




extension DetailVIewViewController: CellImageSwippedDelegate {
    
    func imageSwipedLeft(id: Int, loved: Bool, left:Bool) {
        //print("swipped love (left)")
        self.feed?.loveFeed(self, completionHandler: {self.tableView.reloadData()})
    }
    func imageSwipedRight(id: Int, loved: Bool, left: Bool, mode: Int) {
        //print("swipped leave (right)")
        self.feed?.leaveFeed(self, completionHandler: {self.tableView.reloadData()})
    }
    
    func SegueToLoverList(id: Int?) {
        segueToLoverListViewController(usersArrayToDisplay: getFeedWithId(id).lovers!)
    }
    func SegueToLeaverList(id: Int?) {
        segueToLoverListViewController(usersArrayToDisplay: getFeedWithId(id).leavers!)
    }
    func SegueToProfile(id: Int?) {
        if let is_my_profile = self.feed?.user?.is_my_profile where is_my_profile {
            return
        }
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
        return self.feed!
    }
    
//    func loveFeed(postId:String){
//        let user = UserDataStruct()
//        
//        let urlString = "\(apiUrl)api/v1/feeds/loveit"
//        
//        let parameters: [String: AnyObject] =
//        [
//            "user_id": user.id!,
//            "post_id": postId
//            
//        ]
//        let headers = [
//            "X-Auth-Token" : user.api_token!,
//        ]
//        
//        self.loveCountIncrease()
//        
//        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters: parameters).handleResponse(
//            { (loveItObject: SuccessFailJSON) -> Void in
//                if !loveItObject.error! {
//                    self.feed?.lovers?.append(loveItObject.user!)
//                    self.feed?.leavers = self.feed?.leavers!.filter{$0.id! != loveItObject.user!.id!}
//                } else {
//                    PixaPalsErrorType.CantLoveItLeaveItError.show(self)
//                    print("Error: Love it error")
//                    self.leaveCountIncrease()
//                }
//            }, errorBlock: {
//                self.leaveCountIncrease()
//                return self
//            }
//        )
//        
//        
////        requestWithHeaderXAuthToken(.POST, urlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
////            switch response.result {
////            case .Success(let loveItObject):
////                if !loveItObject.error! {
////                    self.feed?.lovers?.append(loveItObject.user!)
////                    self.feed?.leavers = self.feed?.leavers!.filter{$0.id! != loveItObject.user!.id!}
////                } else {
////                    PixaPalsErrorType.CantLoveItLeaveItError.show(self)
////                    print("Error: Love it error")
////                    self.leaveCountIncrease()
////                }
////            case .Failure(let error):
////                //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
////                //print("Error in connection \(error)")
////                PixaPalsErrorType.ConnectionError.show(self)
////                self.leaveCountIncrease()
////            }
////        }
//        
//        //            .responseJSON { response in
//        //                switch response.result {
//        //                case .Failure(let error):
//        //                    print(error)
//        //                case .Success(let value):
//        //                    print(value)
//        //                }
//        //        }
//        
//        //        Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers).responseJSON { response in
//        //            switch response.result {
//        //            case .Failure(let error):
//        //                print(error)
//        //            case .Success(let value):
//        //                print(value)
//        //            }
//        //        }
//        
//    }
//    
//    
//    func leaveit(postId:String){
//        let user = UserDataStruct()
//        let urlString = "\(apiUrl)api/v1/feeds/leaveit"
//        
//        let parameters: [String: AnyObject] =
//        [
//            "user_id": user.id!,
//            "post_id": postId
//            
//        ]
//        let headers = [
//            "X-Auth-Token" : user.api_token!,
//        ]
//        
//        self.leaveCountIncrease()
//        
//        
//        //        Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers).responseJSON { response in
//        //            switch response.result {
//        //            case .Failure(let error):
//        //                print(error)
//        //            case .Success(let value):
//        //                print(value)
//        //            }
//        //        }
//        
//        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters: parameters).handleResponse(
//            { (leaveItObject: SuccessFailJSON) -> Void in
//                if !leaveItObject.error! {
//                    self.feed?.leavers?.append(leaveItObject.user!)
//                    self.feed?.lovers = self.feed?.lovers!.filter{$0.id! != leaveItObject.user!.id!}
//                } else {
//                    PixaPalsErrorType.CantLoveItLeaveItError.show(self)
//                    print("Error: Leave it error")
//                    self.loveCountIncrease()
//                }
//            }, errorBlock: {
//                self.loveCountIncrease()
//                return self
//            }
//        )
//        
////        requestWithHeaderXAuthToken(.POST, urlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
////            switch response.result {
////            case .Success(let leaveItObject):
////                if !leaveItObject.error! {
////                    self.feed?.leavers?.append(leaveItObject.user!)
////                    self.feed?.lovers = self.feed?.lovers!.filter{$0.id! != leaveItObject.user!.id!}
////                } else {
////                    PixaPalsErrorType.CantLoveItLeaveItError.show(self)
////                    print("Error: Leave it error")
////                    self.loveCountIncrease()
////                }
////            case .Failure(let error):
////                self.loveCountIncrease()
////                PixaPalsErrorType.ConnectionError.show(self)
////                //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
////                //print("Error in connection \(error)")
////            }
////        }
//        //            .responseJSON { response in
//        //                            switch response.result {
//        //                            case .Failure(let error):
//        //                                print(error)
//        //                            case .Success(let value):
//        //                                print(value)
//        //                            }
//        //                        }
//    }
    
    func loveCountIncrease(){
        self.feed!.is_my_love = true
        self.feed!.loveit = self.feed!.loveit! + 1
        if self.feed!.is_my_left! {
            self.feed!.is_my_left = false
            self.feed!.leaveit = self.feed!.leaveit! - 1
        }
        self.tableView.reloadData()
        self.triggerDelegateNeedReloadData()
    }
    
    func leaveCountIncrease(){
        self.feed!.is_my_left = true
        self.feed!.leaveit = self.feed!.leaveit! + 1
        if self.feed!.is_my_love! {
            self.feed!.is_my_love = false
            self.feed!.loveit = self.feed!.loveit! - 1
        }
        self.tableView.reloadData()
        self.triggerDelegateNeedReloadData()
    }
}

