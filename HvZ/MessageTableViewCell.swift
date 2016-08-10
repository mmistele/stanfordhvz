//
//  MessageTableViewCell.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    var messageId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // If we want chat bubbles, check out https://gist.github.com/Katafalkas/eb5e840df1ace981c359
    // with byRoundingCorners fix from http://stackoverflow.com/questions/31919867/using-uibezierpathbyroundingcorners-with-swift-2-0
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
