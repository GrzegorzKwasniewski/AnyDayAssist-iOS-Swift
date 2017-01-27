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
    
    func showAlertToSaveAudioNote() {
        
        let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(SaveAudioNoteAlert.self)) as! SaveAudioNoteAlert
        self.addChildViewController(popUpView)
        popUpView.view.frame = self.view.frame
        self.view.addSubview(popUpView.view)
        popUpView.didMoveToParentViewController(self)
        
    }
    
    func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading..."
    }
    
    func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
}