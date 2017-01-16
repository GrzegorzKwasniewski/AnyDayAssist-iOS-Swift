//
//  LocalNotifications.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 16/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class LocalNotifications {

    static let sharedInstance = LocalNotifications()
    
    func setLocalNotification(withDate date: NSDate, withTitle title: String, withBody body: String) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.applicationIconBadgeNumber = 0
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.alertTitle = title
        localNotification.alertBody = body
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }

}
