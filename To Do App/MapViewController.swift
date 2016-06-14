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
            self.mapView.showsCompass = true
        
        // else if have choosen place from table
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
        
        // add handler for 'longpress' on the screen
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(MapViewController.longPressGesture(_:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)

    }
    
    // this is calld automaticly - tell delegate that has changed
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
        
        // only one 'longpress' is allowed
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            // convert touch on the screen to new coordinate on map
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            let newCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            // get address from geo point location
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                var title:String = ""
                
                if error != nil {
                    print ("Error: \(error?.localizedDescription)") //TODO: check for more info
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
                    
                    // this data isn't always available
                    title = "\(subThoroughfare) \(thoroughFare)"
                }
                
                // if don't get data from touchLocation
                if title == "" {
                    title = "Added \(NSDate())"
                }
                
                    self.saveMarkedPlace(title, latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
                
                    // add annotation to MapView
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    annotation.subtitle = "New location added"
                    self.mapView.addAnnotation(annotation)
                })
            }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveMarkedPlace(title: String, latitude: Double, longitude: Double) {

        // create Core Data entity
        let entityDescription = NSEntityDescription.entityForName("Places", inManagedObjectContext: contextOfOurApp)
        let newPlace = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: contextOfOurApp)
        
        newPlace.setValue(title, forKey: "title")
        newPlace.setValue(latitude, forKey: "latitude")
        newPlace.setValue(longitude, forKey: "longitude")
        
        do {
            try contextOfOurApp.save()
            placesToVisit.append(newPlace)
            
        } catch let error as NSError{
            print ("There was an error \(error), \(error.userInfo)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
