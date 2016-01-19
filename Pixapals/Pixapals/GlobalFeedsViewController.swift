//
//  GlobalFeedsViewController.swift
//  Pixapals
//
//  Created by DARI on 1/12/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class GlobalFeedsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewHidden = false
    override func viewDidLoad() {
        super.viewDidLoad()
       //self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        self.changeViewMode(self)
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "square"), style: .Plain, target: self, action: "changeViewMode:")
        
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

    func changeViewMode(sender: AnyObject) {
        if self.collectionViewHidden {
            self.collectionView.hidden = false
            self.tableView.hidden = true
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            self.tabBarController?.navigationItem.rightBarButtonItem?.image = UIImage(named: "global_feed_grid_menu")
        } else {
            self.collectionView.hidden = true
            self.tableView.hidden = false
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
            self.tabBarController?.navigationItem.rightBarButtonItem?.image = UIImage(named: "square")

        }
        self.collectionViewHidden = !self.collectionViewHidden
    }
}

extension GlobalFeedsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("globalFeedTableViewCell", forIndexPath: indexPath) as! GlobalFeedTableViewCell
        cell.username.text = "Username"
        cell.timeElapsed.text = "2 hr ago"
        cell.feedImage.image = UIImage(named: "logo")
        cell.loveCount.text = "999 loved it"
        cell.leftCount.text = "99 left it"
        cell.comment.text = "adsd gdf rew f erg rdfdg we df herertg ergererte wsewer"
        return cell
    }
   
}

extension GlobalFeedsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height
    }
}

extension GlobalFeedsViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("globalFeedCollectionViewCell", forIndexPath: indexPath) as! GlobalFeedCollectionViewCell
        cell.feedImage.image  = UIImage(named: "logo")
        return cell
    }
}
extension GlobalFeedsViewController: UICollectionViewDelegate{
    
}

