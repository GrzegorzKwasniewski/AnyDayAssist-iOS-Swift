//
//  WeatherData.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 05/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeatherData {
    
    weak var delegate = CurrentWeatherDataDelegate?()

    var _cityName: String!
    var _weatherDescription: String!
    var _currentTemp: String!
    var _temperatureMin: String!
    var _temperatureMax: String!
    var _humidity: String!
    var _pressure: String!
    var _windSpeed: String!
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
    
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = "0.0"
        }
        return _currentTemp
    }
    
    var temperatureMin: String {
        if _temperatureMin == nil {
            _temperatureMin = "0.0"
        }
        return _temperatureMin
    }
    
    var temperatureMax: String {
        if _temperatureMax == nil {
            _temperatureMax = "0.0"
        }
        return _temperatureMax
    }
    
    var humidity: String {
        if _humidity == nil {
            _humidity = "0"
        }
        return _humidity
    }
    
    var pressure: String {
        if _pressure == nil {
            _pressure = "0"
        }
        return _pressure
    }
    
    var windSpeed: String {
        if _windSpeed == nil {
            _windSpeed = "0"
        }
        return _windSpeed
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
    
    func downloadWeatherData(forCity city: String) {
        let string = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&APPID=8ecab5fd503cc5a1f3801625138a85d5"
        let weatherUrl = NSURL(string: string)!
        Alamofire.request(.GET, weatherUrl).responseJSON { (response) in
//            print("REQUEST \(response.request)")  // original URL request
//            print("RESPONSE \(response.response)") // URL response
//            print("DATA \(response.data)")     // server data
//            print("RESULT \(response.result)")   // result of response serialization
            
            if let JSONDictionary = response.result.value as? Dictionary<String, AnyObject> {
                
                // if there is no data for city with given name
                if let codeError = JSONDictionary["cod"] as? String {
                    // update UI without any data
                    self._cityName = "Such city don't exists"
                    self.delegate?.updateUI()
                }
                
                guard let weather = JSONDictionary["weather"] as? [Dictionary<String, AnyObject>],
                      let main = weather[0]["main"] as? String
                      else { return }
                self._weatherDescription = main.capitalizedString
                
                guard let getWindData = JSONDictionary["wind"] as? Dictionary<String, AnyObject> ,
                      let getWindSpeed = getWindData["speed"] as? Double
                      else { return }
                self._windSpeed = String(getWindSpeed)
                
                if let cityName = JSONDictionary["name"] as? String {
                    self._cityName = cityName.capitalizedString
                }
                
                if let mainData = JSONDictionary["main"] as? Dictionary<String, AnyObject> {
                    if let getTemperatureAverage = mainData["temp"] as? Double {
                        self._currentTemp = String(getTemperatureAverage)
                    }
                    
                    if let getTemperatureMin = mainData["temp_min"] as? Double {
                        self._temperatureMin = String(getTemperatureMin)
                    }
                    
                    if let getTemperatureMin = mainData["temp_max"] as? Double {
                        self._temperatureMax = String(getTemperatureMin)
                    }
                    
                    if let getPressure = mainData["pressure"] as? Int {
                        self._pressure = String(getPressure)
                    }
                    
                    if let getHumidity = mainData["humidity"] as? Int {
                        self._humidity = String(getHumidity)
                    }
                }
            }
            
            self.delegate?.updateUI()
            
        }
    }
}

