//
//  CustomTextField.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 08/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    
    // MARK: - IBInspectable
    @IBInspectable var customString: String = ""
    @IBInspectable var insetByY: CGFloat = 0
    @IBInspectable var insetByX: CGFloat = 0
    @IBInspectable var tintCol: UIColor = UIColor.blueColor()
    @IBInspectable var fontCol: UIColor = UIColor.whiteColor()
    @IBInspectable var shadowCol: UIColor = UIColor.darkGrayColor()
    
    
    // MARK: - Properties
    var textFont = UIFont(name: "Avenir Book", size: 14.0)
    
    override func drawRect(rect: CGRect) {
        
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 3.0
        self.tintColor = tintCol
        self.textColor = fontCol
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        self.attributedPlaceholder = NSAttributedString(string: customString, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        

        if let fnt = textFont {
            self.font = fnt
        } else {
            self.font = UIFont(name: "Helvetica Neue", size: 14.0)
        }
    }
    
    // Placeholder text
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetByX, dy: insetByY)
    }
    
    // Editable text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetByX, dy: insetByY)
    }
}
