//
//  CheckWeatherRequirements.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 20/07/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreLocation

class CheckWeatherRequirements: UIViewController, UIAlertMaker, UIMaker {
    
    // MARK - outlets
    
    @IBOutlet weak var center: NSLayoutConstraint!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var imagesStackView: UIStackView!
    
    // MARK - ivars
    
    private var uiWasSet = false
    private var authorizationStatus:CLAuthorizationStatus!
    private var locationManager = LocationManager()
    private var stringValidation = StringValidation.isEmpty
    
    // MARK - view state
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObserverForChange()
        
//        let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
//        button.setImage(UIImage(named: "play"), forState: .Normal)
//        button.addTarget(self, action: #selector(validateCityName), forControlEvents: UIControlEvents.TouchUpInside)
//        
//        // Assign the overlay button to a stored text field
//        self.cityName.rightView = button;
//        self.cityName.rightViewMode = .Always;
        
        center.constant -= view.bounds.width

        authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == CLAuthorizationStatus.NotDetermined {
            locationManager.locationManagerDelegate.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !uiWasSet {
            
            setUI()
            uiWasSet = true
            
        }
    }
    
    // MARK - actions
    
    @IBAction func checkWeatherForCity(sender: UITapGestureRecognizer) {
        imagesStackView.userInteractionEnabled = false
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
            self.cityImage.alpha = 0.1
            self.center.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    @IBAction func checkWeatherForUserLocation(sender: AnyObject) {
        weatherFromUserLocation = true
        self.performSegueWithIdentifier("showWeather", sender: nil)
    }
    
    // MARK - custom functions
    
    func setUI() {
        
        setView()
        setNavigationBar(forClassWithName: String(CheckWeatherRequirements.self))
        
    }
    
    func validateCityName() {
        stringValidation = StringHelperClass.validateCityNameFromUser(withTextField: cityName)
        
        switch stringValidation {
        case .isValid:
            self.performSegueWithIdentifier("showWeather", sender: nil)
        case .isToLong:
            showAlert(withTitle: "City name is to long", withMessage: "Allowed lenght is 15 characters with spaces")
        case .isEmpty:
            showAlert(withTitle: "Hmmm...", withMessage: "Without city name it will be hard to check weather")
        }
    }
    
    func setObserverForChange() {
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(validateCityName),
            name: "validateCityName",
            object: nil)
        
    }
}
