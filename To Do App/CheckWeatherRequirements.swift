//
//  CheckWeatherRequirements.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 20/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation

var userCityName = String()
var userCityZipCode = String()

class CheckWeatherRequirements: UIViewController, CLLocationManagerDelegate, UIAlertMaker, UIMaker {
    
    @IBOutlet var cityNameForWeather: UITextField!
    
    @IBAction func checkWeatherForGivenCity(sender: AnyObject) {
        
        validateCityNameFromUser()

    }
    
    
    @IBAction func checkWeatherForUserLocation(sender: AnyObject) {
        
        locationManager.startUpdatingLocation()
        
        self.performSegueWithIdentifier("showWeather", sender: nil)
        
    }
    
    var uiWasSet = false
    var locationManager:CLLocationManager!
    var authorizationStatus:CLAuthorizationStatus!
    var placemarks: AnyObject!
    var error: NSError!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if !uiWasSet {
            
            setUI()
            uiWasSet = true
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            
            if error != nil {
                
                self.showAlert(withTitle: "Something went wrong", withMessage: "Can't get weather data")
                return
                
            }
            
            if placemark?.count > 0 {
                
                let user = placemark![0]
                let data = user.addressDictionary
                
                guard let city = data!["City"] as? String, let zipCode = data!["ZIP"] as? String
                    else { return }
                
                userCityName = city
                userCityZipCode = zipCode
                self.locationManager.stopUpdatingLocation()
                
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

        showAlert(withTitle: "Something went wrong", withMessage: "\(error)")
        
    }
    
    func setUI() {
        
        setView()
        setNavigationBar(forClassWithName: String(CheckWeatherRequirements.self))
        
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
