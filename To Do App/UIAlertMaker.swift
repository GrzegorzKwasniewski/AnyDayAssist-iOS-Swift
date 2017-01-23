//
//  UIAlertProtocol.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 30/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol UIAlertMaker {}

extension UIAlertMaker where Self: UIViewController {
    
    // MARK: - Custom Functions

    func showAlert(withTitle title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertForChangingSettings(withTitle title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Change settings", style: .Default, handler: { (uialert) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        alert.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertToSaveAudioNote(withTitle title: String, withMessage message: String) {
        
        var noteTitle = ""
        
        let blueColor = UIColor(red: 19/255, green: 103/255, blue: 255/255, alpha: 1)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Note title"
            textField.textColor = blueColor
            textField.tintColor = blueColor
        }
        alert.addAction(UIAlertAction(title: "Save", style: .Cancel, handler: { (alertAction) in
            noteTitle = alert.textFields![0].text!
            NSNotificationCenter.defaultCenter().postNotificationName("saveAudioNote", object: noteTitle)
        }))
        alert.addAction(UIAlertAction(title: "Don't save", style: .Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading..."
    }
    
    func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
}