//
//  RoundedView.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 27/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
    }
}
