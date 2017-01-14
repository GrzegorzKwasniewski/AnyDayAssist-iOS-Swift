//
//  LocationManager.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 26/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    weak var delegate: LocationManagerUpdateDelegate?
    let locationManagerDelegate = CLLocationManager()
    
    // MARK: - Initializers

    override init(){
        super.init()
        locationManagerDelegate.delegate = self
        locationManagerDelegate.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Custom Functions
    
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
                NSNotificationCenter.defaultCenter().postNotificationName("failedToGetUserLocation", object: nil)
                return                
            }
            if placemark?.count > 0 {
                let user = placemark![0]
                let data = user.addressDictionary
                guard let city = data!["City"] as? String, let zipCode = data!["ZIP"] as? String
                    else {
                        NSNotificationCenter.defaultCenter().postNotificationName("failedToGetUserLocation", object: nil)
                        return }
                userCityName = city
                userCityZipCode = zipCode
                self.locationManagerDelegate.stopUpdatingLocation()
                self.delegate?.performActionAfterLocationUpdate()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSNotificationCenter.defaultCenter().postNotificationName("failedToGetUserLocation", object: nil)
        print(error)
    }
}
