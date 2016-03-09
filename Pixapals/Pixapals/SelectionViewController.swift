//
//  SelectionViewController.swift
//  Pixapals
//
//  Created by DARI on 3/2/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
protocol SelectionViewControllerDelegate {
    func selectedOptionText(text: String)
}

class SelectionViewController: UIViewController {
    var options = [String]()
    var delegate: SelectionViewControllerDelegate!
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
//MARK:- tableview delegate
extension SelectionViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SelectionTableViewCell
        self.delegate.selectedOptionText(cell.lblTitle.text!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
//MARK:- tableview Datasource
extension SelectionViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SelectionTableViewCell
        cell.lblTitle.text = options[indexPath.row]
        return cell
    }
}
