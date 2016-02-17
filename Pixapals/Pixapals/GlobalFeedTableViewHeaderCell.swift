//
//  GlobalFeedTableViewHeaderCell.swift
//  Pixapals
//
//  Created by DARI on 1/21/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
protocol GlobalFeedTableViewHeaderCellDelegate {
    func SegueToProfile(id: Int?)
}

class GlobalFeedTableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var userProfilePic: UIImageView!

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timeElapsed: UILabel!
    
    var id: Int?
    
    var delegate: GlobalFeedTableViewHeaderCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfilePic.layer.cornerRadius=userProfilePic.frame.height/2
        userProfilePic.clipsToBounds=true
        
        username.userInteractionEnabled = true
        userProfilePic.userInteractionEnabled = true
    
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("labelPressed"))
        username.addGestureRecognizer(gestureRecognizer)
        
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: Selector("labelPressed"))
        userProfilePic.addGestureRecognizer(gestureRecognizer2)
        
    }
    
    func labelPressed(){
        delegate.SegueToProfile(id)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class InterestTableViewCell: UITableViewCell {
    @IBOutlet var tikButton: UIButton!
    @IBOutlet var InterestLael: UILabel!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            tikButton.setImage(UIImage(named: "tick_green"), forState: .Normal)
            tikButton.contentMode = UIViewContentMode.ScaleAspectFit
        }
        else {
              tikButton.setImage(UIImage(named: "tick"), forState: .Normal)
            
        }
        
    }
    
    //         override func setHighlighted(highlighted: Bool, animated: Bool) {
    //            super.setHighlighted(highlighted, animated: animated)
    //
    //            if(highlighted) {
    //                cellBackgroundView.backgroundColor = UIColor.greenColor()
    //            }
    //        }
    
    
    
}
