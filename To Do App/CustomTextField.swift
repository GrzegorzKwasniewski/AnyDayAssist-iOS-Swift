//
//  CustomTextField.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 08/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    // MARK: - UI
    
    lazy var validateCityName: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        button.setImage(UIImage(named: "play"), forState: .Normal)
        button.addTarget(self, action: #selector(postNotification), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    @IBInspectable var fieldForCityName: Bool = false
    @IBInspectable var customString: String = ""
    
    
    // MARK: - Properties
    
    var textFont = UIFont(name: "Avenir Book", size: 14.0)
    
    // MARK: - Initializers
    
    override func drawRect(rect: CGRect) {
        self.commonInit()
    }
    
    func commonInit() {
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 3.0
        self.tintColor = UIColor.whiteColor()
        self.textColor = UIColor.whiteColor()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.attributedPlaceholder = NSAttributedString(string: customString, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        if fieldForCityName {
            self.rightView = validateCityName;
            self.rightViewMode = .Always;
        }
        
        if let fnt = textFont {
            self.font = fnt
        } else {
            self.font = UIFont(name: "Helvetica Neue", size: 14.0)
        }
    }
    
    // MARK: - Custom Functions

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    // MARK: - Notifications
    
    func postNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName("validateCityName", object: nil)
    }
}
