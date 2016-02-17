//
//  LoverListTableViewCell.swift
//  Pixapals
//
//  Created by ak2g on 2/11/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Spring

protocol loverListTableViewCellDelegate {
    func getFeedClicked(sender: UIButton, user: UserJSON)
    func usernameClicked(id: Int?)
}

class LoverListTableViewCell: UITableViewCell {
    
    var delegate: loverListTableViewCellDelegate!
    var user: UserJSON!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var getFeedButton: DesignableButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        getFeedButton.setTitle("Feeding", forState: UIControlState.Disabled)
        profileImageView.userInteractionEnabled = true
        username.userInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("labelPressed"))
        profileImageView.addGestureRecognizer(gestureRecognizer)
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: Selector("labelPressed"))
        
        username.addGestureRecognizer(gestureRecognizer2)
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func getFeedButtonAction(sender: AnyObject) {
        delegate.getFeedClicked(getFeedButton, user: user)
    }
    
    func labelPressed(){
        delegate.usernameClicked(user.id)
    }
}
