//
//  ZombieTableViewCell.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

class PlayersTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // This line kind of breaks MVC, but...
    var player: Player! {
        didSet {
            if let firstName = player.firstName, lastName = player.lastName {
                nameLabel.text = firstName + " " + lastName
            }
            tagLabel.text = "Tags: \(player.tagCount)"
            if let imageData = player.image {
                profileImg.image = UIImage(data: imageData)
            }
        }
    }
    
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
    
    var badges = [Badge]()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    
    
    private struct Storyboard {
        static let BadgeIdentifier = "BadgeCell"
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = badgeCollectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.BadgeIdentifier, forIndexPath: indexPath)
        if let badgeCell = cell as? BadgeCollectionViewCell {
            badgeCell.badge = badges[indexPath.row]
            return badgeCell
        }
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Translated from Objective-C in http://stackoverflow.com/questions/7399343/making-a-uiimage-to-a-circle-form
        profileImg.layer.cornerRadius = profileImg.frame.size.height / 2
        profileImg.layer.masksToBounds = true
        profileImg.layer.borderWidth = 0
    }
}
