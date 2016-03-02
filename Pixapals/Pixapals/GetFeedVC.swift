//
//  GetFeedVC.swift
//  
//
//  Created by ak2g on 3/1/16.
//
//

import UIKit

class GetFeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    
    
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    
    
    
    }
    


}


extension GetFeedVC: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        print(self.feedsFromResponseAsObject?.feeds?.count)
        return self.feedsFromResponseAsObject?.feeds?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewCell", forIndexPath: indexPath) as! GlobalFeedTableViewCell
        
        let feed = (self.feedsFromResponseAsObject.feeds?[indexPath.section])!
        
        print(feed.mode)
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        
        //print(feedsToShow)
        return cell
    }
    
    

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.section == self.feedsFromResponseAsObject.feeds!.count - 1 && self.hasMoreDataInServer {
            self.loadMore()
        }
    }
    
}

extension GetFeedVC: UITableViewDelegate {
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            let feed = (self.feedsFromResponseAsObject.feeds?[indexPath.section])!
            
            
            self.goToDetailFeedView(feed)
            
            
        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
            //return self.view.frame.height - (20 + 44 + 49)
        }
        
        func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
        }
        

        
        
        

}
