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


class DetailVIewViewController: UIViewController {



    
    @IBOutlet weak var tableView: UITableView!
    
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    
    var refreshControl:UIRefreshControl!
    
    var refreshingStatus = false
    var hasMoreDataInServer = true
    
    var feed: FeedJSON!

    
    var collectionViewHidden = false
    
    var feedsFromResponseAsObject: FeedsResponseJSON!
    
    var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
        
        print(feed.id)
        
        
        self.blurEffectView.alpha = 0.4
        blurEffectView.frame = view.bounds
//        self.view.addSubview(self.blurEffectView)
//        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        loadingNotification.mode = MBProgressHUDMode.Indeterminate
//        loadingNotification.labelText = "Loading"
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "square"), style: .Plain, target: self, action: "changeViewMode:")
        
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
    
 
    @IBAction func btnFollowUser(sender: AnyObject) {
        
        
        
    }
    
    
    
    

    
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        self.pageNumber = 1
        self.refreshingStatus = true
    }
    
    func loadMore() {
        self.pageNumber++
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
        
        cell.id = feed.id
        cell.left = feed.is_my_left
        cell.loved = feed.is_my_love
        
        
        cell.loveCount.text = "\(feed.loveit ?? 0) love it"
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
    
        func scrollViewDidScroll(scrollView: UIScrollView) {
            if let tblView = scrollView as? UITableView where tblView == self.tableView {
                if (scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height && hasMoreDataInServer)
                {
                    self.loadMore()
                    print("here")
                }
            }
        }
    
}




extension DetailVIewViewController: CellImageSwippedDelegate {
    func imageSwipedLeft(id: Int, loved: Bool, var left:Bool) {
        print("swipped Left")
        print(id)
        print(loved)
        print(left)
        left=true
        
        leaveit(String(id))
    }
    func imageSwipedRight(id: Int, var loved: Bool, var left: Bool) {
        print("swipped right")
        print(loved)
        print(left)
        loved = true
        left = false
        loveFeed(String(id))
    }
    
    func loveFeed(postId:String){
        
        let registerUrlString = "\(apiUrl)api/v1/feeds/loveit"
        
        _ = NSUserDefaults.standardUserDefaults()
        
        let parameters: [String: AnyObject] =
        [
            "user_id": "1",
            "post_id": postId
            
        ]
        let headers = [
            "X-Auth-Token" : "c353c462bb19d45f5d60d14ddf7ec3664c0eeaaaede6309c03dd8129df745b91",
        ]
        
        
        
        
        Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers)
            .responseJSON { response in
                
                switch response.result {
                case .Success(let data):
                    if let dict = data["user"] as? [String: AnyObject] {
                        let userInfoStruct = UserDataStruct()
                        userInfoStruct.saveUserInfoFromJSON(jsonContainingUserInfo: dict)
                        
                        print("LovedIt \(postId)")
                    }
                    else {
                        print(data)
                        print("Failed")
                    }
                case .Failure(let error):
                    print("Error in connection \(error)")
                }
        }
        
        
    }
    
    
    func leaveit(postId:String){
        
        let registerUrlString = "\(apiUrl)api/v1/feeds/leaveit"
        
        _ = NSUserDefaults.standardUserDefaults()
        
        let parameters: [String: AnyObject] =
        [
            "user_id": "1",
            "post_id": postId
            
        ]
        let headers = [
            "X-Auth-Token" : "c353c462bb19d45f5d60d14ddf7ec3664c0eeaaaede6309c03dd8129df745b91",
        ]
        
        
        
        
        Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers)
            .responseJSON { response in
                
                switch response.result {
                case .Success(let data):
                    if let dict = data["user"] as? [String: AnyObject] {
                        let userInfoStruct = UserDataStruct()
                        userInfoStruct.saveUserInfoFromJSON(jsonContainingUserInfo: dict)
                        
                        print("LovedIt \(postId)")
                    }
                    else {
                        print(data)
                        print("Failed")
                    }
                case .Failure(let error):
                    print("Error in connection \(error)")
                }
        }
        
        
    }
}

