//
//  TestViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class WeatherViewController: UIViewController, CurrentWeatherDataDelegate , UIAlertMaker, UIMaker {
    
    var currentWeatherData: CurrentWeatherData!

    var authorizationStatus:CLAuthorizationStatus!
    
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var descriptionOfWeather: UILabel!
    @IBOutlet var temperatureAverage: UILabel!
    @IBOutlet var temperatureMin: UILabel!
    @IBOutlet var temperatureMax: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var humidity: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(cityName2)
        
        currentWeatherData = CurrentWeatherData()
        currentWeatherData.delegete = self
        
        authorizationStatus = CLLocationManager.authorizationStatus()
        
        if Reachability.isConnectedToNetwork() == true {
        
            if authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse {
            
                showLoadingHUD()
            
                currentWeatherData.downloadWeatherData()
//            print(currentWeatherData.temperatureMax)
            
//            let convertedCityName = StringFormatting.removeSpecialCharsFromString(userCityName)
//            
//            let properURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(convertedCityName)&units=metric&APPID=8ecab5fd503cc5a1f3801625138a85d5")

//                            
//                            dispatch_async(dispatch_get_main_queue()) {
//                                
//                                 self.showAlert(withTitle: "There were some problems with accessing data", withMessage: "Try again in few seconds")
//                            }
//                        }
//                    }
//                    
//                    dispatch_async(dispatch_get_main_queue()) {
//                        
//                        self.hideLoadingHUD()
//                        
//                        self.weatherIcon.image = UIImage(named: self.setWeatherDescription)
//                        self.cityName.text = self.city
//                        self.descriptionOfWeather.text = self.setWeatherDescription
//                        self.temperatureAverage.text = "\(self.setTemperatureAverage)°C"
//                        self.temperatureMin.text = "\(self.setTemperatureMin)°C"
//                        self.temperatureMax.text = "\(self.setTemperatureMax)°C"
//                        self.pressure.text = "\(self.setPressure) mb"
//                        self.windSpeed.text = "\(self.setWindSpeed) km h"
//                        self.humidity.text = "\(self.setHumidity) %"
//                        
//                    }
//                    
//                }
//                
//                task.resume()
            
//            } else {
//                
//                self.hideLoadingHUD()
//                
//                let alert = UIAlertController(title: "There's no data for such City", message: "Don't put any special signs when typing city name", preferredStyle: .Alert)
//                alert.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//            }
            
            
        } else {
            
            hideLoadingHUD()
            
            showAlertForChangingSettings(withTitle: "Can't get weather data", withMessage: "Application don't have proper permissions")

            }
            
        } else {
            
            showAlert(withTitle: "You don't have internet connection", withMessage: "Check Your settings")
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUI()
        
    }
    
    func updateUI() {
        
        self.hideLoadingHUD()
        
        self.weatherIcon.image = UIImage(named: currentWeatherData.weatherDescription)
        self.cityName.text = currentWeatherData.cityName
        self.descriptionOfWeather.text = currentWeatherData.weatherDescription
        self.temperatureAverage.text = "\(currentWeatherData.currentTemp)°C"
        self.temperatureMin.text = "\(currentWeatherData.temperatureMin)°C"
        self.temperatureMax.text = "\(currentWeatherData.temperatureMax)°C"
        self.pressure.text = "\(currentWeatherData.pressure) mb"
        self.windSpeed.text = "\(currentWeatherData.windSpeed) km h"
        self.humidity.text = "\(currentWeatherData.humidity) %"
    }
    
    func setUI() {
        
        setView()
        setNavigationBar(forClassWithName: String(WeatherViewController.self))
        
    }
}
