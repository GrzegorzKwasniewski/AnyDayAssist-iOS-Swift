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
    
    @IBOutlet var tableView: UITableView!
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
        

        
        currentWeatherData = CurrentWeatherData()
        currentWeatherData.delegete = self
        
        authorizationStatus = CLLocationManager.authorizationStatus()
        
        if Reachability.isConnectedToNetwork() == true {
        
            if authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse {
            
                showLoadingHUD()
            
                currentWeatherData.downloadWeatherData()

            
            
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
