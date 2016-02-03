//
//  LocationChooserViewController.swift
//  Pixapals
//
//  Created by ak2g on 1/28/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class LocationChooserViewController: UIViewController {

    @IBOutlet var LocationChooserTable: UITableView!
    
    var datasource = ["Africa","Antarctic","Asia","Europe",
        "North & Central America","Oceania","South America"]
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
extension LocationChooserViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK:  table view data source methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
   return datasource.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = self.LocationChooserTable.dequeueReusableCellWithIdentifier("InterestTableViewCell") as! InterestTableViewCell

        

                        cell.InterestLael?.text = (datasource[indexPath.row] as String)
                        cell.selectionStyle =  UITableViewCellSelectionStyle.None
                        cell.tikButton.setImage(UIImage(named: "tick"), forState: .Normal)
                        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
print(datasource[indexPath.row] as String)
nsUserDefault.setObject(datasource[indexPath.row] as String, forKey: "UserLocationForFilter")
    self.navigationController?.popViewControllerAnimated(true)
    }
    

    
}

