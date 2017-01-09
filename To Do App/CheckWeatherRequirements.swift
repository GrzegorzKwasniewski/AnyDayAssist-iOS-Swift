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
    var locationManager = LocationManager()
    var stringValidation = StringValidation.isEmpty
    
    @IBOutlet var cityNameForWeather: UITextField!
    
    @IBAction func checkWeatherForGivenCity(sender: AnyObject) {
        
        stringValidation = StringHelperClass.validateCityNameFromUser(withTextField: cityNameForWeather)
        
        switch stringValidation {
        case .isValid:
            self.performSegueWithIdentifier("showWeather", sender: nil)
        case .isToLong:
            showAlert(withTitle: "City name is to long", withMessage: "Allowed lenght is 15 characters with spaces")
        case .isEmpty:
            showAlert(withTitle: "Hmmm...", withMessage: "Without city name it will be hard to check weather")
        }

    }
    
    @IBAction func checkWeatherForUserLocation(sender: AnyObject) {
        
        locationManager.startUpdatingLocation()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == CLAuthorizationStatus.NotDetermined {
            locationManager.locationManagerDelegate.requestWhenInUseAuthorization()
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
}

extension CheckWeatherRequirements: LocationManagerUpdateDelegate {
    
    func performActionAfterLocationUpdate() {
        self.performSegueWithIdentifier("showWeather", sender: nil)
    }
}
