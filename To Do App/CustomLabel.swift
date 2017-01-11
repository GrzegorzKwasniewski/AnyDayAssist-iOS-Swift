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
        self.textColor = UIColor.whiteColor()
        self.font = textFont
        self.textAlignment = .Center
        //self.layer.cornerRadius = self.bounds.width/2
        //self.clipsToBounds = true
        //self.setProperties(1.0, borderColor:UIColor.blackColor())
    }
    
    func setProperties(borderWidth: Float, borderColor: UIColor) {
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.CGColor
    }
}
