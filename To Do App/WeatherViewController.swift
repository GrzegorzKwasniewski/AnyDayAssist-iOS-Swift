//
//  WeatherViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class WeatherViewController: UIViewController, UIAlertMaker, UIMaker {
    
    // MARK: UI
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var descriptionOfWeather: UILabel!
    @IBOutlet weak var temperatureAverage: UILabel!
    @IBOutlet weak var temperatureMin: UILabel!
    @IBOutlet weak var temperatureMax: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var cloudImage1: UIImageView!
    @IBOutlet weak var cloudImage2: UIImageView!
    @IBOutlet weak var cloudImage3: UIImageView!
    @IBOutlet weak var cloudImage4: UIImageView!
    
    // MARK: - Properties
    
    var currentWeatherData: CurrentWeatherData = CurrentWeatherData()
    var forecastWeatherData: ForecastWeatherData = ForecastWeatherData()
    var authorizationStatus:CLAuthorizationStatus!
    var locationManager = LocationManager()
    
    // MARK: - View State
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObserverForChange()
        
        tableView.delegate = self
        tableView.dataSource = self
        currentWeatherData.delegate = self
        forecastWeatherData.delegate = self
        authorizationStatus = CLLocationManager.authorizationStatus()
        
        if weatherFromUserLocation && authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        showLoadingHUD()
        setUI()
        animateCloud(cloudImage1.layer)
        animateCloud(cloudImage2.layer)
        animateCloud(cloudImage3.layer)
        animateCloud(cloudImage4.layer)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        checkForAuthorisationStatus()
        downloadWeatherData()
        
    }
    
    // MARK: - Custom Functions
    
    func setUI() {
        
        setView()
        setSmallTableView(forTableView: tableView)
        setNavigationBar(forClassWithName: String(WeatherViewController.self))
        
    }

    func checkForAuthorisationStatus() {
        if weatherFromUserLocation && authorizationStatus == CLAuthorizationStatus.Denied {
            hideLoadingHUD()
            showAlertForChangingSettings(withTitle: "Can't get weather data", withMessage: "Application don't have proper permissions")
        }
    }
    
    func downloadWeatherData() {
        if Reachability.isConnectedToNetwork() == true {
            if weatherFromUserLocation == true {
                weatherFromUserLocation = false
                currentWeatherData.downloadWeatherData(forCity: userLoactionCityName)
                forecastWeatherData.downloadWeatherData(forCity: userLoactionCityName)
            } else {
                currentWeatherData.downloadWeatherData(forCity: userCityName)
                forecastWeatherData.downloadWeatherData(forCity: userCityName)
            }
            hideLoadingHUD()
        } else {
            hideLoadingHUD()
            showAlert(withTitle: "You don't have internet connection", withMessage: "Check Your settings")
        }
    }
    
    func failedToGetUserLocation(notification: NSNotification) {
        self.showAlert(withTitle: "Something went wrong", withMessage: "Can't get weather data")
    }
    
    // MARK: - Notifications
    
    func setObserverForChange() {
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(WeatherViewController.failedToGetUserLocation(_:)),
            name: "failedToGetUserLocation",
            object: nil)
        
    }
}

    // MARK: - TableView Functions

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
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
}

    // MARK: - Current Weather

extension WeatherViewController: CurrentWeatherDataDelegate {
    
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
}

    //MARK: - Forecast Weather

extension WeatherViewController: ForecastWeatherDataDelegate {

    func updateTableCell() {
        
        tableView.reloadData()
        
    }
}
