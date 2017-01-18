//
//  PlacesViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 12/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class PlacesViewController: UIViewController, UIMaker {
    
    // MARK: - UI
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var messageLabel: UILabel = {
        let ml = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
        return ml
    }()
    
    // MARK: - Properties
    
    var uiWasSet = false
    var messageLabelWasSet = false
    
    // MARK: - View State

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(messageLabel)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
    }
    
    override func viewWillAppear(animated: Bool) {
        if !uiWasSet {
            setUI()
            uiWasSet = true
        }
        CoreDataFunctions.sharedInstance.getDataFromEntity("Places", managedObjects: &placesToVisit)
        tableView.reloadData()
        setMessageLabel(arrayToCount: placesToVisit, messageLabel: messageLabel)
    }
    
    // MARK: - Custom Functions

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

    // MARK: - TableView Functions

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesToVisit.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? CellPlace {
            
            let place = placesToVisit[indexPath.row]
            myCell.configureCell(place, cellImage: UIImage(named: "place")!)
            return myCell
            
        } else {
            return CellPlace()
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
            CoreDataFunctions.sharedInstance.removeFromEntity("Places", title: placeTitle, predicateFormat: "title == %@")
            placesToVisit.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(white: 100, alpha: 0.5)
    }
}
