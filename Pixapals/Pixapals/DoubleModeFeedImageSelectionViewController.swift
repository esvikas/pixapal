//
//  DoubleModeFeedImageSelectionViewController.swift
//  Pixapals
//
//  Created by DARI on 1/15/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class DoubleModeFeedImageSelectionViewController: UIViewController {
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var verticalSeparatorView: UIView!
    @IBOutlet weak var horizontalSeparatorView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    var stateVertical: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrangeViews(false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeStatePressed(sender: AnyObject) {
        self.stateVertical = !self.stateVertical
        arrangeViews(self.stateVertical)
    }
    
    private func arrangeViews(stateVertical: Bool){
        if stateVertical {
            self.verticalSeparatorView.hidden = true
            self.horizontalSeparatorView.hidden = false
            self.stackView.axis = UILayoutConstraintAxis.Vertical
        } else {
            self.verticalSeparatorView.hidden = false
            self.horizontalSeparatorView.hidden = true
            self.stackView.axis = UILayoutConstraintAxis.Horizontal
        }
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
