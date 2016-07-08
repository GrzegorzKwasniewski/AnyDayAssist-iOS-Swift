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

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    var authorizationStatus:CLAuthorizationStatus!
    var placemarks: AnyObject!
    var error: NSError!
    
    @IBAction func checkWeather(sender: AnyObject) {
        
           locationManager.startUpdatingLocation()
//        } else if authorizationStatus == CLAuthorizationStatus.Denied {
//            // Inform user that he can change setting in setting menu
//            print("no no")
//            // User can change his mind usig this
//            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
//        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print ("Error: \(error?.localizedDescription)") //TODO: check for more info
                return
            }
            
            if placemark?.count > 0 {
                let user = placemark![0]
                let data = user.addressDictionary as! NSDictionary
                
                guard let city = data["City"] as? String, let zipCode = data["ZIP"] as? String
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
