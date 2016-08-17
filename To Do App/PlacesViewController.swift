//
//  PlacesViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 12/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class PlacesViewController: UIViewController, UITableViewDelegate, UIMaker {
    
    var uiWasSet = false
    var messageLabelWasSet = false
    
    var messageLabel: UILabel = UILabel()
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        messageLabel = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
        
    }
    
    override func viewWillAppear(animated: Bool) {
  
        if !uiWasSet {
            
            setUI()
            uiWasSet = true
            
        }
        
        globalCoreDataFunctions.getDataFromEntity("Places", managedObjects: &placesToVisit)
        tableView.reloadData()
        setMessageLabel(arrayToCount: placesToVisit, messageLabel: messageLabel)
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return placesToVisit.count
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? Cell {
        
            let note = placesToVisit[indexPath.row]
            myCell.noteTitle.textColor = UIColor.whiteColor()
            myCell.noteTitle.text = note.valueForKey("title") as? String
            myCell.cellImage.image = UIImage(named: "place")
            return myCell
        
        } else {
        
            return Cell()
        
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = .clearColor()
        
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        activPlace = indexPath.row
        return indexPath
        
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let singlePlace = placesToVisit[indexPath.row]
            let placeTitle = singlePlace.valueForKey("title") as! String
            globalCoreDataFunctions.removeFromEntity("Places", title: placeTitle, predicateFormat: "title == %@")
            placesToVisit.removeAtIndex(indexPath.row)
            tableView.reloadData()
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(white: 100, alpha: 0.5)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addNewPlaceToSee" {
            
            activPlace = -1
            
        }
    }
    
    func setUI() {

        setTableView(forTableView: tableView)
        setNavigationBar(forClassWithName: String(PlacesViewController.self))

    }
}
