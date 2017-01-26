//
//  CellWeatherTableViewCell.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class CellWeather: UITableViewCell {
    
    // MARK: - UI
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var date: UILabel!
    @IBOutlet var weatherDescription: UILabel!
    @IBOutlet var temperatureMinVaule: UILabel!
    @IBOutlet var temperatureMaxVaule: UILabel!
    @IBOutlet var temperatureMinLabel: UILabel!
    @IBOutlet var temperatureMaxLabel: UILabel!
    
    // MARK: - Properties
    
    var views = [UIView]()
    
    // MARK: - Initializers
    
    override func awakeFromNib() {
        views = [
            cellImage,
            date,
            weatherDescription,
            temperatureMinVaule,
            temperatureMaxVaule,
            temperatureMinLabel,
            temperatureMaxLabel
        ]
        views.forEach({$0.alpha = 0})
    }
    
    // MARK: - Custom Functions
    
    func configureCell(singleDayForecast: SingleDayForecast) {
        self.backgroundColor = contentView.backgroundColor
        cellImage.image = UIImage(named: singleDayForecast.weatherDescription)
        date.text = singleDayForecast.date
        weatherDescription.text = singleDayForecast.weatherDescription
        temperatureMinVaule.text = singleDayForecast.temperatureMin
        temperatureMaxVaule.text = singleDayForecast.temperatureMax
        
        views.forEach({$0.animateAlpha()})
    }
}
