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

class TextNotesViewController: UIViewController, UITableViewDelegate, UIMaker {
    
    var horizontalClass: UIUserInterfaceSizeClass!
    var verticalCass: UIUserInterfaceSizeClass!
    
    var uiWasSet = false
    
    var messageLabel: UILabel = UILabel()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(TextNotesViewController.popoverViewWasDismissed(_:)),
            name: "popoverViewWasDismissed",
            object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if !uiWasSet {
            
            setUI()
            uiWasSet = true
            
        }
        
        globalCoreDataFunctions.getDataFromEntity("Notes", managedObjects: &toDoNotes)
        tableView.reloadData()
        setMessageLabel()
        
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
        myCell.noteTitle.text = note.valueForKey("note") as? String
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
        
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clearColor()
        
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
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
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setUI() {
        
        horizontalClass = self.traitCollection.horizontalSizeClass;
        verticalCass = self.traitCollection.verticalSizeClass;
        
        self.setTableView(forTableView: tableView)
        self.setNavigationBar()
        
    }
    
    func setMessageLabel() {
        
        if toDoNotes.count == 0 {
            
            messageLabel = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel.font = UIFont(name: "Helvetica Neue", size: 20)
            messageLabel.textColor = UIColor.whiteColor()
            messageLabel.text = "There's nothing here..."
            messageLabel.textAlignment = .Center
            
            view.addSubview(messageLabel)
        }
    }
    
    func popoverViewWasDismissed(notification: NSNotification) {

        globalCoreDataFunctions.getDataFromEntity("Notes", managedObjects: &toDoNotes)
        tableView.reloadData()
        
        if toDoNotes.count > 0 {
            messageLabel.text = ""
        }
    }
}
