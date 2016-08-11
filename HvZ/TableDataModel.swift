//
//  TableDataModel.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/10/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import Foundation

// Possible refactor: making SortedDictionary a struct again, and have this class have one as a property instead of being one
// Also maybe replace "self" with "values" below.
class TableDataModel<T>: SortedDictionary<String, Array<T> > {
    
    func insert(element: T, intoSectionNamed sectionName: String, atIndex index: Int) {
        if !keys.contains(sectionName) {
            self[sectionName] = [T]()
        }
        self[sectionName]!.insert(element, atIndex: index)
    }
    
    func removeFromSection(sectionName: String, atIndex index: Int) {
        self[sectionName]?.removeAtIndex(index)
        if self[sectionName]?.count == 0 {
            self[sectionName] = nil
        }
    }
    
    func append(element: T, toSectionNamed sectionName: String) {
        if !keys.contains(sectionName) {
            self[sectionName] = [T]()
        }
        self[sectionName]!.append(element)
    }
    
    func countInSection(sectionName: String) -> Int {
        if !keys.contains(sectionName) {
            return 0
        } else {
            return self[sectionName]!.count
        }
    }
    
    func numberOfSections() -> Int {
        return keys.count
    }
    
    func getSectionNameAtIndex(index: Int) -> String {
        return keys[index]
    }
    
    func getElementAtIndexPath(indexPath: NSIndexPath) -> T {
        let sectionName = self.getSectionNameAtIndex(indexPath.section)
        let sectionSnapshots = self[sectionName]!
        return sectionSnapshots[indexPath.row]
    }
}
