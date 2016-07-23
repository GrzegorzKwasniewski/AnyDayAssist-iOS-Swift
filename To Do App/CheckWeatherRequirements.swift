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

class CheckWeatherRequirements: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var cityNameForWeather: UITextField!
    
    @IBAction func checkWeatherForGivenCity(sender: AnyObject) {
        
        if let city = cityNameForWeather.text {
            
            if !city.isEmpty {
                
                if city.characters.count <= 15 {
                    
                    userCityName = city
                    self.performSegueWithIdentifier("showWeather", sender: nil)
                    
                } else {
                    showAlert("City name is to long", message: "Allowed lenght is 15 characters with spaces")
                }
                
            } else {
                showAlert("Hmmm...", message: "Without city name it will be hard to check weather")
            }
        }
    }
    
    
    @IBAction func checkWeatherForUserLocation(sender: AnyObject) {
        
        locationManager.startUpdatingLocation()
        
    }
    
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
        setUI()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                self.showAlert("Something went wrong", message: "Can't get weather data")
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
    
    func returnToMainScreen() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setUI() {
        
        setView()
        setNavigationBar()
        
    }
    
    func setView() {
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        imageView.image = UIImage(named: "bg.jpg")
        
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        self.view.backgroundColor = .lightGrayColor()
        
    }
    
    func setNavigationBar() {
        
        let horizontalClass = self.traitCollection.horizontalSizeClass;
        let verticalCass = self.traitCollection.verticalSizeClass;
        
        let navigationbar = UINavigationBar(frame: CGRectMake( 0, 20, self.view.frame.size.width, 40))
        navigationbar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationbar.shadowImage = UIImage()
        navigationbar.translucent = true
        navigationbar.backgroundColor = UIColor.clearColor()
        
        let navigationItem = UINavigationItem()
        let leftItem = UIBarButtonItem(title: "< Main", style: .Plain, target: nil, action: #selector(returnToMainScreen))
        
        if horizontalClass == .Regular && verticalCass == .Regular {
            leftItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 25)!], forState: UIControlState.Normal)
        } else {
            leftItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 17)!], forState: UIControlState.Normal)
        }
        
        leftItem.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationbar.items = [navigationItem]
        
        view.addSubview(navigationbar)
    }

    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "CLOSE", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}
