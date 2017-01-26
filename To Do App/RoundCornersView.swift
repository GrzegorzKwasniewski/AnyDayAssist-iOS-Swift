//
//  RoundCornersView.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 26/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
            self.clipsToBounds = newValue > 0
        }
    }
}
