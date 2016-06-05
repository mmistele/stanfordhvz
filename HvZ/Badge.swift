//
//  Badges.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import Foundation
import UIKit

struct Badge {
    
    var title: String
    var description: String
    var image: UIImage?
    var test: (Player) -> Bool
    
    static var badges: Dictionary<String, Badge> = [
        "OZ" : Badge(
            title: "OZ",
            description: "Original Zombie",
            image: UIImage(named: "oz.jpg")) { (player) -> Bool in
                <#code#>
            }
    ]
    
}
