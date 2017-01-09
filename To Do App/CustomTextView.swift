//
//  CustomScrollView.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 09/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    // MARK: - IBInspectable
    @IBInspectable var insetByY: CGFloat = 0
    @IBInspectable var insetByX: CGFloat = 0
    @IBInspectable var tintCol: UIColor = UIColor.whiteColor()
    @IBInspectable var fontCol: UIColor = UIColor.whiteColor()
    @IBInspectable var shadowCol: UIColor = UIColor.darkGrayColor()
    
    
    // MARK: - Properties
    var textFont = UIFont(name: "Helvetica Neue", size: 14.0)
    
    override func drawRect(rect: CGRect) {
        
        self.text = "additinal notes"
        self.textContainerInset = UIEdgeInsets(top: insetByY, left: insetByX, bottom: insetByY, right: insetByX)
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.redColor()
        self.layer.cornerRadius = 3.0
        self.tintColor = tintCol
        self.textColor = fontCol
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        if let fnt = textFont {
            self.font = fnt
        } else {
            self.font = UIFont(name: "Helvetica Neue", size: 14.0)
        }
    }
}
