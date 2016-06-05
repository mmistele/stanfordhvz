//
//  ZombieTableViewCell.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var clanLabel: UILabel!
    
    @IBOutlet weak var badgeCollectionView: UICollectionView! {
        didSet {
            badgeCollectionView.delegate = self
            badgeCollectionView.dataSource = self
        }
    }
    
    var badges = [Badge]() {
        didSet {
            updateBadgeCollection()
        }
    }
    
    private func updateBadgeCollection() {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    
    
    private struct Storyboard {
        static let BadgeIdentifier = "BadgeCell"
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = badgeCollectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.BadgeIdentifier, forIndexPath: indexPath)
        if let badgeCell = cell as? BadgeCollectionViewCell {
            badgeCell.imageView.image = badges[indexPath.row].image
        }
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
