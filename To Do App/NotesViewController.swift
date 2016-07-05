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

class NotesViewController: UIViewController, UITableViewDelegate {
    
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // Pamiętaj - żeby działało musisz dodać w Main.StoryBoard - z TabelView do ViewController - dataSource i delegate
    // to z przeciąganiem myszką i ctrl
    
    @IBOutlet var toDoNotesList: UITableView!
 
    @IBAction func addNote(sender: AnyObject) {
        
        let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("popUpView") as! PopUpViewController
        self.addChildViewController(popUpView)
        popUpView.view.frame = self.view.frame
        self.view.addSubview(popUpView.view)
        popUpView.didMoveToParentViewController(self)
        //promptForNote()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoNotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let note = toDoNotes[indexPath.row]
        cell.textLabel?.text = note.valueForKey("note") as! String
        let image: UIImage = UIImage(named: "AppIcon")!
        cell.imageView?.image = image
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    internal func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let singleNote = toDoNotes[indexPath.row]
            let noteText = singleNote.valueForKey("note") as! String
            toDoNotes.removeAtIndex(indexPath.row)
            toDoNotesList.reloadData()
            globalCoreDataFunctions.removeFromTextNotes(noteText)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        globalCoreDataFunctions.getDataFromEntity("Notes")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        toDoNotesList.reloadData()
    }
    
    func promptForNote() {
        let alertController = UIAlertController(title: "Want You need TODO", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        
        let submitAction = UIAlertAction(title: "Add", style: .Default) { [unowned self, alertController] (action: UIAlertAction!) in
            let note = alertController.textFields![0]
            
            // add answear to toDoList Array
            globalCoreDataFunctions.saveTextNote(note.text!)

        }
        
        alertController.addAction(submitAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
}
