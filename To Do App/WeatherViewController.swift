//
//  TestViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class WeatherViewController: UIViewController {

    var authorizationStatus:CLAuthorizationStatus!
    var url: NSURL = NSURL()
    var jsonResults = NSDictionary()
    var city = String()
    var setWeatherDescription = String()
    var setHumidity = String()
    var setPressure = String()
    var setTemperatureAverage = String()
    var setTemperatureMin = String()
    var setTemperatureMax = String()
    var setWindSpeed = String()

    
    @IBOutlet var cityName: UILabel!
    @IBOutlet var descriptionOfWeather: UILabel!
    @IBOutlet var temperatureAverage: UILabel!
    @IBOutlet var temperatureMin: UILabel!
    @IBOutlet var temperatureMax: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var humidity: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        
        authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse {
            
            self.showLoadingHUD()
            
            let stringWithoutSpecialSigns = userCityName.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
            
            if let properURL: NSURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(stringWithoutSpecialSigns)&units=metric&APPID=8ecab5fd503cc5a1f3801625138a85d5") {
                
                let task = NSURLSession.sharedSession().dataTaskWithURL(properURL) { (data, response, error) in
                    if let urlContent = data {
                        do {
                            self.jsonResults = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            
                            if let getCityName = self.jsonResults["name"] as? String {
                                self.city = getCityName
                            }
                            
                            guard let getWeather = self.jsonResults["weather"] as? NSArray,
                                let getWeatherDetalis = getWeather[0] as? [String: AnyObject],
                                let getWeatherDescriptionDescription = getWeatherDetalis["description"] as? String
                                else {
                                    return
                            }
                            self.setWeatherDescription = getWeatherDescriptionDescription
                            
                            if let getWindData = self.jsonResults["wind"] as? [String: AnyObject]{
                                if let getWindSpeed = getWindData["speed"] as? Double {
                                    self.setWindSpeed = String(getWindSpeed)
                                }
                            }
                            
                            if let getMainInfo = self.jsonResults["main"] as? [String: AnyObject]{
                                
                                if let getTemperatureAverage = getMainInfo["temp"] as? Double {
                                    
                                    self.setTemperatureAverage = String(getTemperatureAverage)
                                }
                                
                                if let getTemperatureMin = getMainInfo["temp_min"] as? Double {
                                    
                                    self.setTemperatureMin = String(getTemperatureMin)
                                }
                                
                                if let getTemperatureMin = getMainInfo["temp_max"] as? Double {
                                    
                                    self.setTemperatureMax = String(getTemperatureMin)
                                }
                                
                                if let getPressure = getMainInfo["pressure"] as? Int {
                                    
                                    self.setPressure = String(getPressure)
                                }
                                
                                if let getHumidity = getMainInfo["humidity"] as? Int {
                                    
                                    self.setHumidity = String(getHumidity)
                                }
                            }
                        } catch {
                            self.showAlert("Something went wrong", message: "No data found")
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.hideLoadingHUD()
                        
                        self.cityName.text = self.city
                        self.descriptionOfWeather.text = self.setWeatherDescription
                        self.temperatureAverage.text = "\(self.setTemperatureAverage)°C"
                        self.temperatureMin.text = "\(self.setTemperatureMin)°C"
                        self.temperatureMax.text = "\(self.setTemperatureMax)°C"
                        self.pressure.text = "\(self.setPressure) mb"
                        self.windSpeed.text = "\(self.setWindSpeed) km h"
                        self.humidity.text = "\(self.setHumidity) %"
                        
                    }
                    
                }
                
                task.resume()
                
            } else {
                
                self.hideLoadingHUD()
                
                let alert = UIAlertController(title: "Can't get weather data", message: "Try again later", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Back to main", style: .Default, handler: { (uialert) in
                    self.performSegueWithIdentifier("returnToMainScreen", sender: self)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            
        } else {
            
            self.hideLoadingHUD()
            
            let alert = UIAlertController(title: "Can't get weather data", message: "Application don't have needed permissions", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Change", style: .Default, handler: { (uialert) in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }))
            alert.addAction(UIAlertAction(title: "CLOSE", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        setUI()
    }
    
    func returnToMainScreen() {
        self.dismissViewControllerAnimated(true, completion: nil)
        //self.performSegueWithIdentifier("returnToCheckWeatherScreen", sender: self)
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
        view.backgroundColor = .lightGrayColor()
    }
    
    func setNavigationBar() {
        
        let navigationbar = UINavigationBar(frame: CGRectMake( 0, 20, self.view.frame.size.width, 40))
        navigationbar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationbar.shadowImage = UIImage()
        navigationbar.translucent = true
        navigationbar.backgroundColor = UIColor.clearColor()
        
        let navigationItem = UINavigationItem()
        let leftItem = UIBarButtonItem(title: "< Main", style: .Plain, target: nil, action: #selector(returnToMainScreen))
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
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
}
