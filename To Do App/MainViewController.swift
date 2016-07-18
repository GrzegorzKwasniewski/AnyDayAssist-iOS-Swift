//
//  WeatherViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation

var userCityName = String()
var userCityZipCode = String()

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    var authorizationStatus:CLAuthorizationStatus!
    var placemarks: AnyObject!
    var error: NSError!
    
    @IBAction func checkWeather(sender: AnyObject) {
        
           locationManager.startUpdatingLocation()
        
    }
    
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
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                self.showAlert("Something went wrong", message: "\(error?.localizedDescription)")
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
                self.performSegueWithIdentifier("showWeather", sender: nil)
            }
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // error handle
    }

    func setUI() {

        let imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        imageView.image = UIImage(named: "bg.jpg")
        
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        self.view.backgroundColor = .lightGrayColor()
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "CLOSE", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
