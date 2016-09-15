//
//  CheckWeatherRequirements.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 20/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation

class CheckWeatherRequirements: UIViewController, CLLocationManagerDelegate, UIAlertMaker, UIMaker {
    
    var uiWasSet = false
    var authorizationStatus:CLAuthorizationStatus!
    
    @IBOutlet var cityNameForWeather: UITextField!
    
    @IBAction func checkWeatherForGivenCity(sender: AnyObject) {
        
        validateCityNameFromUser()

    }
    
    @IBAction func checkWeatherForUserLocation(sender: AnyObject) {
        
        locationManagerSingleton.startUpdatingLocation()
        
        print("README2: \(userCityName)")
        
        self.performSegueWithIdentifier("showWeather", sender: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObserverForChange()

        authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == CLAuthorizationStatus.NotDetermined {
            locationManagerSingleton.locationManagerDelegate.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if !uiWasSet {
            
            setUI()
            uiWasSet = true
            
        }
    }
    
    func setUI() {
        
        setView()
        setNavigationBar(forClassWithName: String(CheckWeatherRequirements.self))
        
    }
    
    func setObserverForChange() {
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CheckWeatherRequirements.failedToGetUserLocation(_:)),
            name: "failedToGetUserLocation",
            object: nil)
        
    }
    
    func failedToGetUserLocation(notification: NSNotification) {
        self.showAlert(withTitle: "Something went wrong", withMessage: "Can't get weather data")
    }
    
    func validateCityNameFromUser() {
        
        if let city = cityNameForWeather.text {
            if !city.isEmpty {
                if city.characters.count <= 15 {
                    let formatedCityName = StringFormatting.removeSpecialCharsFromString(city)
                    userCityName = formatedCityName
                    self.performSegueWithIdentifier("showWeather", sender: nil)
                } else {
                    showAlert(withTitle: "City name is to long", withMessage: "Allowed lenght is 15 characters with spaces")
                }
            } else {
                showAlert(withTitle: "Hmmm...", withMessage: "Without city name it will be hard to check weather")
            }
        }
    }
}
