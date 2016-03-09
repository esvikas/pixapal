//
//  GetFeedTableViewCell.swift
//  Pixapals
//
//  Created by ak2g on 3/2/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class GetFeedTableViewCell: UITableViewCell {

    @IBOutlet var btnGetFeed: UIButton!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    userImageView.layer.cornerRadius=userImageView.frame.height/2
        userImageView.clipsToBounds=true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
