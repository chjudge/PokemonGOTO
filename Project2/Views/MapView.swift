//
//  MapView.swift
//  CoreLocationApp
//
//  Created by Heston Suorsa on 11/11/22.
//

import SwiftUI
import MapKit
import PokemonAPI
import FirebaseFirestore

struct MapView: UIViewRepresentable {
    
    @ObservedObject var VM: MapViewModel = MapViewModel.shared
    let WPManager = FirestoreManager<FirestoreWildPokemon>(collection: "wildpokemon")
    let db = Firestore.firestore()
    
    @Binding var showEvent: Bool
    
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
//        updateEvents(map, VM.firestore.firestoreModels)
//        populateWildPokemon(map, WPManager.firestoreModels)
//        map.preferredConfiguration = MKImageryMapConfiguration()
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
        
        updateEvents(uiView, VM.firestore.firestoreModels.filter{ event in
            event.start <= Date() && event.end >= Date()
        })
        
        populateWildPokemon(uiView, WPManager.firestoreModels.filter { pokemon in
            pokemon.caught >= Date() // Filter out any you have caught in the past
        })
        
    }
    
    // TODO: Have these as firestore collection to populate
    func populateWildPokemon(_ uiView: MKMapView, _ wildPokemon: [FirestoreWildPokemon]) {
        print("Populating wild pokemon onto map")
        
//        for pokemon in wildPokemon {
//
//            // TODO: populate onto map
//        }
        
    }
    
    func updateEvents(_ uiView: MKMapView, _ events: [FirestoreEvent]) {
        
        for event in events {
            // Skip ones youve already achieved
            // Check if you have been to event
            let collection = db.collection("users/\(AuthManager.shared.uid!)/active_events")
            let query = collection.whereField("event_id", isEqualTo: event.id!)
            
            // Add annotations
            let loc = MKPointAnnotation()
            loc.title = event.title
            loc.coordinate = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
            
            // Add region
            let region = CLCircularRegion(center: loc.coordinate, radius: CLLocationDistance(event.radius), identifier: event.id ?? "N/A")
            
            // Add zone
            let circle = MKCircle(center: loc.coordinate, radius: region.radius)
            
            query.getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // If the event was active already
                    if let doc = querySnapshot?.documents.first, doc.exists {
                        
                        do {
                            
                            let regionEvent = try doc.data(as: FirestoreActiveEvent.self)
                            
                            if regionEvent.seconds > 0 {
                                print("\(event.title) is good to go")
                                uiView.addAnnotation(loc)
                                uiView.addOverlay(circle)
                                VM.locationManager.startMonitoring(for: region)
                                print("They already have this event finished")
                            } else {
                                print("finished the event \(event.title)")
                            }
                            
                        } catch {
                            print("Error reading in firestore active event model from firestore data")
                        }
                        
                    } else {
                        uiView.addAnnotation(loc)
                        uiView.addOverlay(circle)
                        VM.locationManager.startMonitoring(for: region)
                    }
                }
            }
            
            print("PASSED: \(event.title)")
            
//            uiView.addAnnotation(loc)
//            VM.locationManager.startMonitoring(for: region)
//            uiView.addOverlay(circle)
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
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
//            annotationView.collisionMode = .circle

            // print(PokemonManager.shared.allPokemon.first(where: { $0.pokemon.name! == annotation.title! })?.pokemon.name!)
            
            if let pkm = PokemonManager.shared.allPokemon.first(where: { $0.pokemon.name! == annotation.title! }) {
                print("we in big boys")
                annotationView.image = pkm.sprite
                return annotationView
            }
            
            return annotationView
            
        }
        
        // how to respond to clicking annotation
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            
            print("Uwu")
            parent.showEvent = true;
            
        }
        
    }
    
}

