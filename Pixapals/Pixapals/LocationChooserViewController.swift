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
    
    var datasource = ["Africa", "South & Southeast Asia", "North Africa", "Europe","Sub-Saharan Africa","North & Cental America", "Antarctica", "Caribbean Islands", "Asia", "Mesoamerica", "East Asia", "North America", "North Asia", "Oceania", "West & Central Asia", "South America"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select Region"
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
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
        cell.selectionStyle =  UITableViewCellSelectionStyle.None

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

