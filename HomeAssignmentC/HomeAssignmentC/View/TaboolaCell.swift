//
//  TaboolaCell.swift
//  HomeAssignmentC
//
//  Created by Alon Harari on 22/04/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//

import UIKit
import TaboolaFramework

class TaboolaCell: UICollectionViewCell {
    
    
    @IBOutlet weak var taboolaView: TaboolaView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
    }
}
