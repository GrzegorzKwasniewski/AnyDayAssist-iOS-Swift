//
//  OptionsViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 24/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UIAlertMaker, UIMaker {
    
    var horizontalClass: UIUserInterfaceSizeClass!
    var verticalCass: UIUserInterfaceSizeClass!
    
    @IBAction func setBackgroundColorBlue(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setObject("bg_blue.jpg", forKey: "BackgroundColor")
        
        showAlert(withTitle: "Blue background", withMessage: "You will see change on the next screen")

    }
    
    @IBAction func setBackgroundColorRed(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setObject("bg_red.jpg", forKey: "BackgroundColor")
        
        showAlert(withTitle: "Red background", withMessage: "You will see change on the next screen")

    }
    
    @IBAction func setBackgroundColorGreen(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setObject("bg_green.jpg", forKey: "BackgroundColor")
        
        showAlert(withTitle: "Green background", withMessage: "You will see change on the next screen")

    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUI()
        
    }
    
    func setUI() {
        
        setView()
        setNavigationBar(forClassWithName: String(OptionsViewController.self))
        
    }
}
