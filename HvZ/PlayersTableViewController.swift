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
    
    // Revisit this for heights
    override func viewDidLoad() {
        super.viewDidLoad()
        DummyStore.preloadData(inManagedObjectContext: managedObjectContext!)
        updatePlayerSearch()
        tableView.estimatedRowHeight = 50 // tableView.rowHeight
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
            var teamName: String?
            var firstName: String?
            var lastName: String?
            var clan: Clan?
            var tagCount: NSNumber?
            var image: NSData?
            var badgeTitles: NSArray?
            
            player.managedObjectContext?.performBlockAndWait {
                teamName = player.teamName
                firstName = player.firstName
                lastName = player.lastName
                clan = player.clan
                tagCount = player.tagCount
                image = player.image
                badgeTitles = player.badges as? NSArray
            }
            
            if let playerCell = cell as? PlayerTableViewCell {
                
                if let imageData = image {
                    playerCell.imageView?.image = UIImage(data: imageData)
                }
                
                if lastName == nil {
                    playerCell.nameLabel?.text = firstName!
                } else {
                    playerCell.nameLabel?.text = firstName! + " " + lastName!
                }
                
                if teamName! == Team.HumanTeamName {
                    if clan != nil {
                        playerCell.clanLabel?.text = "Clan: \(clan!.name!)"
                    } else {
                        playerCell.clanLabel?.text = "Of No Clan"
                    }
                } else {
                    playerCell.clanLabel?.removeFromSuperview()
                    
                }
                
                if teamName! == Team.ZombieTeamName {
                    playerCell.tagLabel?.text = "Tags: \(tagCount!)"
                } else {
                    playerCell.tagLabel?.removeFromSuperview()
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
                    playerCell.badges = badgesArray
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
