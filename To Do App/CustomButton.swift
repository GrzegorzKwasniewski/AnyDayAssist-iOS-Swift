//
//  CustomButton.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 11/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    // MARK: - Properties
    
    enum Action {
        case Save
        case Delete
    }
    
    var actionToTake: Action = .Save
    
    // MARK: - Initializers
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    init(bgColor: UIColor, forAction action: Action) {
        super.init(frame: .zero)
        self.backgroundColor = bgColor
        self.actionToTake = action
        self.commonInit()
    }
    
    // MARK - Custom functions
    
    func commonInit() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.opacity = 0.9
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.addTarget(self, action: #selector(postNotification), forControlEvents: UIControlEvents.TouchUpInside)
        
        setTitle()
    }
    
    func setTitle() {
        
        switch actionToTake {
        case .Save:
            self.setTitle("Save", forState: .Normal)
            self.setTitleColor(UIColor(red: 0, green: 128/255, blue: 1, alpha: 1), forState: .Normal)
        case .Delete:
            self.setTitle("Delete", forState: .Normal)
            self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
    }
    
    func setProperties(borderWidth: Float, borderColor: UIColor) {
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.CGColor
    }
    
    // MARK: - Notifications
    
    func postNotification() {
        
        switch actionToTake {
        case .Save:
            CustomButton.postNotification(.saveNote)
        case .Delete:
            CustomButton.postNotification(.deleteNote)
        }
    }
}

extension CustomButton: Notifier {


}
