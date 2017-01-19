//
//  CellPlace2.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 19/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class CellPlace: UITableViewCell {
    
    // MARK: - UI
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var placeTitleLabel: UILabel!
    
    // MARK: - Custom Functions
    
    func configureCell(singleNote: NSManagedObject, cellImage: UIImage) {
        cellImageView.image = cellImage
        placeTitleLabel.text = singleNote.valueForKey("title") as? String
    }
}
