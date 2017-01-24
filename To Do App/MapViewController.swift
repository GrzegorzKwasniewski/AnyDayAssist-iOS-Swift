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

class MapViewController: UIViewController, UIAlertMaker, UIMaker {
    
    // MARK: - UI
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties

    var locationManager = CLLocationManager()
    var placemarks: AnyObject!
    var places: [NSManagedObject] = []
    var singlePlace: NSManagedObject?
    
    // MARK: - View State

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if let singlePlace = singlePlace {
            self.mapView.setRegion(getRegion(), animated: true)
            self.mapView.addAnnotation(createAnnotation())
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            mapView.showsCompass = true
        }
        
        longPressHandler()
    }
    
    override func viewWillAppear(animated: Bool) {
        setUI()
    }
    
    // MARK: - Custom Functions
    
    func setUI() {
        setView()
        setNavigationBar(forClassWithName: String(MapViewController.self))
    }
    
    func getRegion() -> MKCoordinateRegion {
        
        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(getCoordinates(), span)
        
        return region
    }
    
    func getCoordinates() -> CLLocationCoordinate2D {
    
        let latitude = singlePlace!.valueForKey("latitude") as! Double
        let longitude = singlePlace!.valueForKey("longitude") as! Double
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        return coordinate
    
    }
    
    func createAnnotation() -> MKPointAnnotation {
    
        let annotation = MKPointAnnotation()
        annotation.coordinate = getCoordinates()
        annotation.title = singlePlace!.valueForKey("title") as? String
        annotation.subtitle = "Need to visit this place"
        
        return annotation
        
    }
    
    func longPressGesture(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            let newCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            getNameForSelectedLoacation(forLoacation: location, withCooridnates: newCoordinate)
        }
    }
    
    func addAnnotation(newCoordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = title
        annotation.subtitle = subtitle
        self.mapView.addAnnotation(annotation)
    }
    
    func longPressHandler() {
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(MapViewController.longPressGesture(_:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)        
    }
}

extension MapViewController: CLLocationManagerDelegate {
   
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
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func getNameForSelectedLoacation(forLoacation location: CLLocation, withCooridnates coordinates: CLLocationCoordinate2D) {
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            if error != nil {
                self.showAlert(withTitle: "Something went wrong", withMessage: "Maybe You don't have internet connection?")
                return
            }
            
            if placemarks!.count > 0 {
                var locationName = ""
                let touchLocation = placemarks![0] as CLPlacemark
                var subThoroughfare: String = ""
                var thoroughFare: String = ""
                
                if let stf = touchLocation.subThoroughfare {
                    if let tf = touchLocation.thoroughfare {
                        subThoroughfare = stf
                        thoroughFare = tf
                        
                        locationName = "\(subThoroughfare) \(thoroughFare)"
                    }
                } else {
                    locationName = touchLocation.name!
                }
                
                CoreDataFunctions.sharedInstance.saveMarkedPlace(locationName, latitude: coordinates.latitude, longitude: coordinates.longitude)
                self.addAnnotation(coordinates, title: locationName, subtitle: "New location added")
            }
        })
    }
}
