//
//  LoverListViewController.swift
//  Pixapals
//
//  Created by ak2g on 2/11/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class LoverListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

}


extension LoverListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LoverListTableViewCell", forIndexPath: indexPath) as! LoverListTableViewCell
        
//        let feed = (self.feedsFromResponseAsObject.feeds?[indexPath.section])!
//        
//        //cell.feedImage.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section, "photo"].string!)!, placeholderImage: UIImage(named: "loading.png"))
//        cell.feedImage.kf_setImageWithURL(NSURL(string: feed.photo ?? "")!, placeholderImage: UIImage(named: "loading.png"))
//        
//        if let imagePresent = feed.photo_two?.isEmpty where imagePresent == false {
//            cell.feedImage2.hidden = false
//            cell.feedImage2.kf_setImageWithURL(NSURL(string: feed.photo_two ?? "")! , placeholderImage: UIImage(named: "loading.png"))
//        } else {
//            cell.feedImage2.hidden = true
//        }
//        //        if let imagePresent = feedsToShow[indexPath.section,"photo_two"].string?.isEmpty where imagePresent == false {
//        //            cell.feedImage2.hidden = false
//        //            cell.feedImage2.kf_setImageWithURL(NSURL(string: feedsToShow[indexPath.section,"photo_two"].string!)! , placeholderImage: UIImage(named: "loading.png"))
//        //        } else {
//        //            cell.feedImage2.hidden = true
//        //        }
//        
//        cell.delegate = self
//        
//        cell.id = indexPath.section
//        cell.left = feed.is_my_left
//        cell.loved = feed.is_my_love
//        cell.selectionStyle =  UITableViewCellSelectionStyle.None
//        
//        
//        cell.loveCount.text = "\(feed.loveit ?? 0) loved it"
//        cell.leftCount.text = "\(feed.leaveit ?? 0) left it"
//        cell.comment.text = "\(feed.comment ?? "")"
//        //print(feedsToShow)
        return cell
    }
    

    
}

extension LoverListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

        
        
    }
    

    

    
    
    
    
}