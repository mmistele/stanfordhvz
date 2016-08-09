//
//  SearchableFirebaseTableViewDataSource.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/6/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabaseUI
import UIKit

class FilteredFirebaseTableViewDataSource: NSObject, UITableViewDataSource, FirebaseArrayDelegate {
    var unfilteredArray: FirebaseArray!
    var filteredArray: [FIRDataSnapshot]! {
        didSet {
            tableView.reloadData()
        }
    }
    var indexMappingArray: [Int?]! // kept as large as unfilteredArray, with each value being the index in filteredArray that it shows up (or nil if doesn't appear)
    
    var delegate: FilteredFirebaseTableViewDataSourceDelegate!
    
    // Or just delegate this function! Probably better.
    var filter: ((FIRDataSnapshot, withSearch: String?) -> Bool) = { (snapshot, search) in
        let childDict = snapshot.value as! [String : AnyObject]
        if search == nil || search == "" {
            return true
        }
        else if let searchedValue = childDict["firstName"] as? String {
            if searchedValue.containsStringCaseInsensitive(search!) {
                return true
            }
        }
        return false
        } {
        didSet {
            var newFilteredArray: [FIRDataSnapshot] = []
            // Re-run filter
            for uintIdx in 0 ..< unfilteredArray.count() {
                let snapshot = unfilteredArray.objectAtIndex(uintIdx) as! FIRDataSnapshot
                let i = Int(uintIdx)
                
                if filter(snapshot, withSearch: searchText) {
                    indexMappingArray[i] = newFilteredArray.count
                    newFilteredArray.append(snapshot)
                }
                else {
                    indexMappingArray[i] = nil
                }
            }
            filteredArray = newFilteredArray
        }
    }
    
    var searchText: String? {
        didSet {
            var newFilteredArray: [FIRDataSnapshot] = []
            // Re-run filter
            for uintIdx in 0 ..< unfilteredArray.count() {
                let snapshot = unfilteredArray.objectAtIndex(uintIdx) as! FIRDataSnapshot
                let i = Int(uintIdx)
                
                if filter(snapshot, withSearch: searchText) {
                    indexMappingArray[i] = newFilteredArray.count
                    newFilteredArray.append(snapshot)
                }
                else {
                    indexMappingArray[i] = nil
                }
            }
            filteredArray = newFilteredArray
        }
    }
    var childKey: String = "firstName" {
        didSet {
            // Uh... can this be changed?
        }
    }
    var populateCellBlock: ((UITableViewCell, FIRDataSnapshot) -> Void)!
    var prototypeReuseIdentifier: String!
    var tableView: UITableView!
    
    init(query: FIRDatabaseQuery, prototypeReuseIdentifier: String, tableView: UITableView, delegate: FilteredFirebaseTableViewDataSourceDelegate) {
        super.init()
        
        self.tableView = tableView
        tableView.dataSource = self
        self.delegate = delegate
        
        unfilteredArray = FirebaseArray(query: query)
        unfilteredArray.delegate = self
        filteredArray = [FIRDataSnapshot]()
        indexMappingArray = [Int?]()
        
        self.prototypeReuseIdentifier = prototypeReuseIdentifier
        
    }
    
    // MARK: TableViewDataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(prototypeReuseIdentifier, forIndexPath: indexPath)
        
        let snapshot = filteredArray[indexPath.row]
        
        populateCellBlock(cell, snapshot)
        
