//
//  ZombieTableViewCell.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

class PlayersTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var player: Player? {
        didSet {
            if player != nil {
                var teamName: String?
                var firstName: String?
                var lastName: String?
                var clan: Clan?
                var tagCount: NSNumber?
                var image: NSData?
                var badgeTitles: NSArray?
                
                // Only being called once, not kept as a property, so retain cycle not an issue
                player!.managedObjectContext?.performBlockAndWait {
                    teamName = self.player!.teamName
                    firstName = self.player!.firstName
                    lastName = self.player!.lastName
                    clan = self.player!.clan
                    tagCount = self.player!.tagCount
                    image = self.player!.image
                    badgeTitles = self.player!.badges as? NSArray
                }
                
                if let imageData = image {
                    profileImg?.image = UIImage(data: imageData)
                }
                
                if lastName == nil {
                    nameLabel?.text = firstName!
                } else {
                    nameLabel?.text = firstName! + " " + lastName!
                }
                
                if clan != nil {
                    clanLabel?.text = "Clan: \(clan!.name!)"
                } else {
                    clanLabel?.text = "Of No Clan"
                }
                tagLabel?.text = "Tags: \(tagCount!)"
                
                if teamName! == Team.HumanTeamName {
                    clanLabel?.hidden = false
                } else {
                    clanLabel?.hidden = true
                }
                
                if teamName! == Team.ZombieTeamName {
                    tagLabel?.hidden = false
                } else {
                    tagLabel?.hidden = true
                }
                
                // Filling Badge[] from the Core Data NSArray
                if badgeTitles != nil {
                    var badgesArray = [Badge]()
                    for item in badgeTitles! {
                        if let title = item as? String {
                            if let badge = Badge.badges[title] {
                                badgesArray.append(badge)
                            }
                        }
                    }
                    badges = badgesArray
                }
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
