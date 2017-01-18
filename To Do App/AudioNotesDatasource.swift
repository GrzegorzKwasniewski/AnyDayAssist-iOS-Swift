//
//  AudioNotesDatasource.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 18/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

final class AudioNotesDatasource: NSObject, ItemsTableViewDatasource {
    
    var items: [NSManagedObject]
    weak var tableView: UITableView?
    weak var delegate: UITableViewDelegate?
    
    required init(items: [NSManagedObject], tableView: UITableView, delegate: UITableViewDelegate) {
        self.items = items
        self.tableView = tableView
        self.delegate = delegate
        super.init()
        let bundle = NSBundle(forClass: self.dynamicType)
        let cellNib = UINib(nibName: "CellAudioNote", bundle: bundle)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "CellAudioNote")
        //tableView.registerClass(CellAudioNote.self, forCellReuseIdentifier: "CellAudioNote")
        self.setupTableView()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCellWithIdentifier("CellAudioNote", forIndexPath: indexPath) as? CellAudioNote {
            
            let audioNote = items[indexPath.row]
            myCell.configureCell(audioNote, cellImage: UIImage(named: "microphone")!)
            return myCell
            
        } else {
            return CellAudioNote()
        }
    }
}

class AudioNotesTableDelegate: NSObject, UITableViewDelegate {
    
    let delegate: AudioNotesDelegate
    
    init(_ delegate: AudioNotesDelegate) {
        self.delegate = delegate
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let singleAudio = audioURL[indexPath.row]
            let audioTitle = singleAudio.valueForKey("audiourl") as! String
            CoreDataFunctions.sharedInstance.removeFromEntity("AudioNotes" , title: audioTitle, predicateFormat: "audiourl == %@")
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CellNote.height()
//    }
}