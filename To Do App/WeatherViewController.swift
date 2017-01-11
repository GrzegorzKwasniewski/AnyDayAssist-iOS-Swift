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
    
    var currentWeatherData: CurrentWeatherData = CurrentWeatherData()
    var forecastWeatherData: ForecastWeatherData = ForecastWeatherData()
    var authorizationStatus:CLAuthorizationStatus!
    var locationManager = LocationManager()
    
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
    
    @IBOutlet weak var cloudImage1: UIImageView!
    @IBOutlet weak var cloudImage2: UIImageView!
    @IBOutlet weak var cloudImage3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setObserverForChange()
        tableView.delegate = self
        tableView.dataSource = self
        currentWeatherData.delegate = self
        forecastWeatherData.delegate = self
        authorizationStatus = CLLocationManager.authorizationStatus()
        
        if weatherFromUserLocation && authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse {
            weatherFromUserLocation = false
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setUI()
        animateCloud(cloudImage1.layer)
        animateCloud(cloudImage2.layer)
        animateCloud(cloudImage3.layer)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        checkForAuthorisationStatus()
        downloadWeatherData()
        
    }
    
    func setUI() {
        
        setView()
        setSmallTableView(forTableView: tableView)
        setNavigationBar(forClassWithName: String(WeatherViewController.self))
        
    }
    
    func setObserverForChange() {
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(WeatherViewController.failedToGetUserLocation(_:)),
            name: "failedToGetUserLocation",
            object: nil)
        
    }
    
    func failedToGetUserLocation(notification: NSNotification) {
            self.showAlert(withTitle: "Something went wrong", withMessage: "Can't get weather data")
    }

    func checkForAuthorisationStatus() {
        if weatherFromUserLocation && authorizationStatus == CLAuthorizationStatus.Denied {
            hideLoadingHUD()
            showAlertForChangingSettings(withTitle: "Can't get weather data", withMessage: "Application don't have proper permissions")
        }
    }
    
    func downloadWeatherData() {
        if Reachability.isConnectedToNetwork() == true {
            //showLoadingHUD()
            currentWeatherData.downloadWeatherData(forCity: userCityName)
            forecastWeatherData.downloadWeatherData(forCity: userCityName)
        } else {
            showAlert(withTitle: "You don't have internet connection", withMessage: "Check Your settings")
        }
    }
    
    func animateCloud(layer: CALayer) {
        
        layer.opacity = 0.8
        
        let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
        let duration: NSTimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
        
        let cloudMove = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.toValue = self.view.bounds.size.width + layer.bounds.width/2
        cloudMove.delegate = self
        cloudMove.autoreverses = true
        cloudMove.repeatCount = Float.infinity
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        
        layer.addAnimation(cloudMove, forKey: nil)
    }

}

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

extension WeatherViewController: ForecastWeatherDataDelegate {

    func updateTableCell() {
        
        tableView.reloadData()
        
    }
}
