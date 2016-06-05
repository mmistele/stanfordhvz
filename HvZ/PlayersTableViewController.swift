//
//  PlayersTableViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import CoreData

class PlayersTableViewController: CoreDataTableViewController, UISearchBarDelegate {
    
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
                    request.predicate = NSPredicate(format: "firstName contains[c] %@ AND lastname contains[c] %@", firstNameSearch, lastNameSearch)
                }
            } else {
                // Fetch all players
                request.predicate = nil
            }
            request.sortDescriptors = [
                NSSortDescriptor(
                    key: "team",
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
                sectionNameKeyPath: "team",
                cacheName: nil)
        }
    }
    
    // Revisit this for heights
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
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
        
        if let player = fetchedResultsController?.objectAtIndexPath(indexPath) as? Player {
            var team: Team?
            var firstName: String?
            var lastName: String?
            var clan: Clan?
            var tagCount: NSNumber?
            var image: NSData?
            
            player.managedObjectContext?.performBlockAndWait {
                team = player.team as? Team
                firstName = player.firstName
                lastName = player.lastName
                clan = player.clan as? Clan
                tagCount = player.tagCount
                image = player.image
            }
            
            if let playerCell = cell as? PlayerTableViewCell {
                
                if lastName == nil {
                    playerCell.nameLabel?.text = firstName!
                } else {
                    playerCell.nameLabel?.text = firstName! + " " + lastName!
                }
                
                if clan != nil {
                    playerCell.clanLabel?.text = "Clan: \(clan!.name)"
                } else {
                    playerCell.clanLabel?.text = "Of No Clan"
                }
                
                if let imageData = image {
                    playerCell.imageView?.image = UIImage(data: imageData)
                }
                
                if team?.name == "Human" {
                    playerCell.tagLabel = nil
                } else {
                    playerCell.tagLabel?.text = "Tags: \(tagCount!)"
                }
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
