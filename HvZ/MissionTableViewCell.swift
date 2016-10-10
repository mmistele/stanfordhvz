//
//  MissionTableViewCell.swift
//  HvZ
//
//  Created by Matthew Mistele on 9/3/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

class MissionTableViewCell: UITableViewCell {

    private struct Storyboard {
        static let UnpublishedText = "Draft"
    }

    var mission: Mission! {
        didSet {
           textLabel?.text = mission.title
            if !mission.publishedToHumans && !mission.publishedToZombies {
                detailTextLabel?.text = Storyboard.UnpublishedText
            } else {
                detailTextLabel?.text = nil
            }
        }
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
