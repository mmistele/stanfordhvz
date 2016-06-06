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
    
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DummyStore.preloadData(inManagedObjectContext: ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Referenced this page: http://budiirawan.com/ios-play-sound-swift/
        if audioPlayer == nil {
            if let audioFilePath = NSBundle.mainBundle().pathForResource("Thriller", ofType: "mp3") {
                let url = NSURL(fileURLWithPath: audioFilePath)
                do {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: url, fileTypeHint: "mp3")
                } catch {
                    print("Couldn't make audio player.")
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if audioPlayer != nil && !audioPlayer!.playing {
            audioPlayer!.play()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        if audioPlayer != nil {
//            audioPlayer!.pause()
//        }
    }
    
    private struct Storyboard {
        static let LoginSegueIdentifier = "Segue to Login"
        static let SignupSegueIdentifier = "Segue to Signup"
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.LoginSegueIdentifier:
                if audioPlayer != nil {
                    audioPlayer!.pause()
                }
            default: break
            }
        }
    }
    
}
