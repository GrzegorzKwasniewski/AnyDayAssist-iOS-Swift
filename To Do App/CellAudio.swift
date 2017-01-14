//
//  CellAudio.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 14/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class CellAudio: UITableViewCell {
    
    // MARK: - UI
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var audioNoteTitleLabel: UILabel!
    
    // MARK: - Custom Functions
    
    func configureCell(singleNote: NSManagedObject, cellImage: UIImage) {
        cellImageView.image = cellImage
        audioNoteTitleLabel.text = singleNote.valueForKey("audiotitle") as? String
    }
}
