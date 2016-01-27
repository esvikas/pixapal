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

class ProfileViewController: UIViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var feeding: UILabel!
    @IBOutlet weak var feeders: UILabel!
    @IBOutlet weak var feeds: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var tableViewFooterView: UIView!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    let refreshControl = UIRefreshControl()
    
    var collectionViewHidden = false
    var feedsToShow: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        
        
        self.tableViewFooterView.hidden = true
        self.headerView.frame.size.width = self.view.frame.width
        
        self.loadDataFromAPI()
       // self.view.addSubview(collectionView)
        // Do any additional setup after loading the view.
        self.collectionView.hidden = true
        
        self.blurEffectView.alpha = 0.4
        self.blurEffectView.frame = view.bounds
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
        self.tabBarController?.navigationItem.title = "User Profile"
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
    
    private func loadDataFromAPI(){
        guard let id = UserDataStruct().id else {
            print("no user id")
            return
        }
        
        let apiURLString = "\(apiUrl)api/v1/profile/\(id)"
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
                print(json)
                if !json["error"].boolValue {
                    self.feedsToShow = json
                    self.setHeader()
                    // print(self.feedsToShow)
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    self.tableViewFooterView.hidden = false
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.blurEffectView.removeFromSuperview()
                    self.refreshControl.endRefreshing()
                } else {
                    print("Error: \(json["message"])")
                    self.refreshControl.endRefreshing()
                }
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
        self.userImage.kf_setImageWithURL(NSURL(string: self.feedsToShow["photo_thumb"].string ?? "")!, placeholderImage: UIImage(named: "global_feed_user"))
        print(self.feedsToShow["feeds_count"])
        self.feeding.text = String(self.feedsToShow["feeding_count"].int!)
        self.feeders.text = String(self.feedsToShow["feeders_count"].int!)
        self.feeds.text = String(self.feedsToShow["feeds_count"].int!)
    }
    
    func refresh(sender: AnyObject) {
        // Code to refresh table view
        loadDataFromAPI()
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((self.view.frame.width - 8)/3, (self.view.frame.width - 8)/3)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedsToShow?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("globalFeedCollectionViewCell", forIndexPath: indexPath) as! GlobalFeedCollectionViewCell
        cell.feedImage.kf_setImageWithURL(NSURL(string: feedsToShow["feeds",indexPath.row, "photo_thumb"].string!)!, placeholderImage: UIImage(named: "post-feed-img"))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerViewOfCollectionView", forIndexPath: indexPath)
        header.addSubview(headerView)
        return header
    }
}
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return feedsToShow?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("profileFeedTableViewHeader")
            cell?.addSubview(headerView)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewCell", forIndexPath: indexPath) as! GlobalFeedTableViewCell
            cell.feedImage.kf_setImageWithURL(NSURL(string: feedsToShow["feeds",indexPath.section-1, "photo"].string!)!, placeholderImage: UIImage(named: "loading.png"))
            
            if let imagePresent = feedsToShow["feeds",indexPath.section-1,"photo_two"].string?.isEmpty where imagePresent == false {
                cell.feedImage2.hidden = false
                cell.feedImage2.kf_setImageWithURL(NSURL(string: feedsToShow["feeds",indexPath.section-1,"photo_two"].string!)! , placeholderImage: UIImage(named: "loading.png"))
            } else {
                cell.feedImage2.hidden = true
            }
            
            cell.loveCount.text = "\(feedsToShow["feeds",indexPath.section-1, "loveit"].string ?? "0") love it"
            cell.leftCount.text = "\(feedsToShow["feeds",indexPath.section-1, "leaveit"].string ?? "0") left it"
            cell.comment.text = "\(feedsToShow["feeds", indexPath.section-1, "comment"].string ?? "")"
            //        cell.imageViewObject?.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section, "photo"].string!)!)
            //        cell.DynamicView.addSubview(cell.feedImage)
            return cell

        }
    }

}
