//
//  MapView.swift
//  CoreLocationApp
//
//  Created by Heston Suorsa on 11/11/22.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var VM: UserLocationModel = UserLocationModel.shared
    
    var region: MKCoordinateRegion {
        if let lat = VM.userLat, let lon = VM.userLon {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        } else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.1548, longitude: -80.085), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        
        // make the user show up in the map
        map.showsUserLocation = true // if permission doesn't get granted, doesn't work
        map.userTrackingMode = .followWithHeading
        
        return map
        
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        view.setRegion(region, animated: true)
        
    }
    
}

