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

class PlacesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // on first start of the app remove empty value form placesToVisit
        if placesToVisit.count == 1 && placesToVisit[0].valueForKey("latitude") == nil {
            placesToVisit.removeAtIndex(0)
        }
        
        getDataFromEntity("Places")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placesToVisit.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let placeMarked = placesToVisit[indexPath.row]
        cell.textLabel?.text = placeMarked.valueForKey("title") as! String
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activPlace = indexPath.row
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNewPlace" {
            activPlace = -1
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let singlePlace = placesToVisit[indexPath.row]
            let placeTitle = singlePlace.valueForKey("title") as! String
            removeFromPlaces(placeTitle)
            placesToVisit.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func getDataFromEntity(entity: String) {
        
        let request = NSFetchRequest(entityName: entity)
        
        do {
            // try to get data from Corde Data entity
            let results = try contextOfOurApp.executeFetchRequest(request)
            
            // check if there is any data
            if results.count > 0 {
                placesToVisit = results as! [NSManagedObject]
            }
        } catch let error as NSError{
            print ("There was an error \(error), \(error.userInfo)")
        }
    }
    
    func removeFromPlaces(noteText: String) {
        let request = NSFetchRequest(entityName: "Places")
        request.predicate = NSPredicate(format: "title == %@", noteText)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try contextOfOurApp.executeFetchRequest(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    contextOfOurApp.deleteObject(result)
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
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
