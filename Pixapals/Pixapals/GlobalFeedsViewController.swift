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


class GlobalFeedsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))

    
    
    var collectionViewHidden = false
    var feedsToShow: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        self.loadDataFromAPI()
        self.changeViewMode(self)
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "square"), style: .Plain, target: self, action: "changeViewMode:")
    
        self.blurEffectView.alpha = 0.4
        blurEffectView.frame = view.bounds
        self.view.addSubview(self.blurEffectView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.navigationItem.title = "Global Feed"
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
    
    private func loadDataFromAPI(){
        guard let id = UserDataStruct().id else {
            print("no user id")
            return
        }
        
        let apiURLString = "\(apiUrl)api/v1/feeds/global/\(id)"
        guard let api_token = UserDataStruct().api_token else{
            print("no api token")
            return
        }
        
        let headers = [
            "X-Auth-Token" : api_token,
        ]
        
        Alamofire.request(.GET, apiURLString, parameters: nil, headers: headers).responseJSON { response -> Void in
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                
                if !json["error"].boolValue {
                    self.feedsToShow = json
                   // print(self.feedsToShow)
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.blurEffectView.removeFromSuperview()
                } else {
                    print("Error: \(json["message"])")
                }
            case .Failure(let error):
                print("ERROR: \(error)")
            }
            }.progress { (a, b, c) -> Void in
                print("\(a) -- \(b) -- \(c)")
        }
    }

    
    func changeViewMode(sender: AnyObject) {
        if self.collectionViewHidden {
            self.collectionView.hidden = false
            self.tableView.hidden = true
            if let _ = feedsToShow?.count {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }
            self.tabBarController?.navigationItem.rightBarButtonItem?.image = UIImage(named: "global_feed_grid_menu")
        } else {
            self.collectionView.hidden = true
            self.tableView.hidden = false
            if let _ = feedsToShow?.count {
                self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
            }
            self.tabBarController?.navigationItem.rightBarButtonItem?.image = UIImage(named: "square")
            
        }
        self.collectionViewHidden = !self.collectionViewHidden
    }
}

extension GlobalFeedsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return feedsToShow?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewCell", forIndexPath: indexPath) as! GlobalFeedTableViewCell
        cell.feedImage.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section, "photo"].string!)!, placeholderImage: UIImage(named: "loading.png"))
        if let imagePresent = feedsToShow[indexPath.section,"photo_two"].string?.isEmpty where imagePresent == false {
            cell.feedImage2.hidden = false
            cell.feedImage2.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section,"photo_two"].string!)! , placeholderImage: UIImage(named: "loading.png"))
        } else {
            cell.feedImage2.hidden = true
        }
        cell.loveCount.text = "\(feedsToShow[indexPath.section, "loveit"].string ?? "0") love it"
        cell.leftCount.text = "\(feedsToShow[indexPath.section, "leaveit"].string ?? "0") left it"
        cell.comment.text = "\(feedsToShow[indexPath.section, "comment"].string ?? "")"
//        cell.imageViewObject?.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section, "photo"].string!)!)
//        cell.DynamicView.addSubview(cell.feedImage)
        print(cell.feedImage.frame.height)
        print((string: feedsToShow[indexPath.section,"photo_two"].string!))
        print((string: feedsToShow[indexPath.section,"photo"].string!))

        return cell
    }
    
}

extension GlobalFeedsViewController: UITableViewDelegate {
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewHeaderCell") as! GlobalFeedTableViewHeaderCell
        cell.userProfilePic.kf_setImageWithURL(NSURL(string: feedsToShow[section, "user", "photo_thumb"].string!)!, placeholderImage: cell.userProfilePic.image)
        cell.username.text = feedsToShow[section, "user", "username"].string
        if let createdAt = feedsToShow[section, "created_at"].string {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "y-MM-dd HH:mm:ss"
            if let date = dateFormatter.dateFromString(createdAt) {
                var textTimeElapsed = ""
                let timeInSecond = Int(NSDate().timeIntervalSinceDate(date))
                if timeInSecond/60 < 0 {
                    textTimeElapsed = "\(timeInSecond) sec ago"
                } else if timeInSecond/(60*60) < 1 {
                    textTimeElapsed = "\(timeInSecond/60) mins ago"
                }else if timeInSecond/(60*60*24) < 1 {
                    textTimeElapsed = "\(timeInSecond/(60*60)) hrs ago"
                }else if timeInSecond/(60*60*24*7) < 1 {
                    textTimeElapsed = "\(timeInSecond/(60*60*24)) days ago"
                }else if timeInSecond/(60*60*24*7) > 1 {
                    textTimeElapsed = "\(timeInSecond/(60*60*24*7)) weeks ago"
                }
                cell.timeElapsed.text = textTimeElapsed
            }
        }
        return cell
    }
}

extension GlobalFeedsViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(feedsToShow?.count)
        return feedsToShow?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("globalFeedCollectionViewCell", forIndexPath: indexPath) as! GlobalFeedCollectionViewCell
        cell.feedImage.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.row, "photo_thumb"].string!)!, placeholderImage: UIImage(named: "post-feed-img"))
        
        return cell
    }
}
extension GlobalFeedsViewController: UICollectionViewDelegate{
    
}
extension GlobalFeedsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((self.view.frame.width - 44)/2, (self.view.frame.width - 44)/2)
    }
    
    
    
}

