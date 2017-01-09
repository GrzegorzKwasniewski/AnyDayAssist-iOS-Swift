//
//  ForecastWeatherData.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 06/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import Alamofire

class ForecastWeatherData {
    
    weak var delegate: ForecastWeatherDataDelegate?

    func downloadWeatherData(forCity city: String) {
        forecasts = []
        let formatedCityName = StringHelperClass.removeSpecialCharsFromString(city)
        let weatherUrl = "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(formatedCityName)&units=metric&cnt=7&APPID=8ecab5fd503cc5a1f3801625138a85d5"
        if let weatherUrl = NSURL(string: weatherUrl) {
            Alamofire.request(.GET, weatherUrl).responseJSON { (response) in
                if let JSONDictionary = response.result.value as? Dictionary<String, AnyObject> {
                    // if there is no data for city with given name
                    if let codeError = JSONDictionary["cod"] as? String {
                        // update UI without any data
                        self.delegate?.updateTableCell()
                    }
                    
                    if let forecastList = JSONDictionary["list"] as? [Dictionary<String, AnyObject>] {
                        for dayForecast in forecastList {
                            let singleDayForecast = SingleDayForecast(forecastDictionary: dayForecast)
                            forecasts.append(singleDayForecast)
                            self.delegate?.updateTableCell()
                        }
                    }
                }
            }
        }
    }
}

class SingleDayForecast {
    
    var _cityName: String!
    var _weatherDescription: String!
    var _temperatureMin: String!
    var _temperatureMax: String!
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
    
    var date: String {
        if _date == nil {
            _date = "0.0"
        }
        return _date
    }
    
    
    init(forecastDictionary dictionary: Dictionary<String, AnyObject>) {
        if let main = dictionary["temp"] as? Dictionary<String, AnyObject> {
            if let tempMin = main["min"] as? Double {
                self._temperatureMin = String(tempMin)
            }
            
            if let tempMax = main["max"] as? Double {
                self._temperatureMax = String(tempMax)
            }
        }
        
        guard let description = dictionary["weather"] as? [Dictionary<String, AnyObject>],
              let main = description[0]["main"] as? String
              else { return }
        
            self._weatherDescription = main.capitalizedString
        
        if let date = dictionary["dt"] as? Double {
            let unixConvertedDay = NSDate(timeIntervalSince1970: date)
            let dateFormater = NSDateFormatter()
            dateFormater.dateStyle = .NoStyle
            dateFormater.timeStyle = .MediumStyle
            self._date = dateFormater.stringFromDate(unixConvertedDay)        
        }
    }
}
