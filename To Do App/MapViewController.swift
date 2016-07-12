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
            
            // convert touch on the screen to new coordinate on map
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            let newCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            // get address from geo point location
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                var title:String = ""
                
                if error != nil {
                    
                    print ("Error: \(error?.localizedDescription)")
                    return
                    
                }
                
                if placemarks!.count > 0 {
                    
                    let touchLocation = placemarks![0] as CLPlacemark
                    var subThoroughfare:String = ""
                    var thoroughFare:String = ""
                    
                    //touchLocation.addressDictionary
                    
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
                
                    self.saveMarkedPlace(title, latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    annotation.subtitle = "New location added"
                    self.mapView.addAnnotation(annotation)
                })
            }
        }
    
    func saveMarkedPlace(title: String, latitude: Double, longitude: Double) {

        let entityDescription = NSEntityDescription.entityForName("Places", inManagedObjectContext: contextOfOurApp)
        let newPlace = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: contextOfOurApp)
        
        newPlace.setValue(title, forKey: "title")
        newPlace.setValue(latitude, forKey: "latitude")
        newPlace.setValue(longitude, forKey: "longitude")
        
        do {
            
            try contextOfOurApp.save()
            
        } catch let error as NSError{
            
            print ("There was an error \(error), \(error.userInfo)")
            
        }
    }
    
    func returnToPlaces() {
        
        self.performSegueWithIdentifier("returnToPlaces", sender: self)
        
    }
    
    func setUI() {
        
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
        
        let navigationbar = UINavigationBar(frame: CGRectMake( 0, 20, self.view.frame.size.width, 40))
        navigationbar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationbar.shadowImage = UIImage()
        navigationbar.translucent = true
        navigationbar.backgroundColor = UIColor.clearColor()
        let navigationItem = UINavigationItem()
        let leftItem = UIBarButtonItem(title: "< Back", style: .Plain, target: nil, action: #selector(returnToPlaces))
        leftItem.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = leftItem
        navigationbar.items = [navigationItem]
        
        view.addSubview(navigationbar)
        
    }
    
    func longPressHandler() {
        
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(MapViewController.longPressGesture(_:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
        
    }
}
