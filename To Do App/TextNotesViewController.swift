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
        globalCoreDataFunctions.getDataFromEntity("Notes")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoNotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        let note = toDoNotes[indexPath.row]
        cell.textLabel?.text = note.valueForKey("note") as! String
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //let image: UIImage = UIImage(named: "AppIcon")!
        //cell.imageView?.image = image
        return cell
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
            globalCoreDataFunctions.removeFromTextNotes(noteText)
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
        let leftItem = UIBarButtonItem(title: "< Back", style: .Plain, target: nil, action: #selector(returnToMainScreen))
        let rightItem = UIBarButtonItem(title: "Add Note", style: .Plain, target: nil, action: #selector(promptForNote))
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        navigationbar.items = [navigationItem]
        
        view.addSubview(navigationbar)
    }
}
