//
//  AmazonCell.swift
//  TaboolaHomeAssignment
//
//  Created by Alon Harari on 20/04/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//


import UIKit

class AmazonCell: UICollectionViewCell {
    
    @IBOutlet weak var thumnailImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth
        descriptionLabel.backgroundColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        descriptionLabel.sizeToFit()
        nameLabel.backgroundColor = UIColor.white
        nameLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.lineBreakMode = .byWordWrapping
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    
}
