//
//  CustomScrollView.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 09/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    // MARK: - UI
    
    @IBInspectable var insetByY: CGFloat = 0
    @IBInspectable var insetByX: CGFloat = 0
    @IBInspectable var tintCol: UIColor = UIColor.whiteColor()
    @IBInspectable var fontCol: UIColor = UIColor.whiteColor()
    @IBInspectable var shadowCol: UIColor = UIColor.darkGrayColor()
    
    // MARK: - Properties
    
    var textFont = UIFont(name: "Avenir Book", size: 14.0)
    
    // MARK: - Initializers
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.commonInit()
    }
    
    func commonInit() {
        self.text = "additinal notes"
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 3.0
        self.tintColor = UIColor.whiteColor()
        self.textColor = UIColor.whiteColor()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        if let fnt = textFont {
            self.font = fnt
        } else {
            self.font = UIFont(name: "Helvetica Neue", size: 14.0)
        }
    }
    
    // MARK: - Layout Functions
    
    override func setNeedsLayout() {
        self.backgroundColor = UIColor.clearColor()
    }
}
