////
////  FirstViewController.swift
////  To Do App
////
////  Created by Grzegorz Kwaśniewski on 16/05/16.
////  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//var toDoNotes = [NSManagedObject]()
//let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//let contextOfOurApp: NSManagedObjectContext = appDelegate.managedObjectContext
//
//class NotesViewController: UITableViewController, UITableViewDelegate {
//
//    //@IBOutlet var toDoNotesList: UITableView!
// 
//    @IBAction func addNote(sender: AnyObject) {
//        promptForNote()
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        return toDoNotes.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
//        let note = toDoNotes[indexPath.row]
//        cell.textLabel?.text = note.valueForKey("note") as! String
//        let image: UIImage = UIImage(named: "AppIcon")!
//        cell.imageView?.image = image
//        return cell
//    }
//    
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//            let singleNote = toDoNotes[indexPath.row]
//            let noteText = singleNote.valueForKey("note") as! String
//            toDoNotes.removeAtIndex(indexPath.row)
//            tableView.reloadData()
//            globalCoreDataFunctions.removeFromTextNotes(noteText)
//        }
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(true)
//        
//        setUI()
//        globalCoreDataFunctions.getDataFromEntity("Notes")
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        tableView.reloadData()
//    }
//    
//    func promptForNote() {
//        let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("popUpView") as! PopUpViewController
//        self.addChildViewController(popUpView)
//        popUpView.view.frame = self.view.frame
//        self.view.addSubview(popUpView.view)
//        popUpView.didMoveToParentViewController(self)
//        
//    }
//    
//    func setUI() {
//    
//        let backgroundImage = UIImage(named: "bg.jpg")
//        let imageView = UIImageView(image: backgroundImage)
//        tableView.backgroundView = imageView
//    
//        // no lines where there aren't cells
//        tableView.tableFooterView = UIView(frame: CGRectZero)
//    
//        // center and scale background image
//        imageView.contentMode = .ScaleAspectFit
//    
//        // Set the background color to match better
//        //I'm not using png file right now so it won't make any change
//        tableView.backgroundColor = .lightGrayColor()
//    
//        // making anvigation bar transparent
//        // we don't set any image - we leave it blank
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.translucent = true
//    }
//}
