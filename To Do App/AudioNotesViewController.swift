//
//  AudioNotesViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

protocol AudioNotesDelegate {}

class AudioNotesViewController: UIViewController, UIMaker {
    
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
    var audioUrls: [NSManagedObject] = [NSManagedObject]()
    
    // MARK: - View State
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(messageLabel)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        tableDelegate = AudioNotesTableDelegate()

    }
    
    override func viewWillAppear(animated: Bool) {
        
        if !uiWasSet {
            setUI()
            uiWasSet = true
        }
        
        CoreDataFunctions.sharedInstance.getDataFromEntity("AudioNotes", managedObjects: &audioUrls)
        tableDatasource = AudioNotesDatasource(items: audioUrls, tableView: self.tableView, delegate: tableDelegate!)

        setMessageLabel(arrayToCount: audioUrls, messageLabel: messageLabel)
    }
    
    // MARK: - Custom Functions
    
    func setUI() {
        setView()
        setTableView(forTableView: tableView)
        setNavigationBar(forClassWithName: String(AudioNotesViewController.self))
    }
}

extension AudioNotesViewController: AudioNotesDelegate {


}