//
//  PreloadingData.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import Foundation
import CoreData
import CoreImage
import UIKit

class DummyStore {
    static func preloadData(inManagedObjectContext context: NSManagedObjectContext) {
        
        let mod1 = addPlayer(inContext: context,
                  firstName: "Mike",
                  lastName: "Moderator",
                  cellNumber: "3059159192",
                  password: "password",
                  imageData: SampleProfileImages![0],
                  isModerator: true,
                  latitude: 37.423987,
                  longitude: -122.170908)
    }
    
    static func addPlayer(
        inContext context: NSManagedObjectContext,
                  firstName: String,
                  lastName: String,
                  cellNumber: String?,
                  password: String,
                  imageData: NSData?,
                  isModerator: Bool,
                  latitude: Double,
                  longitude: Double) -> Player? {
        
        if let player = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: context) as? Player {
            player.firstName = firstName
            player.lastName = lastName
            player.cellNumber = cellNumber
            player.password = password
            player.image = imageData
            player.isModerator = isModerator
            player.latitude = latitude
            player.longitude = longitude
            return player
        }
        return nil
    }
    
    static var SampleProfileImages: [NSData]? {
        get {
            return sliceImageIntoPNGs(
                named: AssetFilenames.ProfileIcons,
                rows: 4, columns: 4)
        }
    }
    
    private struct AssetFilenames {
        static let ProfileIcons = "zombieIcons.jpg"
    }
    
    // Uses CoreImage to slice up an image from disk and return an array of PNG data
    static func sliceImageIntoPNGs(named name: String, rows: Int, columns: Int) -> [NSData]? {
        if let uiImage = UIImage(named: name) {
            if let image = uiImage.CIImage {
                let sliceWidth = image.extent.width / CGFloat(rows)
                let sliceHeight = image.extent.height / CGFloat(rows)
                
                var slices = [NSData]()
                
                for r in 0...rows {
                    for c in 0...columns {
                        let sliceRect = CGRect(
                            x: CGFloat(c) * sliceWidth,
                            y: CGFloat(r) * sliceHeight,
                            width: sliceWidth,
                            height: sliceHeight)
                        let sliceImage = image.imageByCroppingToRect(sliceRect)
                        let sliceUIImage = UIImage(CIImage: sliceImage)
                        if let sliceData = UIImagePNGRepresentation(sliceUIImage) {
                            slices.append(sliceData)
                        }
                    }
                }
            }
            
        }
        return nil
    }
}