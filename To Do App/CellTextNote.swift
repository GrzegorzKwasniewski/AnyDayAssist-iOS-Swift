//
//  CellTextNotes.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 19/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class CellTextNote: UITableViewCell {
    
    // MARK: - UI
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    // MARK: - Initializers

    override func awakeFromNib() {
        
    }
    
    // MARK: - Custom Functions
    
    func configureCell(singleNote: NSManagedObject, cellImage: UIImage) {
        cellImageView.image = cellImage
        noteTitleLabel.text = singleNote.valueForKey("note") as? String
        priorityLabel.text = singleNote.valueForKey("priority") as? String
        dueDateLabel.text = singleNote.valueForKey("dueDate") as? String
    }
}