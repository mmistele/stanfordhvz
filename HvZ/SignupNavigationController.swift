//
//  AudioPlayingNavigationViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/5/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import AVFoundation

/*
 * Takes care of the audio and player data between screens of login/signup.
 */
class SignupNavigationController: UINavigationController {

    var audioPlayer: AVAudioPlayer?
    
    var firstName: String?
    var lastName: String?
    var newUserPassword: String?
    var newUserCellNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
