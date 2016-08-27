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

class MapViewController: UIViewController, CLLocationManagerDelegate, UIAlertMaker, UIMaker {

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
            mapView.showsUserLocation = true
            if #available(iOS 9.0, *) {
                mapView.showsCompass = true
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
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = placesToVisit[activPlace].valueForKey("title") as? String
            annotation.subtitle = "Need to visit this place"
            self.mapView.addAnnotation(annotation)
        }
        
        longPressHandler()
    }
    
    override func viewWillAppear(animated: Bool) {
            setUI()
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
                    self.showAlert(withTitle: "Something went wrong", withMessage: "Maybe Your internet connection is down?")
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
    
    func setUI() {
        setView()
        setNavigationBar(forClassWithName: String(MapViewController.self))
    }
    
    func longPressHandler() {
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(MapViewController.longPressGesture(_:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)        
    }
}
