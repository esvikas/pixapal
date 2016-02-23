//
//  NotificationTableViewCell.swift
//  Pixapals
//
//  Created by DARI on 2/19/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
protocol NotificationTableViewCellDelegate {
    func item2ImageTapped(indexPath: NSIndexPath);
    func userInfoTapped(indexPath: NSIndexPath);
}

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var item2Button: UIButton!
    
    var indexPath: NSIndexPath!
    var delegate: NotificationTableViewCellDelegate!
    
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
        delegate.item2ImageTapped(self.indexPath)
    }

    @IBAction func userButtonPressed(sender: AnyObject) {
        delegate.userInfoTapped(self.indexPath)
    }
}
