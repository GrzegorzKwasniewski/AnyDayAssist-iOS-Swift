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
var userCityName = String()
var userCityZipCode = String()

//TextNotesViewController.swift
var toDoNotes = [NSManagedObject]()

//PlacesViewController.swift
var placesToVisit = [NSManagedObject]()
var activPlace = -1

//AudioNotesViewController.swift
var audioURL: [NSManagedObject] = [NSManagedObject]()
var activeAudioNote: Int?

//ForecastWeatherData.swift
var forecasts = [SingleDayForecast]()

let BASE_URL = "http://weatherapi.com"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "54986956329429"

var CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?q=Gdansk&units=metric&APPID=8ecab5fd503cc5a1f3801625138a85d5"

var FORECAST_WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast?q=Gdansk&units=metric&cnt=4&APPID=8ecab5fd503cc5a1f3801625138a85d5"