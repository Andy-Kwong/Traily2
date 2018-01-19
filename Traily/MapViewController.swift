//
//  ViewController.swift
//  Traily
//
//  Created by Andy Kwong on 1/18/18.
//  Copyright © 2018 Andy Kwong. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    override func loadView() {
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 37.258316, longitude: -122.122061, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.258316, longitude: -122.122061)
        marker.title = "Saratoga Gap: Skyline-to-the-Sea Trailhead"
        marker.snippet = "Mile: 0.00"
        marker.map = mapView
        
            let path = Bundle.main.path(forResource: "TrailyWaypoints", ofType: "json")
            let url = URL(fileURLWithPath: path!)
            geoJsonParser = GMUGeoJSONParser(url: url)
            geoJsonParser.parse()
        
            renderer = GMUGeometryRenderer(map: mapView, geometries: geoJsonParser.features)
        
            renderer.render()
        
    }
    
    var lat: Double = 0.0
    var long: Double = 0.0
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        enableBasicLocationServices()
    }
    
    
    func enableBasicLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            enableMyWhenInUseFeatures()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse:
            enableMyWhenInUseFeatures()
            break
            
        case .notDetermined, .authorizedAlways:
            break
        }
    }
    
    func disableMyLocationBasedFeatures(){
        print("disableMyLocationBasedFeatures")
    }
    
    func enableMyWhenInUseFeatures(){
        print("enableMyWhenInUseFeaatures")
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 1.0 // In meters.
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        if self.lat == 0.0 {
            self.lat = lastLocation.coordinate.latitude
            self.long = lastLocation.coordinate.longitude
        } else {
            calcDistance(latitude1: self.lat, longitude1: self.long, latitude2: lastLocation.coordinate.latitude  , longitude2: lastLocation.coordinate.longitude)
            
        }
        
        // Do something with the location.
    }
    
    func calcDistance (latitude1: Double, longitude1: Double, latitude2: Double, longitude2: Double) -> Double {
        
        let coordinate1 = CLLocation(latitude: latitude1, longitude: longitude2)
        let coordinate2 = CLLocation(latitude: latitude2, longitude: longitude2)
        
        let distanceInMeters = coordinate1.distance(from: coordinate2) // result is in meters
        print(distanceInMeters)
        return distanceInMeters
    }
    
}


