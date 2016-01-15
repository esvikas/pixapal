//
//  ProfileViewController.swift
//  Pixapals
//
//  Created by DARI on 1/12/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.frame.size.width = self.view.frame.width
       // self.view.addSubview(collectionView)
        // Do any additional setup after loading the view.
        collectionView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func gridView(sender: AnyObject) {
        collectionView.hidden = false
        tableView.hidden = true
        collectionView.reloadData()
    }
    @IBAction func listView(sender: AnyObject) {
        collectionView.hidden = true
        tableView.hidden = false
        tableView.reloadData()
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

extension ProfileViewController: UICollectionViewDelegate {
    
    
}

//var newController = storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[sender.selectedSegmentIndex]) as UIViewController
//let oldController = childViewControllers.last as UIViewController
//
//oldController.willMoveToParentViewController(nil)
//addChildViewController(newController)
//newController.view.frame = oldController.view.frame
//
//transitionFromViewController(oldController, toViewController: newController, duration: 0.25, options: .TransitionCrossDissolve, animations:{ () -> Void in
//    // nothing needed here
//    }, completion: { (finished) -> Void in
//        oldController.removeFromParentViewController()
//        newController.didMoveToParentViewController(self)
//})

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 150
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("profileFeedCollectionViewCell", forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerViewOfCollectionView", forIndexPath: indexPath)
        header.addSubview(headerView)
        return header
    }
}
extension ProfileViewController: UITableViewDelegate {
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//        //let header = tableView.de
//        
//        //let header = tableView.dequeueReusableCellWithIdentifier("profileFeedTableViewHeader")
//        let header = tableView.dequeueReusableCellWithIdentifier("profileFeedTableViewHeader")
//        header?.addSubview(headerView)
//        
//        return header
//    }
//    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 320
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
            return 320
        }
        return 44
    }
}
extension ProfileViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 150
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("profileFeedTableViewHeader")
            cell?.addSubview(headerView)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("profileViewTableViewCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Hello \(indexPath.row)"
            return cell
        }
    }

}
