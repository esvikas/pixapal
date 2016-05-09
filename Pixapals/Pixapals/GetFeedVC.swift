//
//  GetFeedVC.swift
//  
//
//  Created by ak2g on 3/1/16.
//
//

import UIKit
import Alamofire
import SwiftyJSON



class GetFeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    
//    loadDataFromAPI()
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    
    
    
    }
    
    
    
    private func loadDataFromAPI(){
        guard let id = UserDataStruct().id else {
            ////print("no user id")
            return
        }
        
        var apiURLString = ""

        apiURLString = "api/v1/profile/fb-following-details"
        
       
        ////print(apiURLString)
        guard let api_token = UserDataStruct().api_token else{
           // //print("no api token")
            return
        }
        
        let headers = [
            "X-Auth-Token" : String(api_token),
        ]
        
        let parameters = [
            "X-Auth-Token" : ["213423531","123456"]
        ]
        
                Alamofire.request(.GET, apiURLString, parameters: parameters, headers: headers)
                    //requestWithHeaderXAuthToken(.GET, apiURLString)
                    .responseJSON { response -> Void in
                        ////print(response.request)
                        switch response.result {
                        case .Success(let value):
                            print(JSON(value))
                        case .Failure(let error):
                            print(error)
                        }
                }
        

    }


}


extension GetFeedVC: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GetFeedTableViewCell", forIndexPath: indexPath) as! GetFeedTableViewCell
        
        
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        
        ////print(feedsToShow)
        return cell
    }
    
    

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

      
    }
    
}

extension GetFeedVC: UITableViewDelegate {
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            
            
            
            
        }
        

        
  
        

        
        
        

}
