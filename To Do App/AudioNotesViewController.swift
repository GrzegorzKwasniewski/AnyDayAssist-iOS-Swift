//
//  AudioNotesViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

protocol AudioNotesDelegate {
}

class AudioNotesViewController: UIViewController, AudioNotesDelegate, UIMaker {
    
    // MARK: - UI
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var messageLabel: UILabel = {
        let ml = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
        return ml
    }()
    
    // MARK: - Properties
    
    var uiWasSet = false
    var messageLabelWasSet = false
    var tableDatasource: AudioNotesDatasource?
    var tableDelegate: AudioNotesTableDelegate?
    
    // MARK: - View State
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(messageLabel)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        CoreDataFunctions.sharedInstance.getDataFromEntity("AudioNotes", managedObjects: &audioURL)
        tableDelegate = AudioNotesTableDelegate(self)
        tableDatasource = AudioNotesDatasource(items: audioURL, tableView: self.tableView, delegate: tableDelegate!)
    }
    
    override func viewWillAppear(animated: Bool) {
        if !uiWasSet {
            setUI()
            uiWasSet = true
        }
        CoreDataFunctions.sharedInstance.getDataFromEntity("AudioNotes", managedObjects: &audioURL)
        tableView.reloadData()
        setMessageLabel(arrayToCount: audioURL, messageLabel: messageLabel)
    }
    
    // MARK: - Custom Functions
    
    func setUI() {
        setTableView(forTableView: tableView)
        setNavigationBar(forClassWithName: String(AudioNotesViewController.self))
    }
}