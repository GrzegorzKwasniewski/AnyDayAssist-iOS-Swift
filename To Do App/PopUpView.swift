//
//  PopUpView.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 08/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class PopUpView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.opacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
    }
    
}
