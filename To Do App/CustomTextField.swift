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
    var countLabel = UILabel()
    var lengthLimit = 0

    
    // MARK: - Initializers
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func drawRect(rect: CGRect) {
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    init(frame: CGRect, lengthLimit: Int) {
        super.init(frame: frame)
        self.lengthLimit = lengthLimit
        self.commonInit()
    }
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        self.lengthLimit = 20
        self.customString = placeholderText
        self.commonInit()
    }
    
    // MARK: - Custom Functions
    
    func commonInit() {
        
        if lengthLimit > 0 {
            setCountLabel()
        }
        
        delegate = self
        
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
    
    func setCountLabel() {
        rightViewMode = .Always
        countLabel = UILabel(frame: CGRect(x: frame.width - 50, y: 0, width: 50, height:
            30))
        countLabel.font?.fontWithSize(10)
        countLabel.textColor = UIColor.whiteColor()
        countLabel.textAlignment = .Left
        rightView = countLabel
        
        countLabel.text = initialCounterValue(self.text)
    }
    
    func initialCounterValue(text: String?) -> String {
        if let text = text {
            return "\(text.utf16.count)/\(lengthLimit)"
        } else {
            return "0/\(lengthLimit)"
        }
    }
    
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

extension CustomTextField: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text where lengthLimit != 0 else {
            return true
        }
        
        // string are characters You are about to add, range are character You have removed
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        if newLength <= lengthLimit {
            self.countLabel.text = "\(newLength)/\(lengthLimit)"
        } else {
            UIView.animateWithDuration(0.1, animations: {
                // 2
                self.countLabel.transform = CGAffineTransformMakeScale(1.1, 1.1)
                }, completion: { (finish) in
                    // 3
                    UIView.animateWithDuration(0.1) {
                        // 4
                        self.countLabel.transform = CGAffineTransformIdentity
                    }
            })
        }
        
        return newLength <= lengthLimit
    }
}