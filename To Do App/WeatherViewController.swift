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

class WeatherViewController: UIViewController, UIAlertMaker {
    
    var horizontalClass: UIUserInterfaceSizeClass!
    var verticalCass: UIUserInterfaceSizeClass!

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
        
        if Reachability.isConnectedToNetwork() == true {
        
        if authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse {
            
            showLoadingHUD()
            
            let convertedCityName = StringFormatting.removeSpecialCharsFromString(userCityName)
            
            let properURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(convertedCityName)&units=metric&APPID=8ecab5fd503cc5a1f3801625138a85d5")
                
                let task = NSURLSession.sharedSession().dataTaskWithURL(properURL!) { (data, response, error) in
                    
                    if let urlContent = data {
                        
                        do {
                            
                            self.jsonResults = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            
                            if let getCityName = self.jsonResults["name"] as? String {
                                self.city = getCityName
                            }
                            
                            guard let getWeather = self.jsonResults["weather"] as? NSArray,
                                // this is [KeyType: ValueType] annotation
                                let getWeatherDetalis = getWeather[0] as? [String: AnyObject],
                                let getWeatherDescription = getWeatherDetalis["description"] as? String
                                else {
                                    return
                            }
                            
                            self.setWeatherDescription = getWeatherDescription
                            
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
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                 self.showAlert(withTitle: "There were some problems with accessing data", withMessage: "Try again in few seconds")
                            }
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
                
//            } else {
//                
//                self.hideLoadingHUD()
//                
//                let alert = UIAlertController(title: "There's no data for such City", message: "Don't put any special signs when typing city name", preferredStyle: .Alert)
//                alert.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//            }
            
            
        } else {
            
            hideLoadingHUD()
            
            showAlertForChangingSettings(withTitle: "Can't get weather data", withMessage: "Application don't have proper permissions")

            }
            
        } else {
            
            showAlert(withTitle: "You don't have internet connection", withMessage: "Check Your settings")
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUI()
        
    }
    
    override func returnToMainScreen() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setUI() {
        
        horizontalClass = self.traitCollection.horizontalSizeClass;
        verticalCass = self.traitCollection.verticalSizeClass;
        
        setView()
        setNavigationBar()
    }
    
    func setView() {
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        
        if let backgroundColor = NSUserDefaults.standardUserDefaults().objectForKey("BackgroundColor") {
            
            imageView.image = UIImage(named: backgroundColor as! String)
            
        } else {
            
            imageView.image = UIImage(named: "bg_blue.jpg")
            
        }
        
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        view.backgroundColor = .lightGrayColor()
    }
    
    func setNavigationBar() {
        
        var fontSize: CGFloat!
        var yPosition: CGFloat!
        
        var navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        
        let leftItem = UIBarButtonItem(title: "< Back", style: .Plain, target: nil, action: #selector(returnToMainScreen))
        
        if horizontalClass == .Regular && verticalCass == .Regular {
            
            fontSize = 30
            yPosition = 40
            
        } else {
            
            fontSize = 17
            yPosition = 20
            
        }
        
        navigationBar = UINavigationBar(frame: CGRectMake( 0, yPosition, self.view.frame.size.width, 40))
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = true
        navigationBar.backgroundColor = UIColor.clearColor()
        
        leftItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: fontSize)!], forState: UIControlState.Normal)
        leftItem.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationBar.items = [navigationItem]
        
        view.addSubview(navigationBar)
        
    }
}
