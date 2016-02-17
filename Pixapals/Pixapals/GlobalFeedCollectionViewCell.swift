//
//  GlobalFeedCollectionViewCell.swift
//  Pixapals
//
//  Created by DARI on 1/18/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import Spring

class GlobalFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet var loadingView: SpringView!
    
    
    override func awakeFromNib() {
        
        
        loadingView.showLoading()
    }
}
