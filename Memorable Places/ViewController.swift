//
//  ViewController.swift
//  Memorable Places
//
//  Created by kelvinfok on 18/7/16.
//  Copyright © 2016 kelvinfok. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {
            print("active place is -1")
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        } else {
            print("active place not -1")
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["long"]!).doubleValue
            
            let latDelta:CLLocationDegrees = 0.5
            let lonDelta:CLLocationDegrees = 0.5
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = places[activePlace]["name"]
            self.map.addAnnotation(annotation)
        }
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.action(_:)))
        uilpgr.minimumPressDuration = 2.0
        map.addGestureRecognizer(uilpgr)
    }
    
    
    func action(gestureRecongnizer: UIGestureRecognizer) {
        
        if gestureRecongnizer.state == UIGestureRecognizerState.Began {
            print("pressed")
            let touchPoint = gestureRecongnizer.locationInView(map)
            let newCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                var title = ""
                
                if (error == nil) {
                    
                    if let p = placemarks?[0] {
                        
                        var subThoroughFare = ""
                        var thoroughFare = ""
                        
                        if p.subThoroughfare != nil {
                            
                            subThoroughFare = p.subThoroughfare!
                        }
                        
                        if p.thoroughfare != nil {
                            thoroughFare = p.thoroughfare!
                        }
                        
                        title = "\(subThoroughFare) \(thoroughFare)"
                    }
                    
                }
                
                if title == "" {
                    
                    title = "Added \(NSDate())"
                }
                
                places.append(["name": "\(title)", "lat": "\(newCoordinate.latitude)", "long": "\(newCoordinate.longitude)"])
                
                print(places)
                print("\n")
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                self.map.addAnnotation(annotation)
            })
            
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        let longitude = userLocation.coordinate.longitude
        let latitude = userLocation.coordinate.latitude
        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        map.setRegion(region, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

