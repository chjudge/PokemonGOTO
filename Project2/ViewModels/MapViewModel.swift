//
//  ViewModel.swift
//  CoreLocationApp
//
//  Created by Heston Suorsa on 11/11/22.
//

import Foundation
import CoreLocation
import UIKit
import MapKit
import UserNotifications

class MapViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    let firestore = FirestoreManager<FirestoreEvent>(collection: "event")
    
    var locationManager = CLLocationManager()
    
    @Published var userLat: Double? = nil
    @Published var userLon: Double? = nil
    
    static let shared: MapViewModel = {
        return MapViewModel()
    }()
    
    override init() {
        
        // init its parent
        super.init()
        
        // create a delegate
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // request permission to the user
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    // MARK - Location Manager Delegate Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            
            // start geolocating the user, after we get the permission
            locationManager.startUpdatingLocation()
            
        } else if locationManager.authorizationStatus == .denied {
            
            print("location access not given")
            
        }
        
    }
    
    // capture the published geolocation by the locationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations.first ?? "No location")
        
        if let userLocation = locations.first {
            self.userLat = userLocation.coordinate.latitude
            self.userLon = userLocation.coordinate.longitude
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let title = "You Entered the Region"
        let message = "Wow theres cool stuff in here! YAY!"
        print("\(title): \(message)")
    }
        
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let title = "You Left the Region"
        let message = "Say bye bye to all that cool stuff. =["
        print("\(title): \(message)")
    }
    
}
