//
//  Places.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 19/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

final class PlacesDatasource: NSObject, ItemsTableViewDatasource {
    
    var items: [NSManagedObject]
    weak var tableView: UITableView?
    weak var delegate: UITableViewDelegate?
    
    required init(items: [NSManagedObject], tableView: UITableView, delegate: UITableViewDelegate) {
        self.items = items
        self.tableView = tableView
        self.delegate = delegate
        super.init()
        let bundle = NSBundle(forClass: self.dynamicType)
        let cellNib = UINib(nibName: String(CellPlace.self), bundle: bundle)
        tableView.registerNib(cellNib, forCellReuseIdentifier: String(CellPlace.self))
        self.setupTableView()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCellWithIdentifier(String(CellPlace.self), forIndexPath: indexPath) as? CellPlace {
            
            let textNote = items[indexPath.row]
            myCell.configureCell(textNote, cellImage: UIImage(named: "place")!)
            return myCell
            
        } else {
            return CellPlace()
        }
    }
}

class PlacesTableDelegate: NSObject, UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.6)
        let singlePlace = indexPath.row
        NSNotificationCenter.defaultCenter().postNotificationName("showPlace", object: singlePlace)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clearColor()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clearColor()
    }
}
