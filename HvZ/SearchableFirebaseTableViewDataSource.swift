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

class SearchableFirebaseTableViewDataSource: NSObject, UITableViewDataSource, FirebaseArrayDelegate {
    var unfilteredArray: FirebaseArray!
    var filteredArray: [FIRDataSnapshot]! {
        didSet {
            tableView.reloadData()
        }
    }
    var indexMappingArray: [Int?]! // kept as large as unfilteredArray, with each value being the index in filteredArray that it shows up (or nil if doesn't appear)
    
    var searchText: String? {
        didSet {
            var newFilteredArray: [FIRDataSnapshot] = []
            // Re-run filter
            for uintIdx in 0 ..< unfilteredArray.count() {
                let snapshot = unfilteredArray.objectAtIndex(uintIdx) as! FIRDataSnapshot
                let i = Int(uintIdx)
                let childDict = snapshot.value as! [String : AnyObject]
                
                // Refactor this - DRY violated
                if searchText == nil || searchText == "" {
                    indexMappingArray[i] = newFilteredArray.count
                    newFilteredArray.append(snapshot)
                }
                else if let searchedValue = childDict[childKey] as? String {
                    if searchedValue.containsStringCaseInsensitive(searchText!) {
                        indexMappingArray[i] = newFilteredArray.count
                        newFilteredArray.append(snapshot)
                    } else {
                        indexMappingArray[i] = nil
                    }
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
    
    init(query: FIRDatabaseQuery, prototypeReuseIdentifier: String, tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        tableView.dataSource = self
        
        unfilteredArray = FirebaseArray(query: query)
        unfilteredArray.delegate = self
        filteredArray = [FIRDataSnapshot]()
        indexMappingArray = [Int?]()
        
        self.prototypeReuseIdentifier = prototypeReuseIdentifier
        
    }
    
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
    
    
    // MARK: FirebaseArrayDelegate Methods
    
    // Refactor the heck out of the below
    
    func childAdded(object: AnyObject!, atIndex index: UInt) {
        // This isn't generic enough, but it works for the current use case. Maybe ask for a callback to run here?
        let snapshot = object as! FIRDataSnapshot
        let childDict = snapshot.value as! [String : AnyObject]
        
        let firebaseChildIndex = Int(index)
        
        if searchText == nil {
            // then filteredIndex should just be the unfiltered one
            indexMappingArray.insert(firebaseChildIndex, atIndex: firebaseChildIndex)
            filteredArray.insert(snapshot, atIndex: firebaseChildIndex)
        }
        else if let searchedValue = childDict[childKey] as? String {
            if searchedValue.containsStringCaseInsensitive(searchText!) {
                var inserted = false
                for unfilteredIndex in (firebaseChildIndex-1).stride(through: 0, by: -1) {
                    // Find the index in unfilteredArray of the snapshot that'll be right before this one in filteredArray
                    if let prevFilteredIndex = indexMappingArray[unfilteredIndex] {
                        indexMappingArray.insert(unfilteredIndex+1, atIndex: firebaseChildIndex)
                        filteredArray.insert(snapshot, atIndex: prevFilteredIndex+1)
                        inserted = true
                        break
                    }
                }
                if !inserted {
                    // Then there was no snapshot in filteredArray before this one - just add it to the beginning of the filteredArray
                    indexMappingArray.insert(0, atIndex: firebaseChildIndex)
                    filteredArray.insert(snapshot, atIndex: 0)
                }
                
            } else {
                // Fails the search query, don't add to filtered array!
                indexMappingArray.insert(nil, atIndex: firebaseChildIndex)
            }
        } else {
            // Doesn't even have the key? Then ostensibly also fails the search query - don't add to filtered array!
            indexMappingArray.insert(nil, atIndex: firebaseChildIndex)
        }
        
    }
    func childChanged(object: AnyObject!, atIndex index: UInt) {
        let snapshot = object as! FIRDataSnapshot
        let firebaseChildIndex = Int(index)
        if let indexInFilteredArray = indexMappingArray[firebaseChildIndex] {
            filteredArray[indexInFilteredArray] = snapshot
        }
    }
    
    func childRemoved(object: AnyObject!, atIndex index: UInt) {
        let firebaseChildIndex = Int(index)
        if let indexInFilteredArray = indexMappingArray[firebaseChildIndex] {
            filteredArray.removeAtIndex(indexInFilteredArray)
            indexMappingArray.removeAtIndex(firebaseChildIndex)
        }
    }
    
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

extension String {
    func containsStringCaseInsensitive(str: String) -> Bool {
        return self.lowercaseString.containsString(str.lowercaseString)
    }
}