        return cell
        
    }
    
    // MARK: Helper Functions
    
    /*
     * Inserts the snapshot into the filtered array in a place that preserves the order in unfilteredArray.
     * Keeps the filtered array synced with the index mapping array to facilitate filter maintenance in CRUD operations.
     */
    private func addToFilteredArray(snapshot: FIRDataSnapshot, withFirebaseIndex firebaseIndex: Int) {
        var inserted = false
        for unfilteredIndex in (firebaseIndex-1).stride(through: 0, by: -1) {
            // Find the index in unfilteredArray of the snapshot that'll be right before this one in filteredArray
            if let prevFilteredIndex = indexMappingArray[unfilteredIndex] {
                indexMappingArray.insert(unfilteredIndex+1, atIndex: firebaseIndex)
                filteredArray.insert(snapshot, atIndex: prevFilteredIndex+1)
                inserted = true
                break
            }
        }
        if !inserted {
            // Then there was no snapshot in filteredArray before this one - just add it to the beginning of the filteredArray
            indexMappingArray.insert(0, atIndex: firebaseIndex)
            filteredArray.insert(snapshot, atIndex: 0)
        }
        
    }
    
    private func removeFromFilteredArray(snapshot: FIRDataSnapshot, withFirebaseIndex firebaseIndex: Int) {
        filteredArray.removeAtIndex(firebaseIndex)
        
        let unfilteredCount = Int(unfilteredArray.count())
        for unfilteredIndex in (firebaseIndex).stride(through: unfilteredCount, by: 1) {
            if indexMappingArray[unfilteredIndex] != nil {
                indexMappingArray[unfilteredIndex]! -= 1
            }
        }
    }
    
    // MARK: FirebaseArrayDelegate Methods
    
    func childAdded(object: AnyObject!, atIndex index: UInt) {
        let snapshot = object as! FIRDataSnapshot
        let firebaseIndex = Int(index)
        
        if filter(snapshot, withSearch: searchText) {
            addToFilteredArray(snapshot, withFirebaseIndex: firebaseIndex)
        } else {
            // Fails the search query, don't add to filtered array!
            indexMappingArray.insert(nil, atIndex: firebaseIndex)
        }
        
    }
    
    func childChanged(object: AnyObject!, atIndex index: UInt) {
        let snapshot = object as! FIRDataSnapshot
        let firebaseIndex = Int(index)
        
        if filter(snapshot, withSearch: searchText) {
            if let indexInFilteredArray = indexMappingArray[firebaseIndex] {
                // Simplest case: already in the filtered array, so it stays there, with an updated value
                filteredArray[indexInFilteredArray] = snapshot
            } else {
                // Not in the filtered list? Add it!
                addToFilteredArray(snapshot, withFirebaseIndex: firebaseIndex)
            }
        } else {
            if indexMappingArray[firebaseIndex] != nil {
                // It was in the filtered list, but now it shouldn't be
                removeFromFilteredArray(snapshot, withFirebaseIndex: firebaseIndex)
            }
            // If it's wasn't, we don't need to do anything!
        }
    }
    
    func childRemoved(object: AnyObject!, atIndex index: UInt) {
        let snapshot = object as! FIRDataSnapshot
        let firebaseIndex = Int(index)
        if filter(snapshot, withSearch: searchText) {
            removeFromFilteredArray(snapshot, withFirebaseIndex: firebaseIndex)
        }
        indexMappingArray.removeAtIndex(firebaseIndex)
    }
    
    // Below needs refactoring
    func childMoved(object: AnyObject!, fromIndex: UInt, toIndex: UInt) {
        let snapshot = object as! FIRDataSnapshot
        let fromFirebaseChildIndex = Int(fromIndex)
        let toFirebaseChildIndex = Int(toIndex)
        
        
        if let fromIndexInFilteredArray = indexMappingArray[fromFirebaseChildIndex] {
            // It fulfilled the search - so we need to reorder filteredArray too
            var insertToFilteredIndex = 0
            if toFirebaseChildIndex < fromFirebaseChildIndex {
                // Moving it to later
                for unfilteredIndex in (fromFirebaseChildIndex+1).stride(through: toFirebaseChildIndex, by: 1) {
                    indexMappingArray[unfilteredIndex] = indexMappingArray[unfilteredIndex+1]
                    if indexMappingArray[unfilteredIndex] != nil {
                        insertToFilteredIndex = indexMappingArray[unfilteredIndex]!
                        indexMappingArray[unfilteredIndex]! -= 1
                    }
                }
            } else {
                for unfilteredIndex in (fromFirebaseChildIndex).stride(to: toFirebaseChildIndex, by: -1) {
                    indexMappingArray[unfilteredIndex] = indexMappingArray[unfilteredIndex-1]
                    if indexMappingArray[unfilteredIndex] != nil {
                        insertToFilteredIndex = indexMappingArray[unfilteredIndex]!
                        indexMappingArray[unfilteredIndex]! += 1
                    }
                }
            }
            
            indexMappingArray[toFirebaseChildIndex] = insertToFilteredIndex
            filteredArray.removeAtIndex(fromIndexInFilteredArray)
            filteredArray.insert(snapshot, atIndex: insertToFilteredIndex)
            
        } else {
            indexMappingArray.removeAtIndex(fromFirebaseChildIndex)
            indexMappingArray.insert(nil, atIndex: toFirebaseChildIndex)
        }
    }
    
}

protocol FilteredFirebaseTableViewDataSourceDelegate {
    func includeSnapshot(snapshot: FIRDataSnapshot) -> Bool
}

extension String {
    func containsStringCaseInsensitive(str: String) -> Bool {
        return self.lowercaseString.containsString(str.lowercaseString)
    }
}
