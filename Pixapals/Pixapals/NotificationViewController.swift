//
//  NotificationViewController.swift
//  Pixapals
//
//  Created by DARI on 2/15/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
override func viewDidLoad() {
        super.viewDidLoad()
        //lbl.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    
    tableView.emptyDataSetDelegate=self
    tableView.emptyDataSetSource=self
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

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return tableView.dequeueReusableCellWithIdentifier("notificationHeaderCell", forIndexPath: indexPath)
    }
}

extension NotificationViewController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Sorry"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "There are no posts to show."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "logo")
    }
    
    //    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
    //        let str = "More info"
    //        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
    //        return NSAttributedString(string: str, attributes: attrs)
    //    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        let ac = UIAlertController(title: "Info will be listed here", message: nil, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
}
