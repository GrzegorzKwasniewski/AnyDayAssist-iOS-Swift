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
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        getDataFromEntity("AudioNotes")
        setUI()
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioURL.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let audioTitle = audioURL[indexPath.row]
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
        selectedCell.contentView.backgroundColor = UIColor(white: 100, alpha: 0.5)
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
        
        let backgroundImage = UIImage(named: "bg.jpg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .ScaleAspectFill
        
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.backgroundColor = .lightGrayColor()
        
        let navigationbar = UINavigationBar(frame: CGRectMake( 0, 20, self.view.frame.size.width, 40))
        navigationbar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationbar.shadowImage = UIImage()
        navigationbar.translucent = true
        navigationbar.backgroundColor = UIColor.clearColor()
        let navigationItem = UINavigationItem()
        let leftItem = UIBarButtonItem(title: "< Main", style: .Plain, target: nil, action: #selector(returnToMainScreen))
        let rightItem = UIBarButtonItem(title: "Add >", style: .Plain, target: nil, action: #selector(goToMapView))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        navigationbar.items = [navigationItem]
        
        view.addSubview(navigationbar)
        
    }



    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
