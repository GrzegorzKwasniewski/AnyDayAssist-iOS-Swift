//
//  WeatherViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIMaker {
    
    // MARK: - UI
    
    @IBOutlet weak var weatherButton: UIButton!
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        return iv
    }()
    
    // MARK: - View State
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(imageView)
        setBackgroundColor(useUIImageView: imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        setNewBackgroundColor(useUIImageView: imageView)
        rotationAnimation(weatherButton.layer)
    }
}
