//
//  TestViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation

class TestViewController: UIViewController {

    var authorizationStatus:CLAuthorizationStatus!
    var jsonResults: NSDictionary!
    var city = String()
    var setWeatherDescription = String()
    var setHumidity = String()
    var setPressure = String()
    var setTemperatureAverage = String()
    var setTemperatureMin = String()
    var setTemperatureMax = String()

    
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
        authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse {
            let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(userCityName)&APPID=8ecab5fd503cc5a1f3801625138a85d5")!
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                if let urlContent = data {
                    do {
                        self.jsonResults = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        print(self.jsonResults)
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
                        
                        if let info = self.jsonResults["main"] as? [String: AnyObject]{
                            print(info["temp"])
                        }
//                        
//                        guard let getMainInfo = self.jsonResults["main"] as? NSArray,
//                            let getMainInfoDetalis = getMainInfo[0] as? [String: AnyObject],
//                            let getHumidity = getMainInfoDetalis["humidity"] as? String,
//                            let getPressure = getMainInfoDetalis["pressure"] as? String,
//                            let getTemperatureAverage = getMainInfoDetalis["temp"] as? String,
//                            let getTemperatureMin = getMainInfoDetalis["temp_min"] as? String,
//                            let getTemperatureMax = getMainInfoDetalis["temp_max"] as? String
//                            else {
//                                return
//                        }
//                        
//                        self.setHumidity = getHumidity
//                        self.setPressure = getPressure
//                        self.setTemperatureAverage = getTemperatureAverage
//                        self.setTemperatureMin = getTemperatureMin
//                        self.setTemperatureMax = getTemperatureMax
                    } catch {
                        print(error)
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    print(self.jsonResults)
                    self.cityName.text = self.city
                    self.descriptionOfWeather.text = self.setWeatherDescription
                    self.temperatureAverage.text = self.setTemperatureAverage
                    self.temperatureMin.text = self.setTemperatureMin
                }
                
            }
            
            task.resume()
            
        } else {
            // Do something when user don't allow to get his locaction
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
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
