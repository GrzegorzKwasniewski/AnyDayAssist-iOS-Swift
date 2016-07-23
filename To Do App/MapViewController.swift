//
//  MapViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 12/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var horizontalClass: UIUserInterfaceSizeClass!
    var verticalCass: UIUserInterfaceSizeClass!
    
    var locationManager:CLLocationManager!
    var placemarks: AnyObject!
    var error: NSError!
    
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // if we try to add new place to visit
        if activPlace == -1 {
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            if #available(iOS 9.0, *) {
                self.mapView.showsCompass = true
            } else {
                // Fallback on earlier versions
            }

        } else {
            
            let latitude = placesToVisit[activPlace].valueForKey("latitude") as! Double
            let longitude = placesToVisit[activPlace].valueForKey("longitude") as! Double
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let latDelta:CLLocationDegrees = 0.01
            let lonDelta:CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            self.mapView.setRegion(region, animated: true)
            
            // add annotation with data about our place to visit
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = placesToVisit[activPlace].valueForKey("title") as! String
            annotation.subtitle = "Need to visit this place"
            self.mapView.addAnnotation(annotation)
        }
        
        longPressHandler()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
            setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func longPressGesture(gestureRecognizer:UIGestureRecognizer) {

        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            let newCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)

            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                var title:String = ""
                
                if error != nil {
                    
                    self.showAlert("Something went wrong", message: "Maybe Your internet connection is down?")
                    return
                    
                }
                
                if placemarks!.count > 0 {
                    
                    let touchLocation = placemarks![0] as CLPlacemark
                    var subThoroughfare:String = ""
                    var thoroughFare:String = ""
                    
                    if touchLocation.subThoroughfare != nil {
                        
                        subThoroughfare = touchLocation.subThoroughfare!
                        
                    }
                    
                    if touchLocation.thoroughfare != nil {
                        
                        thoroughFare = touchLocation.thoroughfare!
                        
                    }

                    title = "\(subThoroughfare) \(thoroughFare)"
                    
                }
                
                if title == "" {
                    
                    title = "Added \(NSDate())"
                    
                }
                
                    globalCoreDataFunctions.saveMarkedPlace(title, latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
                
                    self.addAnnotation(newCoordinate, title: title, subtitle: "New location added")

                })
            }
        }
    
    func addAnnotation(newCoordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = title
        annotation.subtitle = subtitle
        self.mapView.addAnnotation(annotation)
        
    }
    
    func returnToPlacesView() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setUI() {
        
        horizontalClass = self.traitCollection.horizontalSizeClass;
        verticalCass = self.traitCollection.verticalSizeClass;
        
        setView()
        setNavigationBar()
   
    }
    
    func setView() {
        
        let backgroundImage = UIImage(named: "bg.jpg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .ScaleAspectFill
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
    }
    
    func setNavigationBar() {
        
        var fontSize: CGFloat!
        var yPosition: CGFloat!
        
        var navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        
        let leftItem = UIBarButtonItem(title: "< Back", style: .Plain, target: nil, action: #selector(returnToPlacesView))
        
        if horizontalClass == .Regular && verticalCass == .Regular {
            
            fontSize = 30
            yPosition = 40
            
        } else {
            
            fontSize = 17
            yPosition = 20
            
        }
        
        navigationBar = UINavigationBar(frame: CGRectMake( 0, yPosition, self.view.frame.size.width, 40))
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = true
        navigationBar.backgroundColor = UIColor.clearColor()
        
        leftItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: fontSize)!], forState: UIControlState.Normal)
        leftItem.tintColor = UIColor.blueColor()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationBar.items = [navigationItem]
        
        view.addSubview(navigationBar)
        
    }
    
    func longPressHandler() {
        
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(MapViewController.longPressGesture(_:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
        
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "CLOSE", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
