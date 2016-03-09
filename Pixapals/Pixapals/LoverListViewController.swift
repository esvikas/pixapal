//
//  LoverListViewController.swift
//  Pixapals
//
//  Created by ak2g on 2/11/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire

class LoverListViewController: UIViewController {
    
    var users: [UserJSON]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.hidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LoverListTableViewCell", forIndexPath: indexPath) as! LoverListTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        cell.username.text = user.username
        if (user.is_my_fed)! {
            cell.getFeedButton.enabled = false
        }
        cell.profileImageView.kf_setImageWithURL(NSURL(string: user.photo_thumb!)!, placeholderImage: cell.profileImageView.image)
        cell.delegate = self
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

extension LoverListViewController: loverListTableViewCellDelegate {
    func getFeedClicked(sender: UIButton, user: UserJSON) {
        
        sender.enabled = false
        
        let LoggedInUser = UserDataStruct()
        
        let urlString = "\(apiUrl)api/v1/profile/getfed"
        
        let parameters: [String: AnyObject] =
        [
            "user_id": LoggedInUser.id!,
            "fed_id": user.id!,
        ]
        user.is_my_fed = true
        
        func changeUserIsMyFed() {
            user.is_my_fed = false
            sender.enabled = true
        }
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters:  parameters).handleResponse(
            {(getFeed: SuccessFailJSON) -> Void in
                if !getFeed.error! {
                    
                    print("Getting feed")
                } else {
                    changeUserIsMyFed()
                    print("Error: feeding error")
                    PixaPalsErrorType.CantFedTheUserError.show(self)
                }
            }, errorBlock: {
                changeUserIsMyFed()
                return self
            }
        )
        
//        requestWithHeaderXAuthToken(.POST, urlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
//            switch response.result {
//            case .Success(let getFeed):
//                if !getFeed.error! {
//                    
//                    print("Getting feed")
//                } else {
//                    user.is_my_fed = false
//                    sender.enabled = true
//                    print("Error: feeding error")
//                    PixaPalsErrorType.CantFedTheUserError.show(self)
//                }
//            case .Failure(let error):
//                user.is_my_fed = false
//                sender.enabled = true
//                PixaPalsErrorType.ConnectionError.show(self)
//                //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
//                //print("Error in connection \(error)")
//            }
//        }
    }
    
    func usernameClicked(id: Int?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        vc.userId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}