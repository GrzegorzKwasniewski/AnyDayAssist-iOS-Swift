//
//  CustomStackView.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 14/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class CustomStackView: UIStackView {

    // MARK: - Properties
    
    
    // MARK: - Initializers
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    init(addViews views: [UIView], withSpacing spacing: CGFloat) {
        super.init(frame: .zero)
        views.forEach({self.addArrangedSubview($0)})
        self.spacing = spacing
        commonInit()
        
    }
    
    // MARK - Custom functions
    
    func commonInit() {
        axis = .Horizontal
        distribution = .FillEqually
    }
}
