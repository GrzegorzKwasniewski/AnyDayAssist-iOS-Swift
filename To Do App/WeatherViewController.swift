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

class WeatherViewController: UIViewController, CurrentWeatherDataDelegate, ForecastWeatherDataDelegate, UIAlertMaker, UIMaker, UITableViewDelegate, UITableViewDataSource {
    
    var currentWeatherData: CurrentWeatherData!
    var forecastWeatherData: ForecastWeatherData!

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
        
        print(forecasts.count)
        setSmallTableView(forTableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeatherData = CurrentWeatherData()
        currentWeatherData.delegate = self
        
        forecastWeatherData = ForecastWeatherData()
        forecastWeatherData.delegate = self
        
        authorizationStatus = CLLocationManager.authorizationStatus()
        
        if Reachability.isConnectedToNetwork() == true {
        
            if authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse {
            
                showLoadingHUD()
            
                currentWeatherData.downloadWeatherData()
                forecastWeatherData.downloadWeatherData()

            
            
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? CellWeather {
            
            myCell.configureCell(forecasts[indexPath.row])
            return myCell
            
        } else {
        
            return CellWeather()
        
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
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
    
    func updateTableCell() {
    
        print(forecasts.count)

        tableView.reloadData()
    
    }
    
    func setUI() {
        
        setView()
        setNavigationBar(forClassWithName: String(WeatherViewController.self))
        
    }
}
