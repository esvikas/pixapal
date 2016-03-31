//
//  SettingsTableViewController.swift
//  Pixapals
//
//  Created by ak2g on 1/27/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Alamofire

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var genderDetailText: UILabel!
    @IBOutlet var locationDetailText: UILabel!
    var pickerDataSource = ["All", "Male", "Female"];
    var picker = UIPickerView()
    var pickerDateToolbar:UIToolbar?
    var actionView: UIView = UIView()
    var window: UIWindow? = nil
    
    var dataChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "report_form_left_arrow"), style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        reloadView()
        self.getPreferencesData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        reloadView()
        
    }
    func getPreferencesData(){
        let url = URLType.PreferenceGet.make() + "\(UserDataStruct().id)"
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: url, method: .GET).giveResponseJSON({ (data) -> Void in
            if let dict = data as? [String: AnyObject] {
                if let errorStatus = dict["error"] as? Bool where !errorStatus {
                    if let gender = dict["message"]?["gender"] as? String{
                        nsUserDefault.setObject((gender == "") ? "All" : gender, forKey: "UserGenderForFilter")
                    }
                    if let region = dict["message"]?["region"]?["name"] as? String {
                        nsUserDefault.setObject(region, forKey: "UserLocationForFilter")
                    }
                }
            }
            self.reloadView()
            }, errorBlock: {self})
    }
    
    func reloadView(){
        
        nsUserDefault.synchronize()
        locationDetailText.text =  nsUserDefault.objectForKey("UserLocationForFilter") as? String
        genderDetailText.text =  nsUserDefault.objectForKey("UserGenderForFilter") as? String
        self.tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch(indexPath.section){
            
        case 0:
            
            ////print(indexPath.row)
            if indexPath.row==1{
                uiPickerMaker()
                PickerAction()
                
            } else {
                
                let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("LocationChooserViewController") as! LocationChooserViewController
                self.navigationController?.pushViewController(vc, animated: true)
                dataChanged=true
            }
            
        case 1:
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SocialFeedersViewController") as! SocialFeedersViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("ReportAnIssueViewController") as! ReportAnIssueViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            logoutRequest()
        default: break
           // //print("Error")
            
        }
    }
    
    func back(sender: UIBarButtonItem) {
        
        if  dataChanged == true {
            
            if genderDetailText.text != nil && locationDetailText.text != nil {
                preference()
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
        
        
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
        ////print(pickerDataSource.count, terminator: "")
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
        dataChanged=true
        reloadView()
        
        
    }
    
    func preference(){
        let user = UserDataStruct()
        let urlString = URLType.PreferencesPost.make()
        
        let parameters: [String: AnyObject] =
        [
            "user_id": String(user.id!),
            "gender": String(genderDetailText.text!),
            "region": String(locationDetailText.text!)
        ]
        //        //print(parameters)
        //
        //        let headers = [
        //            "X-Auth-Token" : user.api_token!,
        //        ]
        
        
        //                Alamofire.request(.POST, registerUrlString, parameters: parameters, headers:headers).responseJSON { response in
        //                    //print(response.request)
        //                    switch response.result {
        //                    case .Failure(let error):
        //                        //print(error)
        //                    case .Success(let value):
        //                        //print(value)
        //                    }
        //                }
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: urlString, parameters: parameters).handleResponse(
            { (successObject: SuccessFailJSON) -> Void in
                ////print("Set successfully \(successObject.message)")
            }, errorBlock: {self})
        
        //        requestWithHeaderXAuthToken(.POST, registerUrlString, parameters: parameters).responseObject { (response: Response<SuccessFailJSON, NSError>) -> Void in
        //            switch response.result {
        //            case .Success(let successObject):
        //                //print("Set successfully \(successObject.message)")
        //
        //            case .Failure(let error):
        //                //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
        //                ////print("Error in connection \(error)")
        //                PixaPalsErrorType.ConnectionError.show(self)
        //            }
        //        }
    }
    
    
    func logoutRequest(){
        //let user = UserDataStruct()
        let registerUrlString = URLType.Logout.make()
        
        
        //        let headers = [
        //            "X-Auth-Token" : String(user.api_token!),
        //        ]
        
        APIManager(requestType: RequestType.WithXAuthTokenInHeader, urlString: registerUrlString, method: .GET).giveResponseJSON({_ in self.logOut()}, errorBlock:{self})
        
        //        Alamofire.request(.GET, registerUrlString, parameters: nil, headers:headers).responseJSON { response in
        //            //print(response.request)
        //            switch response.result {
        //            case .Success( _ ):
        //
        //                self.logOut()
        //
        //
        //            case .Failure(let error):
        //                ////print("Error in connection \(error)")
        //                //showAlertView("Error", message: "Can't connect right now.Check your internet settings.", controller: self)
        //                PixaPalsErrorType.ConnectionError.show(self)
        //            }
        //        }
        //        //print(headers)
        
    }
    func logOut(){
        
        
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[0], animated: true);
        
        
        
    }
    
}
extension SettingsTableViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    
}

