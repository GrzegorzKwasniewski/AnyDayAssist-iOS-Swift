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
    
    lazy var messageLabel: UILabel = {
        let ml = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
        return ml
    }()
    
    // MARK: Properties
    
    var uiWasSet = false
    var tableDatasource: TextNotesDatasource?
    var tableDelegate: TextNotesTableDelegate?
    var textNotes: [NSManagedObject] = [NSManagedObject]()
    
    // MARK - View State
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObserverForChange()
        
        view.addSubview(messageLabel)
        tableDelegate = TextNotesTableDelegate()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        textNotes = []
        
        if !uiWasSet {
            
            setUI()
            uiWasSet = true
            
        }
        
        CoreDataFunctions.sharedInstance.getDataFromEntity("Notes", managedObjects: &textNotes)
        tableDatasource = TextNotesDatasource(items: textNotes, tableView: self.tableView, delegate: tableDelegate!)
        setMessageLabel(arrayToCount: textNotes, messageLabel: messageLabel)
        
    }
    
    // MARK: - Custom Functions
    
    func setUI() {
        
        setView()
        setTableView(forTableView: tableView)
        setNavigationBar(forClassWithName: String(TextNotesViewController.self))
        
    }
    
    // MARK: - Notifications
    
    func setObserverForChange() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(showNoteDetailView(_:)),
            name: "showNoteDetailView",
            object: nil)
        
    }
    
    // MARK: - View Transition
    
    func showNoteDetailView(notification: NSNotification) {
        let singleNoteNumber = notification.object as! NSInteger
        let singleNote = textNotes[singleNoteNumber]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(String(TextNoteDetailViewController.self)) as! TextNoteDetailViewController
        controller.singleNote = singleNote

        controller.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(controller, animated: true, completion: nil)
    }
}