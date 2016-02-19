//
//  NotificationTableViewCell.swift
//  Pixapals
//
//  Created by DARI on 2/19/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var item2Button: UIButton!
    var userId: Int!
    var item2Id: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userButton.layer.cornerRadius = userButton.frame.height / 2
        userButton.clipsToBounds = true
        item2Button.layer.cornerRadius = item2Button.frame.height / 2
        item2Button.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func item2ButtonPressed(sender: AnyObject) {
        
    }

    @IBAction func userButtonPressed(sender: AnyObject) {
        
    }
}
