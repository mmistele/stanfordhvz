//
//  PlayersTableViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabaseUI

class PlayersTableViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UIPopoverPresentationControllerDelegate, FilteredFirebaseTableViewDataSourceDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: FilteredFirebaseTableViewDataSource?
    var ref: FIRDatabaseReference!
    
    // Search every time you enter a letter
    var search: String? { didSet { dataSource?.filterUpdated() } }
    
    private struct Storyboard {
        static let PlayerCellIdentifier = "Player"
        static let BadgePopoverSegueIdentifier = "Badge Popover"
        static let PlayerSegueIdentifier = "Player Segue"
        static let RowHeight = CGFloat(80)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        dataSource = FilteredFirebaseTableViewDataSource(query: getQuery(), sectionNameKey: "team", prototypeReuseIdentifier: Storyboard.PlayerCellIdentifier, tableView: tableView, delegate: self, populateCellBlock: { (cell, snapshot) in
            if let playerCell = cell as? PlayersTableViewCell {
                let uid = snapshot.key
                let playerDict = snapshot.value as! [String : AnyObject]
                let player = Player.init(uid: uid, dict: playerDict)
                playerCell.player = player
                
            } else {
                cell.textLabel?.text = snapshot.key
            }
        })
        
        tableView.delegate = self
        
        tableView.estimatedRowHeight = Storyboard.RowHeight //tableView.rowHeight
        tableView.rowHeight = Storyboard.RowHeight // UITableViewAutomaticDimension
        
        dataSource?.filterUpdated()
    }
    
    func getQuery() -> FIRDatabaseQuery {
        return self.ref.child("users").queryOrderedByChild("firstName")
    }
    
    
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.text = search
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search = searchText
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        // searchBar.becomeFirstResponder()
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        search = searchBar.text
        return true
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.PlayerSegueIdentifier:
                if let vc = segue.destinationViewController.contentViewController as? PlayerViewController {
                    if let playerCell = sender as? PlayersTableViewCell {
                        if let player = playerCell.player {
                            vc.player = player
                        }
                    }
                }
                
                /*
                 // For future use
                 case Storyboard.BadgePopoverSegueIdentifier:
                 if let vc = segue.destinationViewController.contentViewController as? BadgePopoverViewController {
                 
                 // Populate popover
                 if let badgeCell = sender as? BadgeCollectionViewCell {
                 if let badge = badgeCell.badge {
                 vc.titleLabel.text = badge.title
                 vc.descriptionLabel.text = badge.description
                 }
                 }
                 
                 if let ppc = vc.popoverPresentationController {
                 
                 // Only upward popovers
                 ppc.permittedArrowDirections = UIPopoverArrowDirection.Down
                 
                 // Want to be able to control the popover
                 ppc.delegate = self
                 }
                 }
                 */
            default: break
            }
        }
    }
    
    // MARK: FilteredFirebaseTableViewDataSourceDelegate
    
    func includeSnapshot(snapshot: FIRDataSnapshot) -> Bool {
        let childDict = snapshot.value as! [String : AnyObject]
        if search == nil || search == "" {
            return true
        }
        else if let firstName = childDict["firstName"] as? String, lastName = childDict["lastName"] as? String {
            let splitNames = search?.characters.split{$0 == " "}.map(String.init)
            if let nameArray = splitNames where nameArray.count > 0 {
                // Handles multi-word last names, but only single-word first names
                let firstNameSearch = nameArray.first!
                let lastNameSearch = nameArray.suffix(nameArray.count-1).joinWithSeparator(" ")
                
                if (firstName.containsStringCaseInsensitive(firstNameSearch) || lastName.containsStringCaseInsensitive(lastNameSearch)) || lastName.containsStringCaseInsensitive(firstNameSearch) {
                    return true
                }
            }
        }
        return false
    }
    
}
