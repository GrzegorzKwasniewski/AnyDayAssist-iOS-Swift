//
//  PlacesViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 12/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

var placesToVisit = [NSManagedObject]()
var activPlace = -1

class PlacesViewController: UIViewController, UITableViewDelegate {
    
    var horizontalClass: UIUserInterfaceSizeClass!
    var verticalCass: UIUserInterfaceSizeClass!
    
    var uiWasSet = false
    
    var messageLabel: UILabel = UILabel()
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
  
        if !uiWasSet {
            
            setUI()
            uiWasSet = true
            
        }
        
        removeEmptyValueAtStart()
        globalCoreDataFunctions.getDataFromEntity("Places", managedObjects: &placesToVisit)
        tableView.reloadData()
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return placesToVisit.count
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell
        let note = placesToVisit[indexPath.row]
        myCell.noteTitle.textColor = UIColor.whiteColor()
        myCell.noteTitle.text = note.valueForKey("title") as! String
        myCell.cellImage.image = UIImage(named: "place")
        return myCell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = .clearColor()
        
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        activPlace = indexPath.row
        return indexPath
        
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            let singlePlace = placesToVisit[indexPath.row]
            let placeTitle = singlePlace.valueForKey("title") as! String
            globalCoreDataFunctions.removeFromEntity("Places", title: placeTitle, predicateFormat: "title == %@")
            placesToVisit.removeAtIndex(indexPath.row)
            tableView.reloadData()
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(white: 100, alpha: 0.5)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNewPlaceToSee" {
            activPlace = -1
        }
    }
    
    func returnToMainScreen() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addNewPlaceToSee() {
        self.performSegueWithIdentifier("addNewPlaceToSee", sender: self)
    }
    
    func setUI() {
        
        horizontalClass = self.traitCollection.horizontalSizeClass;
        verticalCass = self.traitCollection.verticalSizeClass;
        
        setTableView()
        setNavigationBar()

    }
    
    func setTableView() {
        
        var topMargin: CGFloat!
        
        let backgroundImage = UIImage(named: "bg.jpg")
        let imageView = UIImageView(image: backgroundImage)
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
    
    func setNavigationBar() {
        
        var fontSize: CGFloat!
        var yPosition: CGFloat!
        
        var navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        
        let leftItem = UIBarButtonItem(title: "< Main", style: .Plain, target: nil, action: #selector(returnToMainScreen))
        let rightItem = UIBarButtonItem(title: "Add Place >", style: .Plain, target: nil, action: #selector(addNewPlaceToSee))
        
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
        rightItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: fontSize)!], forState: UIControlState.Normal)
        leftItem.tintColor = UIColor.whiteColor()
        rightItem.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        navigationBar.items = [navigationItem]
        
        view.addSubview(navigationBar)
        
    }
    
    func setMessageLabel() {
            
        messageLabel = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
        messageLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        messageLabel.textColor = UIColor.whiteColor()
            
        if placesToVisit.count > 0 {
                
            messageLabel.text = ""
                
        } else {
                
            messageLabel.text = "There's nothing here..."
                
        }
            
        messageLabel.textAlignment = .Center
            
        view.addSubview(messageLabel)
        
    }
    
    func removeEmptyValueAtStart() {
        if placesToVisit.count == 1 && placesToVisit[0].valueForKey("latitude") == nil {
            placesToVisit.removeAtIndex(0)
        }
    }
}
