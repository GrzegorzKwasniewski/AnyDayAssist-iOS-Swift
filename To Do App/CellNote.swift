//
//  TableViewCell.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class CellNote: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    func configureCell(singleNote: NSManagedObject, cellImage: UIImage) {
        cellImageView.image = cellImage
        noteTitleLabel.text = singleNote.valueForKey("note") as? String
        priorityLabel.text = singleNote.valueForKey("priority") as? String
        dueDateLabel.text = singleNote.valueForKey("dueDate") as? String
    }
}
