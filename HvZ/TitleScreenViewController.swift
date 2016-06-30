//
//  TitleScreenViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/3/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import AVFoundation

class TitleScreenViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        DummyStore.preloadData(inManagedObjectContext: ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!)
    }
    
}
