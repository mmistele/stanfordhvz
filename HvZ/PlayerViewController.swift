//
//  PlayerViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/5/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import CoreGraphics

class PlayerViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var player: Player? {
        didSet {
            if player != nil {
                var badgeTitles: NSArray?
                player!.managedObjectContext?.performBlockAndWait {
                    badgeTitles = self.player!.badges as? NSArray
                }
                
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
    
    var badges = [Badge]()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let pickerController = UIImagePickerController()
    
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButtonTapped(sender: UIButton) {
        let actionSheet = UIAlertController(
            title: "Upload Profile Pic",
            message: "Get a profile picture from your device",
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        actionSheet.addAction(UIAlertAction(
            title: "Take Picture",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                self.pickerController.sourceType = .Camera
                self.pickerController.allowsEditing = true
                // All cameras can take stills, and still-only is the default of .mediaTypes
                self.presentViewController(self.pickerController, animated: true, completion: nil)
            }
            })
        
        actionSheet.addAction(UIAlertAction(
            title: "Choose Existing",
            style: .Default)
        { (action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                self.pickerController.sourceType = .PhotoLibrary
                self.pickerController.allowsEditing = true
                // Still-only is still the default of .mediaTypes
                self.presentViewController(self.pickerController, animated: true, completion: nil)
            }
            })
        
        actionSheet.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel)
        { (action: UIAlertAction) -> Void in
            // do nothing
            }
        )
        
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        player?.image = UIImagePNGRepresentation(image)
        profileImageView.image = image
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var clanLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    var embeddedBadgesController: BadgeCollectionViewController?
    
    var badgeObserver: NSObjectProtocol?
    @IBOutlet weak var selectedBadgeTitleLabel: UILabel!
    @IBOutlet weak var selectedBadgeDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 0
        
        pickerController.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        let center = NSNotificationCenter.defaultCenter()
        badgeObserver = center.addObserverForName(BadgeNotificationConstants.BadgeSelectedNotification, object: embeddedBadgesController, queue: NSOperationQueue.mainQueue()) {
            notification in
            if let badgeTitle = notification.userInfo?[BadgeNotificationConstants.BadgeTitleKey] as? String {
                self.selectedBadgeTitleLabel.text = badgeTitle
            }
            if let badgeDescription = notification.userInfo?[BadgeNotificationConstants.BadgeDescriptionKey] as? String {
                self.selectedBadgeDescriptionLabel.text = badgeDescription
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if badgeObserver != nil {
            let center = NSNotificationCenter.defaultCenter()
            center.removeObserver(badgeObserver!)
        }
    }
    
    private func updateUI() {
        if let playerObject = player {
            var teamName: String?
            var firstName: String?
            var lastName: String?
            var clan: Clan?
            var tagCount: NSNumber?
            var image: NSData?
            var unique: String?
            
            // Only being called once, not kept as a property, so retain cycle not an issue
            playerObject.managedObjectContext?.performBlockAndWait {
                teamName = playerObject.teamName
                firstName = playerObject.firstName
                lastName = playerObject.lastName
                clan = playerObject.clan
                tagCount = playerObject.tagCount
                image = playerObject.image
                unique = playerObject.unique
            }
            
            if let imageData = image {
                profileImageView.image = UIImage(data: imageData)
            }
            
            if lastName == nil {
                nameLabel.text = firstName!
            } else {
                nameLabel.text = firstName! + " " + lastName!
            }
            
            teamLabel.text = "Team: \(teamName!)"
            
            if clan != nil {
                clanLabel.text = "Clan: \(clan!.name!)"
            } else {
                clanLabel.text = "Clan: None"
            }
            tagsLabel.text = "\(tagCount!) Tags"
            
            editButton.hidden = true
            
            var currentUserUnique: String?
            if let currentUser = (UIApplication.sharedApplication().delegate as? AppDelegate)?.currentUser {
                currentUser.managedObjectContext?.performBlockAndWait({
                    currentUserUnique = currentUser.unique
                })
                if currentUserUnique == unique {
                    editButton.hidden = false
                }
            }
        }
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 2
        }
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    private struct Storyboard {
        static let BadgesEmbedSegueIdentifier = "Embed Badges"
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.BadgesEmbedSegueIdentifier:
                if let bcvc = segue.destinationViewController.contentViewController as? BadgeCollectionViewController {
                    bcvc.badges = badges
                    embeddedBadgesController = bcvc
                }
            default: break
            }
            
        }
    }
    
}

