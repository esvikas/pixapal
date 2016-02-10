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
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    var delegate: DetailViewViewControllerProtocol!
    
    //let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    
    //var refreshControl:UIRefreshControl!
    
    //var refreshingStatus = false
    //var hasMoreDataInServer = true
    
    var feed: FeedJSON!
    
    
    //var collectionViewHidden = false
    
    //var feedsFromResponseAsObject: FeedsResponseJSON!
    
    //var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLbl.text = feed.user?.username
        if (self.feed.is_my_feed)! || (self.feed.user?.is_my_fed)! {
            self.getFeedButton.titleLabel?.text = "Feeding"
            self.getFeedButton.enabled = false
        }
            //getFeedButton.enabled = false
      
        //self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view
        
        
        //self.blurEffectView.alpha = 0.4
        // blurEffectView.frame = view.bounds
        //        self.view.addSubview(self.blurEffectView)
        //        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        //        loadingNotification.labelText = "Loading"
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        //        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "square"), style: .Plain, target: self, action: "changeViewMode:")
        //
        //        self.tabBarController?.navigationItem.title = self.title ?? "Global Feed"
        //        self.tabBarController?.navigationItem.hidesBackButton = true
        //        self.tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func btnFollowUser(sender: AnyObject) {
        
        let user = UserDataStruct()
        
        let registerUrlString = "\(apiUrl)api/v1/profile/getfed"
        
        let parameters: [String: AnyObject] =
        [
            "user_id": user.id!,
            "fed_id": (feed.user?.id!)!,
        ]
        
//        let headers = [
//            "X-Auth-Token" : user.api_token!,
//        ]
        
        //        Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers).responseJSON { response in
        //            switch response.result {
        //            case .Failure(let error):
        //                print("ERROR: \(error)")
        //            case .Success(let value):
        //                print(value)
        //            }
        //        }
        requestWithHeaderXAuthToken(.POST, registerUrlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
            switch response.result {
            case .Success(let getFeed):
                if !getFeed.error! {
                    print("getting feed")
                    
                    appDelegate.ShowAlertView("Success", message: "You are now following to \( self.feed.user?.id)")
                    self.getFeedButton.enabled = false
                    self.getFeedButton.titleLabel?.text = "Feeding"
                } else {
                    print("Error: Love it error")
                }
            case .Failure(let error):
                print("Error in connection \(error)")
            }
        }
        
    }
    private func triggerDelegateNeedReloadData() {
        if let _ = self.delegate {
            self.delegate.needReloadData()
        }
    }
    
}

extension DetailVIewViewController: UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewCell", forIndexPath: indexPath) as! GlobalFeedTableViewCell
        
        
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
        cell.selectionStyle =  UITableViewCellSelectionStyle.None

        cell.id = feed.id
        cell.left = feed.is_my_left
        cell.loved = feed.is_my_love
        
        cell.loveCount.text = "\(feed.loveit ?? 0) loved it"
        cell.leftCount.text = "\(feed.leaveit ?? 0) left it"
        cell.comment.text = "\(feed.comment ?? "")"
        //print(feedsToShow)
        return cell
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
    
    
    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let feed = self.feedsFromResponseAsObject.feeds![section]
    //        let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewHeaderCell") as! GlobalFeedTableViewHeaderCell
    //        cell.userProfilePic.kf_setImageWithURL(NSURL(string: feed.user!.photo_thumb!)!, placeholderImage: cell.userProfilePic.image)
    //        cell.username.text = feed.user?.username
    //        if let createdAt = feed.created_at {
    //            //let dateFormatter = NSDateFormatter()
    //            //dateFormatter.dateFormat = "y-MM-dd HH:mm:ss"
    //            // if let date = dateFormatter.dateFromString(createdAt) {
    //            var textTimeElapsed = ""
    //            let timeInSecond = Int(NSDate().timeIntervalSinceDate(createdAt))
    //            if timeInSecond/60 < 0 {
    //                textTimeElapsed = "\(timeInSecond) sec ago"
    //            } else if timeInSecond/(60*60) < 1 {
    //                textTimeElapsed = "\(timeInSecond/60) mins ago"
    //            }else if timeInSecond/(60*60*24) < 1 {
    //                textTimeElapsed = "\(timeInSecond/(60*60)) hrs ago"
    //            }else if timeInSecond/(60*60*24*7) < 1 {
    //                textTimeElapsed = "\(timeInSecond/(60*60*24)) days ago"
    //            }else if timeInSecond/(60*60*24*7) > 1 {
    //                textTimeElapsed = "\(timeInSecond/(60*60*24*7)) weeks ago"
    //            }
    //            cell.timeElapsed.text = textTimeElapsed
    //            //}
    //        }
    //        return cell
    //    }
    
    //        func scrollViewDidScroll(scrollView: UIScrollView) {
    //            if let tblView = scrollView as? UITableView where tblView == self.tableView {
    //                if (scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height && hasMoreDataInServer)
    //                {
    //                    self.loadMore()
    //                    print("here")
    //                }
    //            }
    //        }
    
}




extension DetailVIewViewController: CellImageSwippedDelegate {
    func imageSwipedLeft(id: Int, loved: Bool, left:Bool) {
        print("swipped leave (left)")
        //        print(id)
        //        print(loved)
        //        print(left)
        //left=true
        
        self.leaveit(String(id))
    }
    func imageSwipedRight(id: Int, loved: Bool,  left: Bool) {
        print("swipped love (right)")
        //        print(loved)
        //        print(left)
        //        loved = true
        //        left = false
        self.loveFeed(String(id))
    }
    
    func loveFeed(postId:String){
        let user = UserDataStruct()
        
        let registerUrlString = "\(apiUrl)api/v1/feeds/loveit"
        
        let parameters: [String: AnyObject] =
        [
            "user_id": user.id!,
            "post_id": postId
            
        ]
        let headers = [
            "X-Auth-Token" : user.api_token!,
        ]
        
        
        
        //Alamofire.request(.GET, apiURLString, parameters: nil, headers: headers).responseObject { (response: Response<FeedsResponseJSON, NSError>) -> Void in
        requestWithHeaderXAuthToken(.POST, registerUrlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
            switch response.result {
            case .Success(let loveItObject):
                if !loveItObject.error! {
                    self.feed.is_my_love = true
                    self.feed.loveit = self.feed.loveit! + 1
                    if self.feed.is_my_left! {
                        self.feed.is_my_left = false
                        self.feed.leaveit = self.feed.leaveit! - 1
                    }
                    self.tableView.reloadData()
                    self.triggerDelegateNeedReloadData()
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
    
    
    func leaveit(postId:String){
        let user = UserDataStruct()
        let registerUrlString = "\(apiUrl)api/v1/feeds/leaveit"
        
        let parameters: [String: AnyObject] =
        [
            "user_id": user.id!,
            "post_id": postId
            
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
                    self.feed.is_my_left = true
                    self.feed.leaveit = self.feed.leaveit! + 1
                    if self.feed.is_my_love! {
                        self.feed.is_my_love = false
                        self.feed.loveit = self.feed.loveit! - 1
                    }
                    self.tableView.reloadData()
                    self.triggerDelegateNeedReloadData()
                } else {
                    print("Error: Leave it error")
                }
            case .Failure(let error):
                print("Error in connection \(error)")
            }
        }
        
        
    }
}

