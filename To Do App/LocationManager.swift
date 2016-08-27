//
//  LocationManager.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 26/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation

let locationManagerSingleton = LocationManager()

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManagerDelegate = CLLocationManager()

    private override init(){
        super.init()
        locationManagerDelegate.delegate = self
        locationManagerDelegate.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startUpdatingLocation() {
    
        locationManagerDelegate.startUpdatingLocation()

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            
            if error != nil {
                
                //self.showAlert(withTitle: "Something went wrong", withMessage: "Can't get weather data")
                return
                
            }
            
            if placemark?.count > 0 {
                
                let user = placemark![0]
                let data = user.addressDictionary
                
                guard let city = data!["City"] as? String, let zipCode = data!["ZIP"] as? String
                    else { return }
                
                userCityName = city
                userCityZipCode = zipCode
                self.locationManagerDelegate.stopUpdatingLocation()
                
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        //showAlert(withTitle: "Something went wrong", withMessage: "Can't get weather data")
        
    }
}
