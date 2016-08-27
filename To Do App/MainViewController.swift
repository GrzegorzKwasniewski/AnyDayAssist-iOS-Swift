//
//  WeatherViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIMaker {
    
    var imageView: UIImageView!    
    var weatherData = CurrentWeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        setBackgroundColor(useUIImageView: imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        setNewBackgroundColor(useUIImageView: imageView)
    }
}
