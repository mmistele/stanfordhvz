//
//  MasterFirstSplitViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/9/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

class MasterFirstSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    // Clear as mud, but this is supposedly the simplest way to display the master view controller first (from http://stackoverflow.com/questions/25875618/uisplitviewcontroller-in-portrait-on-iphone-shows-detail-vc-instead-of-master)
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}
