//
//  PostFeedViewController.swift
//  Pixapals
//
//  Created by DARI on 1/13/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class PostFeedViewController: UIViewController {

    @IBOutlet weak var singleModeImageView: UIImageView!
    @IBOutlet weak var doubleModeStackView: UIStackView!
    @IBOutlet weak var doubleModeSwipeImageInstructionLabel: UILabel!
    
    
    var image2: UIImage!
    var image1: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.image2 != nil {
            doubleModeStackView.hidden = true
            doubleModeSwipeImageInstructionLabel.hidden = true
            singleModeImageView.hidden = false
        } else {
            singleModeImageView.hidden = true
            doubleModeStackView.hidden = false
            doubleModeSwipeImageInstructionLabel.hidden = false
        }
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
