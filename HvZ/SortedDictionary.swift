//
//  SortedDictionary.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/10/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//
//  Credit to http://timekl.com/blog/2014/06/02/learning-swift-ordered-dictionaries/
//  for a great starting point for this struct.
//

import Foundation

/// Contains a dictionary and an array of its keys ordered using its isOrderedBefore property.
struct SortedDictionary<Tk: Hashable, Tv> {
    
    /// Array of keys ordered using isOrderedBefore.
    var keys: Array<Tk> = []
    
    /// The dictionary itself.
    var values: Dictionary<Tk,Tv> = [:]
    
    /// Comparator used for keeping the keys array sorted.
    var isOrderedBefore: (a: Tk, b: Tk) -> Bool = { (a, b) in
        if let string1 = a as? String, string2 = b as? String {
            let comparisonResult = string1.caseInsensitiveCompare(string2)
            return comparisonResult == NSComparisonResult.OrderedAscending
        }
        else if let number1 = a as? Int, number2 = b as? Int {
            return number1 < number2
        }
        else if let number1 = a as? Double, number2 = b as? Double {
            return number1 < number2
        }
        return true
    }
    
    
    /// Creates an empty dictionary.
    init() { }
    
    /// Enables the use of sortedDict[key] syntax to index into it, and keeps the keys array sorted when a new key is used.
    subscript(key: Tk) -> Tv? {
        get {
            return values[key]
        }
        set(newValue) {
            if (newValue == nil) {
                values.removeValueForKey(key)
                keys = keys.filter {$0 != key}
                return
            }
            
            let oldValue = values.updateValue(newValue!, forKey: key)
            if oldValue == nil {
                let insertIndex = findInsertIndex(forKey: key)
                keys.insert(key, atIndex: insertIndex)
                //                keys.sortInPlace(isOrderedBefore)
            }
            
        }
    }
    
    
    /// Description for debugging purposes.
    var description: String {
        var result = "{\n"
        for i in 0..<keys.count {
            let key = keys[i]
            result += "[\(i)]: \(key) => \(self[key])\n"
        }
        result += "}"
        return result
    }
    
    /// Used to maintain sorted order.
    private func findInsertIndex(forKey key: Tk) -> Int {
        // binary search
        var low = 0
        var hi = keys.count-1
        while hi >= low {
            let mid = (low + hi)/2
            let element = keys[mid]
            if isOrderedBefore(a: key, b: element) {
                hi = mid-1
            } else {
                low = mid+1
            }
        }
        return low
    }
    
}