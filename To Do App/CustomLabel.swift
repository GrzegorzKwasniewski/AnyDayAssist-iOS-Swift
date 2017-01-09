//
//  CustomTextLabel.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 09/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    // MARK: - Properties
    var textFont = UIFont(name: "Avenir Book", size: 9.0)
    
    override func drawRect(rect: CGRect) {
//        self.text = "Priority of task"
        self.textAlignment = .Center
        self.textColor = UIColor.redColor()
        //self.minimumScaleFactor = 0.0
        //                self.layer.cornerRadius = 3.0
        //                self.layer.borderWidth = 1
        //                self.layer.borderColor = UIColor.grayColor().CGColor

    }
}
