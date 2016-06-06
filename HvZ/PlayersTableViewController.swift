//
//  PlayersTableViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import CoreData

class PlayersTableViewController: CoreDataTableViewController, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    // Can make it an array of arrays to have each be a fetch
    private var players = [Player]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // Search every time you enter a letter
    var search: String? { didSet { updatePlayerSearch() } }
    
    private struct Storyboard {
        static let PlayerCellIdentifier = "Player"
        static let BadgePopoverSegueIdentifier = "Badge Popover"
        static let PlayerSegueIdentifier = "Player Segue"
        static let RowHeight = CGFloat(80)
    }
    
    private func updatePlayerSearch() {
        if let context = managedObjectContext {
            let request = NSFetchRequest(entityName: "Player")
            
            if search?.characters.count > 0 {
                // After some trouble finding it in the documentation, just used http://stackoverflow.com/questions/25678373/swift-split-a-string-into-an-array
                let splitNames = search?.characters.split{$0 == " "}.map(String.init)
                if let nameArray = splitNames where nameArray.count > 0 {
                    // Handles multi-word last names, but only single-word first names
                    let firstNameSearch = nameArray.first!
                    let lastNameSearch = nameArray.suffix(nameArray.count-1).joinWithSeparator(" ")
                    request.predicate = NSPredicate(format: "(firstName contains[c] %@ OR lastName contains[c] %@) OR lastName contains[c] %@", firstNameSearch, lastNameSearch, firstNameSearch)
                }
            } else {
                // Fetch all players
                request.predicate = nil
            }
            request.sortDescriptors = [
                NSSortDescriptor(
                    key: "teamName",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                ),
                NSSortDescriptor(
                    key: "firstName",
                    ascending:  true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                ),
                NSSortDescriptor(
                    key: "lastName",
                    ascending:  true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )
            ]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "teamName",
                cacheName: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePlayerSearch()
        tableView.estimatedRowHeight = Storyboard.RowHeight //tableView.rowHeight
        tableView.rowHeight = Storyboard.RowHeight // UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    // Don't forget to set whether "clan" or "tags" based on section!
    // Precondition: all players have a first name
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.PlayerCellIdentifier, forIndexPath: indexPath)
        if let playerCell = cell as? PlayersTableViewCell {
            if let player = fetchedResultsController?.objectAtIndexPath(indexPath) as? Player {
                playerCell.player = player
                return playerCell
            }
        }
        return cell
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
    
}
