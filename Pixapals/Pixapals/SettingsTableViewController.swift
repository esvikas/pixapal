//
//  SettingsTableViewController.swift
//  Pixapals
//
//  Created by ak2g on 1/27/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet var genderDetailText: UILabel!
    @IBOutlet var locationDetailText: UILabel!
    var pickerDataSource = ["All", "Male", "Female"];
    var picker = UIPickerView()
    var pickerDateToolbar:UIToolbar?
    var actionView: UIView = UIView()
    var window: UIWindow? = nil





    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
      locationDetailText.text =  nsUserDefault.objectForKey("UserLocationForFilter") as? String
      genderDetailText.text =  nsUserDefault.objectForKey("UserGenderForFilter") as? String

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.section){

        case 0:

        print(indexPath.row)
        if indexPath.row==1{
            uiPickerMaker()
            PickerAction()

        } else {
            
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            let vc: LocationChooserViewController = storyboard.instantiateViewControllerWithIdentifier("LocationChooserViewController") as! LocationChooserViewController
            self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 1:
        appDelegate.ShowAlertView("Sorry ", message: "Not available")
            
        case 2:
logOut()
            
        default:
            print("Error")
            
        }
    }

    
    func logOut(){
        
        
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[0], animated: true);

    }
    
    func PickerAction(){
        
        
        self.view.endEditing(true)
        
        let barItems = NSMutableArray()
        
        let labelCancel = UILabel()
        labelCancel.text = "Cancel"
        var titleCancel = UIBarButtonItem(title: labelCancel.text, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPickerSelectionButtonClicked:"))
        //     barItems.addObject(titleCancel)
        
        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barItems.addObject(flexSpace)
        
        picker.reloadAllComponents()
        
        
        picker.selectRow(1, inComponent: 0, animated: false)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("countryDoneClicked:"))
        doneBtn.tintColor=UIColor.whiteColor()
        barItems.addObject(doneBtn)
        
        pickerDateToolbar!.setItems(barItems as AnyObject as? [UIBarButtonItem], animated: true)
        
        actionView.addSubview(pickerDateToolbar!)
        actionView.addSubview(picker)
        
        if (window != nil) {
            window!.addSubview(actionView)
        }
        else
        {
            self.view.addSubview(actionView)
        }
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 300, UIScreen.mainScreen().bounds.size.width, 260.0)
            
        })
    }
    
    func uiPickerMaker(){
        let kSCREEN_WIDTH  =    UIScreen.mainScreen().bounds.size.width
        picker.frame = CGRectMake(0.0, 44.0,kSCREEN_WIDTH, 216.0)
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true;
        picker.backgroundColor = UIColor.whiteColor()
        
        pickerDateToolbar = UIToolbar(frame: CGRectMake(0, 0, kSCREEN_WIDTH, 44))
        pickerDateToolbar!.barStyle = UIBarStyle.Black
        pickerDateToolbar!.barTintColor = UIColor(red: 20/255, green: 153/255, blue: 236/255, alpha: 1)
        pickerDateToolbar!.translucent = true
        
    }
    
    func addBottomBorderWithColor(iew: UIView) {
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(12, iew.frame.size.height - 1, self.view.frame.size.width, 1.0);
        
        bottomBorder.backgroundColor = UIColor.groupTableViewBackgroundColor().CGColor
        iew.layer.addSublayer(bottomBorder)
        
    }
    
    
    func pickerView(_pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(pickerDataSource.count, terminator: "")
        return pickerDataSource.count
        
    }
    
    func numberOfComponentsInPickerView(_pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerDataSource[row]
            as String
    }
    
    func countryDoneClicked(sender: UIBarButtonItem) {
        if (genderDetailText.text)?.characters.count != 0 && genderDetailText.text != nil {

        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
        }
    }
    
    func cancelPickerSelectionButtonClicked(sender: UIBarButtonItem) {
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        genderDetailText.text=pickerDataSource[row]
        nsUserDefault.setObject(pickerDataSource[row], forKey: "UserGenderForFilter")


    }

}
extension SettingsTableViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    
}

