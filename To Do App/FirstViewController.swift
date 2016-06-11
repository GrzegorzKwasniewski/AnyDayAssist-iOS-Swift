//
//  FirstViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/05/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

var toDoList = [NSManagedObject]()

class FirstViewController: UIViewController, UITableViewDelegate {
    
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // Pamiętaj - żeby działało musisz dodać w Main.StoryBoard - z TabelView do ViewController - dataSource i delegate
    // to z przeciąganiem myszką i ctrl
    
    @IBOutlet var toDoListTable: UITableView!
 
    @IBAction func addNote(sender: AnyObject) {
            promptForAnswer()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let note = toDoList[indexPath.row]
        cell.textLabel?.text = note.valueForKey("note") as! String
        // set image for cell
        var image: UIImage = UIImage(named: "AppIcon")!
        cell.imageView?.image = image
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    internal func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let note = toDoList[indexPath.row]
            let noteText = note.valueForKey("note") as! String
            removeFromNotes(noteText)
            toDoList.removeAtIndex(indexPath.row)
            toDoListTable.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // create contex of our App
        let appDell: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contextOfOurApp: NSManagedObjectContext = appDell.managedObjectContext
        
        // create request for data in Core Data entity - with this we get all of our data
        var request = NSFetchRequest(entityName: "Notes")
        
        do {
            // try to get data from Corde Data entity
            var results = try contextOfOurApp.executeFetchRequest(request)
            
            // check if there is any data
            if results.count > 0 {
                toDoList = results as! [NSManagedObject]
            }    
        } catch let error as NSError{
            print ("There was an error \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        toDoListTable.reloadData()
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Want You need TODO", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        
        let submitAction = UIAlertAction(title: "Add", style: .Default) { [unowned self, ac] (action: UIAlertAction!) in
            let answer = ac.textFields![0]
            
            // add answear to toDoList Array
            self.saveNote(answer.text!)
            self.toDoListTable.reloadData()

        }
        
        ac.addAction(submitAction)
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func saveNote(note: String) {
        
        // create context for our app
        let appDell: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contextOfOurApp: NSManagedObjectContext = appDell.managedObjectContext
        
        // create Core Data entity
        var newNote = NSEntityDescription.insertNewObjectForEntityForName("Notes", inManagedObjectContext: contextOfOurApp)
        
        newNote.setValue(note, forKey: "note")
        
            do {
                try contextOfOurApp.save()
                toDoList.append(newNote)
        
            } catch let error as NSError{
                print ("There was an error \(error), \(error.userInfo)")
            }
    }
    
    func removeFromNotes(noteText: String) {
        
        // create context for our app
        let appDell: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contextOfOurApp: NSManagedObjectContext = appDell.managedObjectContext
        
        // create request for data in Core Data entity - with this we get all of our data
        var request = NSFetchRequest(entityName: "Notes")
        request.predicate = NSPredicate(format: "note == %@", noteText)
        
        // we need to use if we want to see actual data in our app
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
}
