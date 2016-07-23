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
    
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUI()
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
        myCell.noteTitle.font = UIFont(name: "Helvetica Neue", size: 17)
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
        let rightItem = UIBarButtonItem(title: "Add Place >", style: .Plain, target: nil, action: #selector(addNewPlaceToSee))
        leftItem.tintColor = UIColor.whiteColor()
        rightItem.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        navigationbar.items = [navigationItem]
        
        view.addSubview(navigationbar)
        
    }
    
    func removeEmptyValueAtStart() {
        if placesToVisit.count == 1 && placesToVisit[0].valueForKey("latitude") == nil {
            placesToVisit.removeAtIndex(0)
        }
    }
}
