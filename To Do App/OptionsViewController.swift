//
//  OptionsViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 24/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UIAlertMaker {
    
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
    
    func returnToMainScreen() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setUI() {
        
        horizontalClass = self.traitCollection.horizontalSizeClass;
        verticalCass = self.traitCollection.verticalSizeClass;
        
        setView()
        setNavigationBar()
        
    }
    
    func setView() {
    
        let imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        
        if let backgroundColor = NSUserDefaults.standardUserDefaults().objectForKey("BackgroundColor") {
            
            imageView.image = UIImage(named: backgroundColor as! String)
            
        } else {
            
            imageView.image = UIImage(named: "bg_blue.jpg")
            
        }
        
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        view.backgroundColor = .lightGrayColor()
        
    }
    
    func setNavigationBar() {
        
        var fontSize: CGFloat!
        var yPosition: CGFloat!
        
        var navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        
        let leftItem = UIBarButtonItem(title: "< Main", style: .Plain, target: nil, action: #selector(returnToMainScreen))
        
        if horizontalClass == .Regular && verticalCass == .Regular {
            
            fontSize = 30
            yPosition = 40
            
        } else {
            
            fontSize = 17
            yPosition = 20
            
        }
        
        navigationBar = UINavigationBar(frame: CGRectMake( 0, yPosition, self.view.frame.size.width, 40))
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = true
        navigationBar.backgroundColor = UIColor.clearColor()
        
        leftItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: fontSize)!], forState: UIControlState.Normal)
        leftItem.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationBar.items = [navigationItem]
        
        view.addSubview(navigationBar)
    }
}
