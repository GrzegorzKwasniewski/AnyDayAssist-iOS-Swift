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
        
        setObserverForChange()
        
        view.addSubview(messageLabel)

        tableDelegate = AudioNotesTableDelegate()

    }
    
    override func viewWillAppear(animated: Bool) {
        
        audioUrls = []
        
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
    
    // MARK: - Notifications
    
    func setObserverForChange() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(showAudioNoteDetailView(_:)),
            name: "showAudioNoteDetailView",
            object: nil)
        
    }
    
    // MARK: - View Transition
    
    func showAudioNoteDetailView(notification: NSNotification) {
        let singleAudioNoteNumber = notification.object as! NSInteger
        let singleAudioNote = audioUrls[singleAudioNoteNumber]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(String(AudioPlayBackViewController.self)) as! AudioPlayBackViewController
        controller.audioUrl = singleAudioNote
        
        controller.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(controller, animated: true, completion: nil)
    }
}



extension AudioNotesViewController: AudioNotesDelegate {


}