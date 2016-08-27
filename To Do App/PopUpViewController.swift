//
//  PopUpViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 04/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet var noteText: UITextField!
    
    @IBAction func saveNote(sender: AnyObject) {
        if !(noteText.text!.isEmpty) {
            globalCoreDataFunctions.saveTextNote(noteText.text!)
        }
        removeAnimate()
    }
    
    @IBAction func closePopUpView(sender: AnyObject) {
        removeAnimate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0)
        showAnimate()
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransformMakeScale(0.7, 0.7)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    func removeAnimate() {        
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                
            if (finished)
                    
            {
                NSNotificationCenter.defaultCenter().postNotificationName("popoverViewWasDismissed", object: nil)
                self.view.removeFromSuperview()
            }
        })
    }
}
