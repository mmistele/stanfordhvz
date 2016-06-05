//
//  BadgeCollectionViewCell.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

class BadgeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var badge: Badge? {
        didSet {
            imageView.image = badge?.image
        }
    }
    
}

class FancierBadgeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var badge: Badge? {
        didSet {
            imageView.image = badge?.image
        }
    }
}
