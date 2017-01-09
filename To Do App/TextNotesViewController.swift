//
//  FirstViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/05/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class TextNotesViewController: UIViewController {
    
    var uiWasSet = false
    lazy var messageLabel: UILabel = {
        let ml = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
        return ml
    }()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(messageLabel)
        setObserverForChange()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if !uiWasSet {
            
            setUI()
            uiWasSet = true
            
        }
        
        globalCoreDataFunctions.getDataFromEntity("Notes", managedObjects: &toDoNotes)
        tableView.reloadData()
        setMessageLabel(arrayToCount: toDoNotes, messageLabel: messageLabel)
        
    }
    
    func setObserverForChange() {
    
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(TextNotesViewController.popoverViewWasDismissed(_:)),
            name: "popoverViewWasDismissed",
            object: nil)
        
    }

    func popoverViewWasDismissed(notification: NSNotification) {

        globalCoreDataFunctions.getDataFromEntity("Notes", managedObjects: &toDoNotes)
        tableView.reloadData()
        setMessageLabel(arrayToCount: toDoNotes, messageLabel: messageLabel)

    }
}

extension TextNotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoNotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? Cell {
            
            let note = toDoNotes[indexPath.row]
            myCell.noteTitle.textColor = UIColor.whiteColor()
            myCell.noteTitle.text = note.valueForKey("note") as? String
            myCell.cellImage.image = UIImage(named: "notes")
            return myCell
            
        } else {
            
            return Cell()
            
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
        }
    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        
//        let singleNote = toDoNotes[indexPath.row]
//        
//        let edit = UITableViewRowAction(style: .Default, title: "Edit") { (action, indexPath) in
//            
//            // chyba lepiej będzie zrobić inny popUp do tego
//            let popUpView:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("popUpView") as! PopUpViewController
//            self.addChildViewController(popUpView)
//            popUpView.view.frame = self.view.frame
//            self.view.addSubview(popUpView.view)
//            popUpView.didMoveToParentViewController(self)
//            
//        }
//        
//        edit.backgroundColor = .greenColor()
//        
//        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
//            let noteText = singleNote.valueForKey("note") as! String
//            toDoNotes.removeAtIndex(indexPath.row)
//            tableView.reloadData()
//            globalCoreDataFunctions.removeFromEntity("Notes", title: noteText, predicateFormat: "note == %@")
//        }
//        
//        return [edit, delete]
//    }
}

extension TextNotesViewController: UIMaker {
    
    func setUI() {
        
        setTableView(forTableView: tableView)
        setNavigationBar(forClassWithName: String(TextNotesViewController.self))
        
    }
}
