//
//  WeatherData.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 05/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import Alamofire

class WeatherData {

    var _cityName: String!
    var _weatherDescription: String!
    var _currentTemp: Double!
    var _date: String!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var weatherDescription: String {
        if _weatherDescription == nil {
            _weatherDescription = ""
        }
        return _weatherDescription
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = .LongStyle
        dateFormater.timeStyle = .NoStyle
        let currentDate = dateFormater.dateFromString(String(NSDate()))
        _date = "Today is \(currentDate)"
        
        return _date
    }
}
