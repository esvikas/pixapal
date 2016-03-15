//
//  SocialFeedersViewController.swift
//  Pixapals
//
//  Created by DARI on 3/10/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import MBProgressHUD

class SocialFeedersViewController: UIViewController {
    
    var users = [UserJSON]()
    
    var pageNumber = 1
    
    var itemLimit = 15
    
    var serverHasMoreData = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var ButtonTryAgain: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        footerView.hidden = true
        self.getDataFrom()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.hidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnTryAgain(sender: AnyObject) {
        self.getDataFrom()
    }
    
    func getDataFrom() {
        
        self.checkFbLogin {loginManager in
            let url = URLType.FaceBookFriends.make()
            let parameters: [String: AnyObject] =
            [
                "facebook_id": (FBSDKAccessToken.currentAccessToken()?.userID)!,
                "access_token": (FBSDKAccessToken.currentAccessToken()?.tokenString)!,
                "page": self.pageNumber,
                "limit": self.itemLimit
            ]
            let gettingDataViews = self.showProcessHUD()
            APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: url, parameters: parameters)
//                            .giveResponseJSON({ (x) -> Void in
//                                print(x)
//                                }, errorBlock: { () -> UIViewController in
//                                    self
//                            })
                .handleResponse(
                    { (feedersFriendsJSON: FeedersFriendsJSON) -> Void in
                        if !feedersFriendsJSON.error {
                            if let users = feedersFriendsJSON.users {
                                self.users.appendContentsOf(users)
                                print(users.count)
                                if users.count < self.itemLimit {
                                    self.serverHasMoreData = false
                                }
                            }
                            (self.hideButtonTryAgain())(true)
                            (self.hideActivityIndicator())(true)
                            self.tableView.reloadData()
                        } else {
                            func message() -> String? {
                                if let message = feedersFriendsJSON.message {
                                    let msg = message.reduce("", combine: {
                                        if $1 == "This facebook is already used." && loginManager != nil{
                                            loginManager!.logOut()
                                        }
                                       return $0 + "\n" + $1
                                    })
                                    return msg
                                }
                                return nil
                            }
                            (self.hideActivityIndicator())(true)
                            (self.hideButtonTryAgain())(false)
                            print("Error: finding feeders error")
                            PixaPalsErrorType.CantFindFeedersError.show(self, message: message())
                        }
                    }, errorBlock:
                    {
                        (self.hideActivityIndicator())(true)
                        (self.hideButtonTryAgain())(false)
                        
                        return self
                    }
                    )
                    {
                    
                    gettingDataViews.0.removeFromSuperview()
                    gettingDataViews.1.removeFromSuperview()
            }
        }
    }
    
    func hideFooter()-> Bool -> (){
        return {
            self.footerView.hidden = $0
        }
    }
    
    func hideActivityIndicator() -> Bool -> () {
        return {
            state in
            (self.hideFooter())(state)
            if !state {
                self.activityIndicator.startAnimating()
            }else {
                self.activityIndicator.stopAnimating()
            }
            self.activityIndicator.hidden = state
        }
    }
    
    func hideButtonTryAgain() -> Bool -> () {
        return {
            state in
            (self.hideFooter())(state)
            self.ButtonTryAgain.hidden = state
        }
    }
    
    func showProcessHUD() -> (MBProgressHUD, UIVisualEffectView) {
        let view = UIVisualEffectView(frame: self.view.frame)
        //let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        view.effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        view.alpha = 0.4
        self.view.addSubview(view)
        
        let loading = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loading.mode = MBProgressHUDMode.Indeterminate
        loading.labelText = "Loading"
        return (loading, view)
    }
    
    func checkFbLogin(completionHandler: (FBSDKLoginManager?) -> ()){
        //print(FBSDKAccessToken.currentAccessToken()?.tokenString)
        //print(FBSDKAccessToken.currentAccessToken()?.userID)
        
        FBSDKAccessToken.refreshCurrentAccessToken(nil)
        
        func fbLogin() {
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self, handler: {
                (result, error) -> Void in
                
                if result == nil{
                    return
                }
                if result.isCancelled {
                    fbLoginManager.logOut()
                }else if (error != nil) {
                    PixaPalsErrorType.FacebookLoginConnectionError.show(self, afterCompletion: {
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    
                }else{
                    let fbloginresult : FBSDKLoginManagerLoginResult = result
                    
                    if(fbloginresult.grantedPermissions.contains("user_friends"))
                    {
                        //getFBUserData()
                        completionHandler(fbLoginManager)
                    }
                }
            })
        }
        if FBSDKAccessToken.currentAccessToken() == nil {
            fbLogin()
        } else {
            if FBSDKAccessToken.currentAccessToken().expirationDate.compare(NSDate()) == NSComparisonResult.OrderedAscending {
                fbLogin()
            }else {
                completionHandler(nil)
            }
        }
    }
    
}


extension SocialFeedersViewController: UITableViewDataSource {
    
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
        return cell
    }
}

extension SocialFeedersViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.users.count && self.serverHasMoreData {
            (self.hideActivityIndicator())(false)
            self.pageNumber++
            getDataFrom()
        }
    }
    
}

extension SocialFeedersViewController: loverListTableViewCellDelegate {
    func getFeedClicked(sender: UIButton, user: UserJSON) {
        
        sender.enabled = false
        
        let LoggedInUser = UserDataStruct()
        
        let urlString = URLType.GetFed.make()
        
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
    }
    
    func usernameClicked(id: Int?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        vc.userId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}