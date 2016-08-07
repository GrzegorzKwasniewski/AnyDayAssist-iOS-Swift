//
//  ForecastWeatherData.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 06/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import Alamofire

var forecasts = [SingleDayForecast]()

class ForecastWeatherData {
    
    weak var delegate = ForecastWeatherDataDelegate?()

    func downloadWeatherData() {
        
        let weatherUrl = NSURL(string: FORECAST_WEATHER_URL)!
        Alamofire.request(.GET, weatherUrl).responseJSON { (response) in
            
            if let JSONDictionary = response.result.value as? Dictionary<String, AnyObject> {
            
                if let forecastList = JSONDictionary["list"] as? [Dictionary<String, AnyObject>] {
                
                    for dayForecast in forecastList {
                    
                        let singleDayForecast = SingleDayForecast(forecastDictiobary: dayForecast)
                        forecasts.append(singleDayForecast)
                        self.delegate?.updateTableCell()
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
    
    
    init(forecastDictiobary dictionary: Dictionary<String, AnyObject>) {
    
        if let main = dictionary["main"] as? Dictionary<String, AnyObject> {
        
            if let tempMin = main["temp_min"] as? Double {
            
                self._temperatureMin = String(tempMin)
                
            }
            
            if let tempMax = main["temp_max"] as? Double {
            
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
            dateFormater.dateStyle = .FullStyle
            dateFormater.dateFormat = "EEEE"
            dateFormater.timeStyle = .NoStyle
            self._date = dateFormater.stringFromDate(unixConvertedDay)
        
        }
    }
}
