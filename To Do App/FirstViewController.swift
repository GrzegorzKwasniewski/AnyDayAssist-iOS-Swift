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
// create contex of our App for Core Data usage
let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let contextOfOurApp: NSManagedObjectContext = appDelegate.managedObjectContext

class FirstViewController: UIViewController, UITableViewDelegate {
    
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // Pamiętaj - żeby działało musisz dodać w Main.StoryBoard - z TabelView do ViewController - dataSource i delegate
    // to z przeciąganiem myszką i ctrl
    
    @IBOutlet var toDoNotesList: UITableView!
 
    @IBAction func addNote(sender: AnyObject) {
            promptForNote()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoNotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let note = toDoNotes[indexPath.row]
        cell.textLabel?.text = note.valueForKey("note") as! String
        
        // set image for cell
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
            removeFromNotes(noteText)
            toDoNotes.removeAtIndex(indexPath.row)
            toDoNotesList.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        getDataFromEntity("Notes")
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
            self.saveNote(note.text!)
            self.toDoNotesList.reloadData()

        }
        
        alertController.addAction(submitAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveNote(note: String) {

        // create Core Data entity
        let newNote = NSEntityDescription.insertNewObjectForEntityForName("Notes", inManagedObjectContext: contextOfOurApp)
        
        newNote.setValue(note, forKey: "note")
        
            do {
                try contextOfOurApp.save()
        
            } catch let error as NSError{
                print ("There was an error \(error), \(error.userInfo)")
            }
    }
    
    func removeFromNotes(noteText: String) {
        
        // create request for data in Core Data entity - with this we get all of our data
        let request = NSFetchRequest(entityName: "Notes")
        request.predicate = NSPredicate(format: "note == %@", noteText)
        
        // we need to use this if we want to see actual data in our app
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try contextOfOurApp.executeFetchRequest(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    contextOfOurApp.deleteObject(result)
                    
                    // we save our data
                    do {
                        try contextOfOurApp.save()
                    } catch let error as NSError{
                        print ("There was an error \(error), \(error.userInfo)")
                    }
                }
            }
            
        } catch let error as NSError {
            print ("There was an error \(error), \(error.userInfo)")
        }
    }
    
    func getDataFromEntity(entity: String) {
        
        let request = NSFetchRequest(entityName: entity)
        
        do {
            // try to get data from Corde Data entity
            let results = try contextOfOurApp.executeFetchRequest(request)
            
            // check if there is any data
            if results.count > 0 {
                toDoNotes = results as! [NSManagedObject]
            }
        } catch let error as NSError{
            print ("There was an error \(error), \(error.userInfo)")
        }
    }
}
