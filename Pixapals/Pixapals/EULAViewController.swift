//
//  EULAViewController.swift
//  Pixapals
//
//  Created by DARI on 3/17/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import MBProgressHUD

class EULAViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var termsAndCondition: [[String: String]]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.getDataFromAPI()
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
    func getDataFromAPI(){
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        blurEffectView.alpha = 0.4
        blurEffectView.frame = self.view.bounds
        self.view.addSubview(blurEffectView)
        
        self.navigationItem.hidesBackButton = true
        self.view.userInteractionEnabled=false
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
        let url = URLType.TermsAndConditions.make()
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: url, method: .GET).giveResponseJSON(
            { (data) -> Void in
                self.termsAndCondition = data as? [[String: String]]
            }, errorBlock: {self}, onResponse: {
                loadingNotification.removeFromSuperview()
                blurEffectView.removeFromSuperview()
                self.navigationItem.hidesBackButton = false
                self.view.userInteractionEnabled=true
        })
    }
    
}
extension EULAViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let termsAndCondition = self.termsAndCondition {
            return termsAndCondition.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("EulaTitleCell")
        
        if let termsAndCondition = self.termsAndCondition {
            let text = termsAndCondition[section]["title"]
            cell?.textLabel?.text = text
        }
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EulaDescriptionCell", forIndexPath: indexPath) as! EULADescriptionTableViewCell
        //cell.textLabel?.text = "hello"
        if let termsAndCondition = self.termsAndCondition {
            cell.termDescription?.text = termsAndCondition[indexPath.section]["descriptions"]
        }
        return cell
    }
}
