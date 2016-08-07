//
//  Constants.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 05/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import Foundation

let BASE_URL = "http://weatherapi.com"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "54986956329429"

var cityName2: String?

var CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?q=\(cityName2)&units=metric&APPID=8ecab5fd503cc5a1f3801625138a85d5"

var FORECAST_WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast?q=Gdansk&units=metric&cnt=4&APPID=8ecab5fd503cc5a1f3801625138a85d5"