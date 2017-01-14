//
//  CustomDatePicker.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 14/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class CustomDatePicker: UIDatePicker {
    
    // MARK: - Initializers
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.commonInit()
    }
    
    // MARK: - Custom Functions
    
    func commonInit() {
    }
    
    // MARK: - Layout Functions
    
    override func setNeedsLayout() {
        self.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        self.setValue(false, forKey: "highlightsToday")
    }
    
    override func setNeedsDisplay() {
        self.backgroundColor = UIColor.clearColor()
    }
}
