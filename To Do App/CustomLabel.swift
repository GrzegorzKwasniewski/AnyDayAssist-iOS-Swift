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
    
    var textFont = UIFont(name: "Avenir Book", size: 18.0)
    
    // MARK: - Initializers
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        self.commonInit()
    }
    
    // MARK: - Custom Functions
    
    func commonInit() {
        self.textColor = UIColor.redColor()
        self.font = textFont
        self.textAlignment = .Center
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.opacity = 0.9
    }
    
    func setProperties(borderWidth: Float, borderColor: UIColor) {
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.CGColor
    }
}
