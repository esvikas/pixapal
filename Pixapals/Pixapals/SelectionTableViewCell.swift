//
//  SelectionTableViewCell.swift
//  Pixapals
//
//  Created by DARI on 3/2/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.layer.cornerRadius = 5
        lblTitle.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
