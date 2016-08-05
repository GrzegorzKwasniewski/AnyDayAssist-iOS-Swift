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

// how this is publicy aviable? - maybe it's because this is not even a class
let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)\(LONGITUDE)\(APP_ID)\(APP_ID)"