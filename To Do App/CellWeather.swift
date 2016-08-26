//
//  CellWeatherTableViewCell.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class CellWeather: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var date: UILabel!
    @IBOutlet var weatherDescription: UILabel!
    @IBOutlet var temperatureMin: UILabel!
    @IBOutlet var temperatureMax: UILabel!
    
    func configureCell(singleDayForecast: SingleDayForecast) {
    
        self.backgroundColor = contentView.backgroundColor
        cellImage.image = UIImage(named: singleDayForecast.weatherDescription)
        date.text = singleDayForecast.date
        weatherDescription.text = singleDayForecast.weatherDescription
        temperatureMin.text = singleDayForecast.temperatureMin
        temperatureMax.text = singleDayForecast.temperatureMax
        
    }
}
