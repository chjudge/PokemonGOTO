//
//  MapView.swift
//  CoreLocationApp
//
//  Created by Heston Suorsa on 11/11/22.
//

import SwiftUI
import MapKit
import PokemonAPI

struct MapView: UIViewRepresentable {
    
    @ObservedObject var VM: MapViewModel = MapViewModel.shared
    
    //Computed variable based on user's current location after getting approved.
    var region : MKCoordinateRegion {
    
        if let lat = VM.userLat, let lon = VM.userLon {
            
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            
        } else { //Otherwise, print a default position
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.1548, longitude: -80.085), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        }
        
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        
        // create annotations
//        let query = VM.firestore.query(collection: "event")
//        VM.firestore.subscribe(to: query)
        
        //make the user to show up in the map; need to request permission for location first, otherwise function will not work
        map.delegate = context.coordinator
        map.showsUserLocation = true
        map.userTrackingMode = .followWithHeading
        map.setRegion(region, animated: true)
        updateEvents(map, VM.firestore.firestoreModels)
        populateWildPokemon(map)
//        map.preferredConfiguration = MKImageryMapConfiguration()
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
//        uiView.setRegion(region, animated: true)
//        print("Count: \(VM.firestore.firestoreModels)")
        
        updateEvents(uiView, VM.firestore.firestoreModels)
//        populateWildPokemon(uiView)
        
    }
    
    func populateWildPokemon(_ uiView: MKMapView) {
        print("Populating wild pokemon onto map")
        var coords = [CLLocationCoordinate2D]()
        
        let pokemonAPI = PokemonAPI()
        
        let maxSpawns = 5
        let highestPokemonId = 151 // Test
        let highestLevel = 5
        
        for _ in [1..<Int.random(in: 3..<maxSpawns)] {
            let randomLat = Float.random(in: 41.154001937356284 ..< 41.157117172039925)
            let randomLong = Float.random(in: -80.08110060219843 ..< -80.07630910217662)
            coords.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(randomLat), longitude: CLLocationDegrees(randomLong)))
        }
        
        for coord in coords {
            print("adding pokemon")
//            let randomPokemon = Int.random(in: 1..<highestPokemonId)
            let randomPokemon = 1
            let randomLevel = Int.random(in: 1..<highestLevel)
            let wildPokemonMarker = MKPointAnnotation()
            wildPokemonMarker.coordinate = coord
            Task{
                let pokemon = try await pokemonAPI.pokemonService.fetchPokemon(randomPokemon)
                wildPokemonMarker.title = pokemon.name!
                uiView.addAnnotation(wildPokemonMarker)
            }
            
            
        }
        
    }
    
    func updateEvents(_ uiView: MKMapView, _ events: [FirestoreEvent]) {
        print("Populating events onto map")
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
        for event in events {
            // Add annotations
            let loc = MKPointAnnotation()
//            print("Event: \(event)")
            loc.title = event.title
            loc.coordinate = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
            uiView.addAnnotation(loc)
            // Add region
            let region = CLCircularRegion(center: loc.coordinate, radius: CLLocationDistance(event.radius), identifier: event.id ?? "N/A")
//            uiView.removeOverlays(uiView.overlays)
            VM.locationManager.startMonitoring(for: region)
            // Add zone
            let circle = MKCircle(center: loc.coordinate, radius: region.radius)
            uiView.addOverlay(circle)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay.isKind(of: MKCircle.self){
                let circleRenderer = MKCircleRenderer(overlay: overlay)
                circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
                circleRenderer.strokeColor = UIColor.blue
                circleRenderer.lineWidth = 1
                return circleRenderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Reuse")
            annotationView.canShowCallout = true
//            annotationView.collisionMode = .circle
            print("mapping \(annotation.title! ?? "oops")")
            print(PokemonManager.shared.allPokemon.first(where: { $0.pokemon.name! == annotation.title! })?.pokemon.name!)
            if let pkm = PokemonManager.shared.allPokemon.first(where: { $0.pokemon.name! == annotation.title! }) {
                print("we in big boys")
                annotationView.image = pkm.sprite
                return annotationView
            }
            return nil
            
        }
        
    }
    
}

