//
//  MessageTableViewCell.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // drawRect for chat bubble from https://gist.github.com/Katafalkas/eb5e840df1ace981c359
    // with byRoundingCorners fix from http://stackoverflow.com/questions/31919867/using-uibezierpathbyroundingcorners-with-swift-2-0
    
    override func drawRect(rect: CGRect) {
        var bubbleSpace = CGRectMake(20.0, self.bounds.origin.y, self.bounds.width - 20, self.bounds.height)
        
        let bubblePath1 = UIBezierPath(roundedRect: bubbleSpace, byRoundingCorners: [.TopLeft, .TopRight, .BottomRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        
        let bubblePath = UIBezierPath(roundedRect: bubbleSpace, cornerRadius: 20.0)
        
        UIColor.greenColor().setStroke()
        UIColor.greenColor().setFill()
        bubblePath.stroke()
        bubblePath.fill()
        
        var triangleSpace = CGRectMake(0.0, self.bounds.height - 20, 20, 20.0)
        let trianglePath = UIBezierPath()
        let startPoint = CGPoint(x: 20.0, y: self.bounds.height - 40)
        let tipPoint = CGPoint(x: 0.0, y: self.bounds.height - 30)
        let endPoint = CGPoint(x: 20.0, y: self.bounds.height - 20)
        trianglePath.moveToPoint(startPoint)
        trianglePath.addLineToPoint(tipPoint)
        trianglePath.addLineToPoint(endPoint)
        trianglePath.closePath()
        UIColor.greenColor().setStroke()
        UIColor.greenColor().setFill()
        trianglePath.stroke()
        trianglePath.fill()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Comments again from Katafalkas - but what could they mean?
        //        var backgroundImage = UIImageView(image: UIImage(named: "star"))
        //        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFit
        //        self.backgroundView = backgroundImage
    }

}
