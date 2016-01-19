//
//  GlobalFeedTableViewCell.swift
//  Pixapals
//
//  Created by DARI on 1/18/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class GlobalFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timeElapsed: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var loveIcon: UIImageView!
    @IBOutlet weak var leftCount: UILabel!
    @IBOutlet weak var loveCount: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
