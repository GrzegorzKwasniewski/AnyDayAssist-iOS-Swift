//
//  WeatherViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    var placemarks: AnyObject!
    var error: NSError!
    
    @IBAction func checkWeather(sender: AnyObject) {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

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
            
            
            
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=London&APPID=8ecab5fd503cc5a1f3801625138a85d5")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            if let urlContent = data {
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    print(jsonResult)
                    
                    guard let weather = jsonResult["weather"] as? NSArray,
                        let detalis = weather[0] as? [String: AnyObject],
                        let decs = detalis["description"] as? String
                        else {
                            return
                    }
                    print(decs)
                    
                } catch {
                    print(error)
                }
            }
        }
        
        task.resume()
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
