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

class FirebaseTableViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UIPopoverPresentationControllerDelegate, FilteredFirebaseTableViewDataSourceDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: FilteredFirebaseTableViewDataSource?
    var ref: FIRDatabaseReference!
    
    // Search every time you enter a letter
    var search: String? { didSet { dataSource?.filterUpdated() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        tableView.delegate = self
    }
    
    func getQuery() -> FIRDatabaseQuery {
        return self.ref
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
    // MARK: FilteredFirebaseTableViewDataSourceDelegate
    
    func includeSnapshot(snapshot: FIRDataSnapshot) -> Bool {
        return true
    }
    
}