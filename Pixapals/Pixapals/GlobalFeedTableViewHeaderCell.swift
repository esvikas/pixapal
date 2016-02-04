//
//  GlobalFeedTableViewHeaderCell.swift
//  Pixapals
//
//  Created by DARI on 1/21/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class GlobalFeedTableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var userProfilePic: UIImageView!

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timeElapsed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
