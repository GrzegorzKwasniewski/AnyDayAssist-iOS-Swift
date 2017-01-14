//
//  FirstViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/05/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class TextNotesViewController: UIViewController, UIMaker {
    
    // MARK - UI
    
    @IBOutlet weak var tableView: UITableView!
    
    var uiWasSet = false
    lazy var messageLabel: UILabel = {
        let ml = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
        return ml
    }()
    
    // MARK - View State
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(messageLabel)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        toDoNotes = []
        
        if !uiWasSet {
            
            setUI()
            uiWasSet = true
            
        }
        
        globalCoreDataFunctions.getDataFromEntity("Notes", managedObjects: &toDoNotes)
        tableView.reloadData()
        setMessageLabel(arrayToCount: toDoNotes, messageLabel: messageLabel)
        
    }
    
    // MARK: - Custom Functions
    
    func setUI() {
        
        setTableView(forTableView: tableView)
        setNavigationBar(forClassWithName: String(TextNotesViewController.self))
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "noteDetail" {
            if let noteDetail = segue.destinationViewController as? TextNoteDetailViewController {
                if let singleNote = sender as? NSManagedObject {
                    noteDetail.singleNote = singleNote
                }
            }
        }
    }
}

    // MARK: - TableView Functions

extension TextNotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return toDoNotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? CellNote {
            
            let singleNote = toDoNotes[indexPath.row]
            myCell.configureCell(singleNote, cellImage: UIImage(named: "notes")!)
            return myCell
            
        } else {
            
            return CellNote()
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(white: 100, alpha: 0.5)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let singleNote = toDoNotes[indexPath.row]
        performSegueWithIdentifier("noteDetail", sender: singleNote)
    }
}
