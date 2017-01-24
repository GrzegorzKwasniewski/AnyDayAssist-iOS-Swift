//
//  Constants.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 05/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//CoreDataFunctions.swift
let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let contextOfOurApp: NSManagedObjectContext = appDelegate.managedObjectContext

// CheckWeatherRequirements.swift
var weatherFromUserLocation = false
var userCityName = String()
var userCityZipCode = String()
var userLoactionCityName = String()


//PlacesViewController.swift
var activPlace = -1


//ForecastWeatherData.swift
var forecasts = [SingleDayForecast]()

//enums

enum StringValidation {
    case isValid
    case isToLong
    case isEmpty
}
