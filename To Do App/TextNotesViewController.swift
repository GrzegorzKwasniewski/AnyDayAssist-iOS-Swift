//
//  FirstViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/05/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

var toDoNotes = [NSManagedObject]()
let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let contextOfOurApp: NSManagedObjectContext = appDelegate.managedObjectContext

class TextNotesViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        setUI()
        globalCoreDataFunctions.getDataFromEntity("Notes", managedObjects: &toDoNotes)
        tableView.reloadData()
        setMessageLabel()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(TextNotesViewController.dismissPopoverView(_:)),
            name: "DismissPopoverView",
            object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoNotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell
        let note = toDoNotes[indexPath.row]
        myCell.noteTitle.textColor = UIColor.whiteColor()
        myCell.noteTitle.font = UIFont(name: "Helvetica Neue", size: 17)
        myCell.noteTitle.text = note.valueForKey("note") as! String
        myCell.cellImage.image = UIImage(named: "notes")
        return myCell
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            let singleNote = toDoNotes[indexPath.row]
            let noteText = singleNote.valueForKey("note") as! String
            toDoNotes.removeAtIndex(indexPath.row)
            tableView.reloadData()
            globalCoreDataFunctions.removeFromEntity("Notes", title: noteText, predicateFormat: "note == %@")
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clearColor()
        
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(white: 100, alpha: 0.3)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clearColor()
    }
        
    func promptForNote() {
        
        let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("popUpView") as! PopUpViewController
        self.addChildViewController(popUpView)
        popUpView.view.frame = self.view.frame
        self.view.addSubview(popUpView.view)
        popUpView.didMoveToParentViewController(self)
        
    }
    
    func returnToMainScreen() {
        
        self.performSegueWithIdentifier("showMainScreen", sender: self)
        
    }
    
    func setUI() {
        
        setTableView()
        setNavigationBar()
        
    }
    
    func setTableView() {
        
        let backgroundImage = UIImage(named: "bg.jpg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .ScaleAspectFill

        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.backgroundColor = .lightGrayColor()
        
    }
    
    func setNavigationBar() {
        
        let navigationbar = UINavigationBar(frame: CGRectMake( 0, 20, self.view.frame.size.width, 40))
        navigationbar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationbar.shadowImage = UIImage()
        navigationbar.translucent = true
        navigationbar.backgroundColor = UIColor.clearColor()
        
        let navigationItem = UINavigationItem()
        let leftItem = UIBarButtonItem(title: "< Main", style: .Plain, target: nil, action: #selector(returnToMainScreen))
        let rightItem = UIBarButtonItem(title: "Add Note >", style: .Plain, target: nil, action: #selector(promptForNote))
        leftItem.tintColor = UIColor.whiteColor()
        rightItem.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        navigationbar.items = [navigationItem]
        
        view.addSubview(navigationbar)
    }
    
    func setMessageLabel() {
        
        if toDoNotes.count == 0 {
            
            let messageLabel: UILabel = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel.font = UIFont(name: "Helvetica Neue", size: 17)
            messageLabel.textColor = UIColor.whiteColor()
            messageLabel.text = "There's nothing here..."
            messageLabel.textAlignment = .Center
            
            view.addSubview(messageLabel)
        }
    }
    
    func dismissPopoverView(notification: NSNotification) {

        globalCoreDataFunctions.getDataFromEntity("Notes", managedObjects: &toDoNotes)
        tableView.reloadData()
        
    }
}
