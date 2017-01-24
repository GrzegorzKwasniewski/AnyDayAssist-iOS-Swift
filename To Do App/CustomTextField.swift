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
        button.addTarget(self, action: #selector(validateCityNameNotification), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    lazy var cancelCityValidation: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        button.setImage(UIImage(named: "stop"), forState: .Normal)
        button.addTarget(self, action: #selector(cancelCityValidationNotification), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    @IBInspectable var fieldForCityName: Bool = false
    @IBInspectable var customString: String = ""
    
    
    // MARK: - Properties
    
    var textFont = UIFont(name: "Avenir Book", size: 14.0)
    
    // MARK: - Initializers
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func drawRect(rect: CGRect) {
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        self.customString = placeholderText
        self.commonInit()
    }
    
    // MARK: - Custom Functions
    
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
            self.leftView = cancelCityValidation
            self.rightViewMode = .Always;
            self.leftViewMode = .Always
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
    
    func validateCityNameNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName("validateCityName", object: nil)
    }
    
    func cancelCityValidationNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName("cancelCityValidation", object: nil)
    }
}