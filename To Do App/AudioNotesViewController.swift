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
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        getDataFromEntity("AudioNotes")
        setUI()
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return audioURL.count
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let audioTitle = audioURL[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 17)
        cell.textLabel?.text = (audioTitle.valueForKey("audiotitle") as! String)
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            let singleAudio = audioURL[indexPath.row]
            let audioTitle = singleAudio.valueForKey("audiourl") as! String
            removeFromAudioNotes(audioTitle)
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
    
    func getDataFromEntity(entity: String) {
        
        let request = NSFetchRequest(entityName: entity)
    
        do {
            
            let results = try contextOfOurApp.executeFetchRequest(request)
            
            if results.count > 0 {
                
                audioURL = results as! [NSManagedObject]
                
            }
            
        } catch let error as NSError{
            
            print ("There was an error \(error), \(error.userInfo)")
            
        }
    }
    
    func removeFromAudioNotes(audioTitle: String) {
        
        let request = NSFetchRequest(entityName: "AudioNotes")
        request.predicate = NSPredicate(format: "audiourl == %@", audioTitle)
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
    
    func returnToMainScreen() {
        
        self.performSegueWithIdentifier("returnToMainScreen", sender: self)
        
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
