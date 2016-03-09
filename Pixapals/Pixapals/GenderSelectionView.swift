//
//  GenderSelectionView.swift
//  Pixapals
//
//  Created by ak2g on 2/2/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

protocol funcDelegate {
    func chooseSex(sex:String)
}

class GenderSelectionView: UIViewController {
    
    
    var delegate: funcDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title="Select Gender"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMale(sender: AnyObject) {
        
        let textToReturn = (sender as! UIButton).titleLabel?.text
       // delegate!.chooseSex("Male")
        delegate!.chooseSex(textToReturn!)
        self.dismissViewControllerAnimated(false, completion: nil);
        
    }
    
    @IBAction func btnFemale(sender: AnyObject) {
        
        delegate!.chooseSex("Female")
        self.dismissViewControllerAnimated(false, completion: nil);
        
        
    }
    
    @IBAction func btnDontShare(sender: AnyObject) {
        
        delegate!.chooseSex("Don't Share")
        self.dismissViewControllerAnimated(false, completion: nil);
        
        
    }
    
    
}
