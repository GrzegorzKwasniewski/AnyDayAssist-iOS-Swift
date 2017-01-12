//
//  UIViewControllerExtension.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 01/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func returnToMainScreen() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addNewTextNote() {
        self.performSegueWithIdentifier("addNewTextNote", sender: self)
    }
    
    func addNewPlaceToSee() {
        self.performSegueWithIdentifier("addNewPlaceToSee", sender: self)
    }
    
    func goToAudioRecordView() {
        self.performSegueWithIdentifier("goToAudioRecordView", sender: self)
    }
    
    // MARK: Animations
    
    func rotationAnimation(layer: CALayer) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = M_PI * 2
        rotationAnimation.duration = 4
        rotationAnimation.repeatCount = Float.infinity
        
        layer.addAnimation(rotationAnimation, forKey: nil)
    }
    
    func animateCloud(layer: CALayer) {
        
        layer.opacity = 0.8
        
        let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
        let duration: NSTimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
        
        let cloudMove = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.toValue = self.view.bounds.size.width + layer.bounds.width/2
        cloudMove.delegate = self
        cloudMove.autoreverses = true
        cloudMove.repeatCount = Float.infinity
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        
        layer.addAnimation(cloudMove, forKey: nil)
    }
}