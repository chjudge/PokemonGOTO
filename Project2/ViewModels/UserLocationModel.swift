//
//  ViewModel.swift
//  CoreLocationApp
//
//  Created by Heston Suorsa on 11/11/22.
//

import Foundation
import CoreLocation

class UserLocationModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var locationManager = CLLocationManager()
    
    @Published var userLat: Double? = nil
    @Published var userLon: Double? = nil
    
    static let shared: UserLocationModel = {
        return UserLocationModel()
    }()
    
    override init() {
        
        // init its parent
        super.init()
        
        // create a delegate
        locationManager.delegate = self
        
        // request permission to the user
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    // MARK - Location Manager Delegate Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            
            // We have permission
            print("Yeah, we get the permission")
            
            // start geolocating the user, after we get the permission
            locationManager.startUpdatingLocation()
            
        } else if locationManager.authorizationStatus == .denied {
            
            // We do not have permission
            print("oh no")
            
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
    
}
