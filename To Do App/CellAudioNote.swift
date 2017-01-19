//
//  CellAudioNote.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 18/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class CellAudioNote: UITableViewCell {
    
    // MARK: - UI
    
    @IBOutlet weak var audioNoteTitle: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    // MARK: - Initializers
    
    override func awakeFromNib() {
        
    }

    
    // MARK: - Custom Functions
    
    func configureCell(singleNote: NSManagedObject, cellImage: UIImage) {
        cellImageView.image = cellImage
        audioNoteTitle.text = singleNote.valueForKey("audiotitle") as? String
    }
}
