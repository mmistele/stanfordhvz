//
//  Extensions.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/9/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

extension String {
    func containsStringCaseInsensitive(str: String) -> Bool {
        return self.lowercaseString.containsString(str.lowercaseString)
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController!
        } else {
            return self
        }
    }
}