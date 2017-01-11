//
//  WeatherViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIMaker {
    
    @IBOutlet weak var weatherButton: UIButton!
    
    var imageView: UIImageView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        setBackgroundColor(useUIImageView: imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        setNewBackgroundColor(useUIImageView: imageView)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = M_PI * 2
        rotationAnimation.duration = 4
        rotationAnimation.repeatCount = Float.infinity
        
        self.weatherButton.layer.addAnimation(rotationAnimation, forKey: nil)

    }
}
