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
    
    private var unfilteredArray: FirebaseArray!
    
    /**
     * SortedDictionary mapping from the section name to the snapshots included by the filter in that section.
     * If sectionNameKey is nil, there should only be one section name, which we (for now) arbitrarily choose to be the empty string.
     */
    private var filteredSnapshots: TableDataModel<FIRDataSnapshot>!
    
    /**
     * Kept as large as unfilteredArray, with each value being the section name and index in filteredSnapshots
     * of the snapshot at that index in unfilteredArray (or nil if doesn't appear in filteredSnapshots).
     */
    private var snapshotIndexPaths: [(sectionName: String, filteredIndex: Int)?]!
    
    private var sectionNameKey: String?
    
    var delegate: FilteredFirebaseTableViewDataSourceDelegate!
    
    func filterUpdated() {
        let newFilteredSnapshots = TableDataModel<FIRDataSnapshot>()
        // Re-run filter
        for uintIdx in 0 ..< unfilteredArray.count() {
            let snapshot = unfilteredArray.objectAtIndex(uintIdx) as! FIRDataSnapshot
            let i = Int(uintIdx)
            
            if delegate.includeSnapshot(snapshot) {
                let sectionName = sectionNameForSnapshot(snapshot)
                snapshotIndexPaths[i] = (sectionName, newFilteredSnapshots.countInSection(sectionName))
                newFilteredSnapshots.append(snapshot, toSectionNamed: sectionName)
            }
            else {
                snapshotIndexPaths[i] = nil
            }
        }
        filteredSnapshots = newFilteredSnapshots
        tableView.reloadData()
    }
    
    var populateCellBlock: ((UITableViewCell, FIRDataSnapshot) -> Void)!
    var prototypeReuseIdentifier: String!
    var tableView: UITableView!
    
    init(query: FIRDatabaseQuery, sectionNameKey: String?, prototypeReuseIdentifier: String, tableView: UITableView, delegate: FilteredFirebaseTableViewDataSourceDelegate, populateCellBlock: ((UITableViewCell, FIRDataSnapshot) -> Void)) {
        super.init()
        
        self.sectionNameKey = sectionNameKey
        self.tableView = tableView
        tableView.dataSource = self
        self.delegate = delegate
        self.populateCellBlock = populateCellBlock
        
        unfilteredArray = FirebaseArray(query: query)
        unfilteredArray.delegate = self
        filteredSnapshots = TableDataModel<FIRDataSnapshot>()
        snapshotIndexPaths = []
        
        self.prototypeReuseIdentifier = prototypeReuseIdentifier
        
    }
    
    func resetQueryTo(query: FIRDatabaseQuery) {
        filteredSnapshots = TableDataModel<FIRDataSnapshot>()
        snapshotIndexPaths = []
        unfilteredArray.query = query
    }
    
    
    // MARK: TableViewDataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filteredSnapshots.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = filteredSnapshots.getSectionNameAtIndex(section)
        return filteredSnapshots.countInSection(sectionName)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(prototypeReuseIdentifier, forIndexPath: indexPath)
        let snapshot = filteredSnapshots.getElementAtIndexPath(indexPath)
        populateCellBlock(cell, snapshot)
        return cell
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return filteredSnapshots.keys
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if filteredSnapshots.numberOfSections() > 0 {
            return filteredSnapshots.getSectionNameAtIndex(section)
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    
    
    // MARK: Helper Functions
    
    /**
     * Returns the section name of the snapshot, or "" if there is none.
     */
    private func sectionNameForSnapshot(snapshot: FIRDataSnapshot) -> String {
        let snapshotValues = snapshot.value as! [String : AnyObject]
        var sectionName = ""
        if sectionNameKey != nil {
            sectionName = snapshotValues[sectionNameKey!] as? String ?? ""
        }
        return sectionName
    }
    
    /**
     * Inserts the snapshot into the filtered array in a place that preserves the order in unfilteredArray.
     * Keeps the filtered array synced with the index mapping array to facilitate filter maintenance in CRUD operations.
     */
    private func addToFilteredArray(snapshot: FIRDataSnapshot, withFirebaseIndex firebaseIndex: Int) {
        let sectionName = sectionNameForSnapshot(snapshot)
        var inserted = false
        for unfilteredIndex in (firebaseIndex-1).stride(through: 0, by: -1) {
            // Find the index of the snapshot that'll be right before the new one in its section of filteredSnapshots, and insert after it
            if let (prevSectionName, prevFilteredIndex) = snapshotIndexPaths[unfilteredIndex] where prevSectionName == sectionName {
                let insertionIndex = prevFilteredIndex+1
                let indexPath = (sectionName, insertionIndex)
                snapshotIndexPaths.insert(indexPath, atIndex: firebaseIndex)
                filteredSnapshots.insert(snapshot, intoSectionNamed: sectionName, atIndex: insertionIndex)
                inserted = true
                break
            }
        }
        if !inserted {
            // Then there was no snapshot in filteredSnapshots before this one - just add it to the beginning of the filteredSnapshots
            let firstRowIndex = 0
            snapshotIndexPaths.insert((sectionName, firstRowIndex), atIndex: firebaseIndex)
            filteredSnapshots.append(snapshot, toSectionNamed: sectionName)
        }
        
        // Now update snapshotIndexPaths, increasing the row index of everything after it in its section
        let unfilteredCount = Int(unfilteredArray.count())
        for unfilteredIndex in (firebaseIndex+1).stride(to: unfilteredCount, by: 1) {
            if let (otherSectionName, otherRowIndex) = snapshotIndexPaths[unfilteredIndex] where otherSectionName == sectionName {
                snapshotIndexPaths[unfilteredIndex]! = (otherSectionName, otherRowIndex + 1)
            }
        }
        tableView.reloadData()
    }
    
    /// Precondition: the snapshot's actually in filteredSnapshots before this is called
    private func removeFromModel(snapshot: FIRDataSnapshot, withFirebaseIndex firebaseIndex: Int) {
        let (sectionName, rowIndex) = snapshotIndexPaths[firebaseIndex]!
        filteredSnapshots.removeFromSection(sectionName, atIndex: rowIndex)
        
        let unfilteredCount = Int(unfilteredArray.count())
        for unfilteredIndex in (firebaseIndex).stride(to: unfilteredCount, by: 1) {
            if let (prevSectionName, prevRowIndex) = snapshotIndexPaths[unfilteredIndex] where prevSectionName == sectionName {
                snapshotIndexPaths[unfilteredIndex]! = (prevSectionName, prevRowIndex - 1)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: FirebaseArrayDelegate Methods
    
    func childAdded(object: AnyObject!, atIndex index: UInt) {
        let snapshot = object as! FIRDataSnapshot
        let firebaseIndex = Int(index)
        
        if delegate.includeSnapshot(snapshot) {
            addToFilteredArray(snapshot, withFirebaseIndex: firebaseIndex)
        } else {
            // Fails the search query, don't add to filtered array!
            snapshotIndexPaths.insert(nil, atIndex: firebaseIndex)
        }
    }
    
    func childChanged(object: AnyObject!, atIndex index: UInt) {
        let snapshot = object as! FIRDataSnapshot
        let firebaseIndex = Int(index)
        let sectionName = sectionNameForSnapshot(snapshot)
        
        // TODO: Handle case that the row changed (unless that's taken care of by childMoved? Test it!)
        
        if delegate.includeSnapshot(snapshot) {
            if let (oldSectionName, rowIndex) = snapshotIndexPaths[firebaseIndex] {
                if oldSectionName == sectionName {
                    // Simplest case: already in the filtered array, so it stays there, with an updated value
                    filteredSnapshots[sectionName]![rowIndex] = snapshot
                } else {
                    // Changed section -> just remove and re-add it
                    removeFromModel(snapshot, withFirebaseIndex: firebaseIndex)
                    addToFilteredArray(snapshot, withFirebaseIndex: firebaseIndex)
                }
            } else {
                // Not in the filtered list? Add it!
                addToFilteredArray(snapshot, withFirebaseIndex: firebaseIndex)
            }
        } else {
            if snapshotIndexPaths[firebaseIndex] != nil {
                // It was in the filtered list, but now it shouldn't be
                removeFromModel(snapshot, withFirebaseIndex: firebaseIndex)
            }
            // If it's wasn't, we don't need to do anything!
        }
    }
    
    func childRemoved(object: AnyObject!, atIndex index: UInt) {
        let snapshot = object as! FIRDataSnapshot
        let firebaseIndex = Int(index)
        if delegate.includeSnapshot(snapshot) {
            removeFromModel(snapshot, withFirebaseIndex: firebaseIndex)
        }
        snapshotIndexPaths.removeAtIndex(firebaseIndex)
    }
    
    // Below needs refactoring
    func childMoved(object: AnyObject!, fromIndex: UInt, toIndex: UInt) {
        let snapshot = object as! FIRDataSnapshot
        let fromFirebaseChildIndex = Int(fromIndex)
        let toFirebaseChildIndex = Int(toIndex)
        let sectionName = sectionNameForSnapshot(snapshot)
        
        if let (_, fromRowIndex) = snapshotIndexPaths[fromFirebaseChildIndex] {
            // It fulfilled the search - so we need to reorder filteredSnapshots too
            var insertionRowIndex = 0
            if toFirebaseChildIndex < fromFirebaseChildIndex {
                // Moving it to later
                for unfilteredIndex in (fromFirebaseChildIndex+1).stride(through: toFirebaseChildIndex, by: 1) {
                    snapshotIndexPaths[unfilteredIndex] = snapshotIndexPaths[unfilteredIndex+1]
                    if let (otherSectionName, otherRowIndex) = snapshotIndexPaths[unfilteredIndex] where otherSectionName == sectionName {
                        insertionRowIndex = otherRowIndex
                        snapshotIndexPaths[unfilteredIndex] = (otherSectionName, otherRowIndex-1)
                    }
                }
            } else {
                for unfilteredIndex in (fromFirebaseChildIndex).stride(to: toFirebaseChildIndex, by: -1) {
                    snapshotIndexPaths[unfilteredIndex] = snapshotIndexPaths[unfilteredIndex-1]
                    if let (otherSectionName, otherRowIndex) = snapshotIndexPaths[unfilteredIndex] where otherSectionName == sectionName {
                        insertionRowIndex = otherRowIndex
                        snapshotIndexPaths[unfilteredIndex] = (otherSectionName, otherRowIndex+1)
                    }
                }
            }
            
            snapshotIndexPaths[toFirebaseChildIndex] = (sectionName, insertionRowIndex)
            filteredSnapshots.removeFromSection(sectionName, atIndex: fromRowIndex)
            filteredSnapshots.insert(snapshot, intoSectionNamed: sectionName, atIndex: insertionRowIndex)
            
        } else {
            snapshotIndexPaths.removeAtIndex(fromFirebaseChildIndex)
            snapshotIndexPaths.insert(nil, atIndex: toFirebaseChildIndex)
        }
    }
    
}

protocol FilteredFirebaseTableViewDataSourceDelegate {
    func includeSnapshot(snapshot: FIRDataSnapshot) -> Bool
}
