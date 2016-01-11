//
//  PostFeedModeSelectionViewController.swift
//  Pixapals
//
//  Created by DARI on 1/11/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class PostFeedModeSelectionViewController: UIViewController {

    @IBOutlet weak var singleModeButton: UIButton!
    @IBOutlet weak var doubleModeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        singleModeButton.layer.borderColor = UIColor(red:0.914, green:0.910, blue:0.922, alpha:1.00).CGColor
        singleModeButton.layer.borderWidth = 3
        doubleModeButton.layer.borderColor = UIColor(red:0.914, green:0.910, blue:0.922, alpha:1.00).CGColor
        doubleModeButton.layer.borderWidth = 3
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
