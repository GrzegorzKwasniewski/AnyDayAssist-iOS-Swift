//
//  PlacesViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 12/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class PlacesViewController: UIViewController, UIMaker {
    
    // MARK: - UI
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var messageLabel: UILabel = {
        let ml = UILabel(frame: CGRectMake(0 , 0, self.view.bounds.size.width, self.view.bounds.size.height))
        return ml
    }()
    
    // MARK: - Properties
    
    var uiWasSet = false
    var messageLabelWasSet = false
    var tableDatasource: PlacesDatasource?
    var tableDelegate: PlacesTableDelegate?
    var places: [NSManagedObject] = [NSManagedObject]()
    
    // MARK: - View State

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObserverForChange()
        
        view.addSubview(messageLabel)
        tableDelegate = PlacesTableDelegate()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
    }
    
    override func viewWillAppear(animated: Bool) {
        if !uiWasSet {
            setUI()
            uiWasSet = true
        }
        
        CoreDataFunctions.sharedInstance.getDataFromEntity("Places", managedObjects: &places)
        tableDatasource = PlacesDatasource(items: places, tableView: self.tableView, delegate: tableDelegate!)
        setMessageLabel(arrayToCount: places, messageLabel: messageLabel)
    }
    
    // MARK: - Custom Functions
    
    func setUI() {
        
        setView()
        setTableView(forTableView: tableView)
        setNavigationBar(forClassWithName: String(PlacesViewController.self))
        
    }
    
    // MARK: - Notifications
    
    func setObserverForChange() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(showPlace(_:)),
            name: "showPlace",
            object: nil)
        
    }
    
    // MARK: - View Transition
    
    func showPlace(notification: NSNotification) {
        let singlePlaceNumber = notification.object as! NSInteger
        let singlePlacee = places[singlePlaceNumber]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(String(MapViewController.self)) as! MapViewController
        controller.singlePlace = singlePlacee
        
        controller.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(controller, animated: true, completion: nil)
    }
}