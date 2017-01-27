//
//  SaveAudioNoteAlert.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 27/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class SaveAudioNoteAlert: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet var alertView: RoundedCornersView!
    
    // MARK - Properties
    
    var customTextField = CustomTextField()
    
    // MARK - View State
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTextField = CustomTextField(frame: CGRectMake(10, 10, alertView.bounds.width - 20, 40), lengthLimit: 20)
        alertView.addSubview(customTextField)
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
    
    // MARK: - Custom Functions
    
    @IBAction func saveAudioNote(sender: AnyObject) {
        if let noteTitle = customTextField.text {
            if noteTitle.characters.count > 0 {
                NSNotificationCenter.defaultCenter().postNotificationName("saveAudioNote", object: noteTitle)
                removeAnimate()
            } else {
                customTextField.attributedPlaceholder = NSAttributedString(string: "Give me a name!", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            }
        }
    }
    
    @IBAction func closePopUpView(sender: AnyObject) {
        removeAnimate()
    }
    
    func removeAnimate() {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                
                if (finished)
                    
                {
                    self.view.removeFromSuperview()
                }
        })
    }
}

