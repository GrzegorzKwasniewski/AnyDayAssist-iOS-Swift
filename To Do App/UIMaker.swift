//
//  UIMaker.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 30/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {

    func returnToMainScreen() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func promptForNote() {
        
        let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("popUpView") as! PopUpViewController
        self.addChildViewController(popUpView)
        popUpView.view.frame = self.view.frame
        self.view.addSubview(popUpView.view)
        popUpView.didMoveToParentViewController(self)
        
    }
    
    func addNewPlaceToSee() {
        
        self.performSegueWithIdentifier("addNewPlaceToSee", sender: self)
        
    }
    
    func goToAudioRecordView() {
        
        self.performSegueWithIdentifier("goToAudioRecordView", sender: self)
        
    }

}

protocol UIMaker {}

extension UIMaker where Self: UIViewController {

    func setNavigationBar(forClassWithName name: String) {
        
        let horizontalClass = self.traitCollection.horizontalSizeClass;
        let verticalCass = self.traitCollection.verticalSizeClass;
        
        var fontSize: CGFloat!
        var yPosition: CGFloat!
        
        var navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        
        var leftItem: UIBarButtonItem!
        var rightItem: UIBarButtonItem?
        
        switch name {
            
        case "TextNotesViewController":
            
            leftItem = UIBarButtonItem(title: "< Main", style: .Plain, target: nil, action: #selector(UIViewController.returnToMainScreen))
            rightItem = UIBarButtonItem(title: "Add Note >", style: .Plain, target: nil, action: #selector(UIViewController.promptForNote))
            
        case "PlacesViewController":
            
            leftItem = UIBarButtonItem(title: "< Main", style: .Plain, target: nil, action: #selector(UIViewController.returnToMainScreen))
            rightItem = UIBarButtonItem(title: "Add Place >", style: .Plain, target: nil, action: #selector(UIViewController.addNewPlaceToSee))
            
        case "AudioNotesViewController":
            
            leftItem = UIBarButtonItem(title: "< Main", style: .Plain, target: nil, action: #selector(UIViewController.returnToMainScreen))
            rightItem = UIBarButtonItem(title: "Add Record >", style: .Plain, target: nil, action: #selector(UIViewController.goToAudioRecordView))
            
        default:
            
            leftItem = UIBarButtonItem(title: "< Back", style: .Plain, target: nil, action: #selector(UIViewController.returnToMainScreen))

        }
        
        
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
        rightItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: fontSize)!], forState: UIControlState.Normal)
        leftItem.tintColor = UIColor.whiteColor()
        rightItem?.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        navigationBar.items = [navigationItem]
        
        view.addSubview(navigationBar)
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
    }
    
    func setTableView(forTableView tableView: UITableView) {
        
        let horizontalClass = self.traitCollection.horizontalSizeClass;
        let verticalCass = self.traitCollection.verticalSizeClass;
        
        var topMargin: CGFloat!
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        
        if let backgroundColor = NSUserDefaults.standardUserDefaults().objectForKey("BackgroundColor") {
            
            imageView.image = UIImage(named: backgroundColor as! String)
            
        } else {
            
            imageView.image = UIImage(named: "bg_blue.jpg")
            
        }
        
        imageView.contentMode = .ScaleAspectFill
        
        if horizontalClass == .Regular && verticalCass == .Regular {
            
            topMargin = 100
            
        } else {
            
            topMargin = 64
            
        }
        
        tableView.contentInset = UIEdgeInsetsMake(topMargin, 0, 0, 0);
        tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.backgroundColor = .lightGrayColor()
        
    }
    
    func setMessageLabel(arrayToCount array: [NSManagedObject], messageLabel label: UILabel) {
        
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        if array.count == 0 {
            
            label.text = "There's nothing here..."
            
        } else {
        
            label.text = ""

        }
        
        view.addSubview(label)
    }

}
