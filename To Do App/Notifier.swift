//
//  Notifier.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 28/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import Foundation

enum Notification: String {
    
    case saveNote
    case deleteNote
}

public protocol Notifier {
    
    //associatedtype Notification: RawRepresentable
    
}

extension Notifier {
    
    private static func nameFor(notifiacation: Notification) -> String {
        
        return "\(notifiacation.rawValue)"
        
    }
    
    static func addObserver(observer: AnyObject, selector: Selector, notification: Notification) {
        let name = nameFor(notification)
        
        NSNotificationCenter.defaultCenter()
            .addObserver(observer, selector: selector, name: name, object: nil)
    }
        
    static func postNotification(notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
        
        let name = nameFor(notification)
        
        NSNotificationCenter.defaultCenter()
            .postNotificationName(name, object: object, userInfo: userInfo)
    }
    
    
    static func removeObserver(observer: AnyObject, notification: Notification, object: AnyObject? = nil) {
        
        let name = nameFor(notification)
            
        NSNotificationCenter.defaultCenter()
                .removeObserver(observer, name: name, object: object)
    }
}

