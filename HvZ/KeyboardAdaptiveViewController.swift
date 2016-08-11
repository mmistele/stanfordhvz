//
//  KeyboardAdaptiveViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/5/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

class KeyboardAdaptiveViewController: UIViewController {

    /// Can be set by subclasses - see setUpAdaptation() for default
    internal var constraintToReplace: NSLayoutConstraint?
    
    /// Private variables for adapting to the keyboard
    private var bottomConstraint: NSLayoutConstraint?
    private var keyboardShowObserver: NSObjectProtocol?
    private var keyboardHideObserver: NSObjectProtocol?
    
    // How many pixels to separate the stack view from the keyboard
    internal var keyboardSeparation = CGFloat(10)
    
    /// The view that changes its constraints to not be covered by the keyboard
    internal var adaptingView: UIView?
    
    private var keyboardShowing: Bool = false
    
    /*
     * Called by subclasses once their view is loaded.
     */
    internal func setUpAdaptationFromCenteredY(forView adaptView: UIView) {
        adaptingView = adaptView
        constraintToReplace = NSLayoutConstraint(
            item: adaptingView!,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: view,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0)
        view.addConstraint(constraintToReplace!)
    }
    
    /*
     * Subscribes each time view will appear, except it won't work the first time -
     * need to also have subclass call subscribeToKeyboardAnimations() once it's loaded,
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardAnimations()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardAnimations()
    }
    
    /*
     * The following functions are called on view appear and disappear, and can be called
     * at other times by subclasses if needed (or by other classes if REALLY needed)
     */
    internal func subscribeToKeyboardAnimations() {
        subscribeToKeyboardShowAnimation()
        subscribeToKeyboardHideAnimation()
    }
    internal func unsubscribeFromKeyboardAnimations() {
        NSNotificationCenter.defaultCenter().removeObserver(keyboardShowObserver!)
        NSNotificationCenter.defaultCenter().removeObserver(keyboardHideObserver!)
    }
    
    
    /*
     * Handle keyboard coming in and obscuring adaptingView
     */
    private func subscribeToKeyboardShowAnimation() {
        let center = NSNotificationCenter.defaultCenter()
        keyboardShowObserver = center.addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            [weak self] (notification) in
            if self != nil && self!.adaptingView != nil && !self!.keyboardShowing {
                
                // Get end location of the keyboard
                // Following two lines adapted from http://stackoverflow.com/questions/25091765/how-to-get-a-value-from-nsvalue-in-swift
                if let endFrameOptional = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as? NSValue {
                    let endFrame = endFrameOptional.CGRectValue()
                    
                    let spaceForKeyboard = self!.view.bounds.maxY - self!.adaptingView!.frame.maxY
                    if endFrame.height < spaceForKeyboard {
                        // Do nothing, we're ok
                        return
                    }
                    
                    self!.view.layoutIfNeeded()
                    
                    // Detach view from the center
                    if let oldConstraint = self!.constraintToReplace {
                        self!.view.removeConstraint(oldConstraint)
                    }
                    
                    // Set end keyframe to being 10 pixels away from
                    self!.bottomConstraint = NSLayoutConstraint(
                        item: self!.adaptingView!,
                        attribute: .Bottom,
                        relatedBy: .Equal,
                        toItem: self!.view,
                        attribute: .Bottom,
                        multiplier: 1,
                        constant: 0 - endFrame.height - self!.keyboardSeparation)
                    
                    self!.view.addConstraint(self!.bottomConstraint!)
                    
                    var animationDuration = 3.0
                    if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
                        animationDuration = duration
                    }
                    // Adapted from http://stackoverflow.com/questions/12622424/how-do-i-animate-constraint-changes
                    UIView.animateWithDuration(animationDuration) {
                        self!.view.layoutIfNeeded()
                    }
                    
                }
                self!.keyboardShowing = true
            }
            })
    }
    
    /*
     * Reset to centered constraints
     */
    private func subscribeToKeyboardHideAnimation() {
        let center = NSNotificationCenter.defaultCenter()
        keyboardHideObserver = center.addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            [weak self] (notification) in
            if self != nil && self!.keyboardShowing {
                
                self!.view.layoutIfNeeded()
                
                // Detach view from where it got moved to
                if let oldConstraint = self!.bottomConstraint {
                    self!.view.removeConstraint(oldConstraint)
                }
                
                self!.view.addConstraint(self!.constraintToReplace!)
                
                var animationDuration = 3.0
                if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
                    animationDuration = duration
                }
                UIView.animateWithDuration(animationDuration) {
                    self!.view.layoutIfNeeded()
                }
                self!.keyboardShowing = false
            }
            
        })
        
    }

}
