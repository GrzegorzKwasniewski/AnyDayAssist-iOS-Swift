//
//  WeatherViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 07/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

var trueor = false


class MainViewController: UIViewController {
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

    }
    
    override func viewWillAppear(animated: Bool) {
        
        setNewBackgroundColor()

    }
    
    func setUI() {
        
        imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        
        if let checkForBackgroundColor = NSUserDefaults.standardUserDefaults().objectForKey("BackgroundColor") {
            
            imageView!.image = UIImage(named: checkForBackgroundColor as! String)

        } else {
            
            imageView!.image = UIImage(named: "bg_blue.jpg")
            
        }
        
        view.addSubview(imageView!)
        view.sendSubviewToBack(imageView!)
    }
    
    func setNewBackgroundColor() {
        
        let newBackgroundColor = NSUserDefaults.standardUserDefaults().objectForKey("BackgroundColor")
        
        imageView!.image = UIImage(named: newBackgroundColor as! String)
        
    }
}
