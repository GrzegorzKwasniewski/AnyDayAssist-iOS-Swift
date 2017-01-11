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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        self.textColor = UIColor.redColor()
        self.font = textFont
        self.textAlignment = .Center
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.opacity = 0.9
        //self.setProperties(1.0, borderColor:UIColor.blackColor())
    }
    
    func setProperties(borderWidth: Float, borderColor: UIColor) {
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.CGColor
    }
}
