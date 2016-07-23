//
//  AudioNotesViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

var audioURL: [NSManagedObject] = [NSManagedObject]()
var activeAudioNote: Int?

class AudioNotesViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUI()
        globalCoreDataFunctions.getDataFromEntity("AudioNotes", managedObjects: &audioURL)
        tableView.reloadData()
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return audioURL.count
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell
        let note = audioURL[indexPath.row]
        myCell.noteTitle.textColor = UIColor.whiteColor()
        myCell.noteTitle.font = UIFont(name: "Helvetica Neue", size: 17)
        myCell.noteTitle.text = note.valueForKey("audiotitle") as! String
        myCell.cellImage.image = UIImage(named: "microphone")
        return myCell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            let singleAudio = audioURL[indexPath.row]
            let audioTitle = singleAudio.valueForKey("audiourl") as! String
            globalCoreDataFunctions.removeFromEntity("AudioNotes" , title: audioTitle, predicateFormat: "audiourl == %@")
            audioURL.removeAtIndex(indexPath.row)
            tableView.reloadData()
            
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        activeAudioNote = indexPath.row
        return indexPath
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(white: 100, alpha: 0.3)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = .clearColor()
        
    }
    
    func returnToMainScreen() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func goToMapView() {
        
        self.performSegueWithIdentifier("goAudioRecordView", sender: self)
        
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
        let rightItem = UIBarButtonItem(title: "Add Record >", style: .Plain, target: nil, action: #selector(goToMapView))
        leftItem.tintColor = UIColor.whiteColor()
        rightItem.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        navigationbar.items = [navigationItem]
        
        view.addSubview(navigationbar)
        
    }
}
