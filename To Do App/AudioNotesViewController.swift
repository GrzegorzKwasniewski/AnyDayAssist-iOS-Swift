//
//  AudioNotesViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class AudioNotesViewController: UIViewController, UIMaker {
    
    // MARK: - UI
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var uiWasSet = false
    var messageLabelWasSet = false
    var messageLabel: UILabel = UILabel()
    
    // MARK: - View State
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        messageLabel = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
    }
    
    override func viewWillAppear(animated: Bool) {
        if !uiWasSet {
            setUI()
            uiWasSet = true
        }
        globalCoreDataFunctions.getDataFromEntity("AudioNotes", managedObjects: &audioURL)
        tableView.reloadData()
        setMessageLabel(arrayToCount: audioURL, messageLabel: messageLabel)
    }
    
    // MARK: - Custom Functions
    
    func setUI() {
        setTableView(forTableView: tableView)
        setNavigationBar(forClassWithName: String(AudioNotesViewController.self))
    }
}

    // MARK: - TableView Functions

extension AudioNotesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioURL.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? CellAudio {
            
            let audioNote = audioURL[indexPath.row]
            myCell.configureCell(audioNote, cellImage: UIImage(named: "microphone")!)
            return myCell
            
        } else {
            return CellAudio()
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
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
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(white: 100, alpha: 0.3)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clearColor()
    }
}