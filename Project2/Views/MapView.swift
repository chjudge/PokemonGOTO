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
    let db = Firestore.firestore()
    
    @Binding var showEvent: Bool
    @State var wildPokemon = [MKPointAnnotation]()
    
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
        
        let event = "event"
        print("creating query \(event)")
        MapViewModel.shared.firestore.subscribe(to: MapViewModel.shared.firestore.query(collection: event))
        
        let randomPokemon = "map_pokemon"
        print("creeating query \(randomPokemon)")
        MapViewModel.shared.randomPokemonFirestore.subscribe(to: MapViewModel.shared.randomPokemonFirestore.query(collection: randomPokemon))
        
        // create annotations
        
        //make the user to show up in the map; need to request permission for location first, otherwise function will not work
        map.delegate = context.coordinator
        map.showsUserLocation = true
        map.userTrackingMode = .followWithHeading
        map.setRegion(region, animated: true)
        updateEvents(map, VM.firestore.firestoreModels)
        updateWildPokemon(map)
//        map.preferredConfiguration = MKImageryMapConfiguration()
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        updateEvents(uiView, VM.firestore.firestoreModels.filter{ event in
            event.start <= Date() && event.end >= Date()
        })
        
        updateWildPokemon(uiView)
        
    }
    
    func updateWildPokemon(_ uiView: MKMapView) {
        
//        for annotation in uiView.annotations {
//            print(annotation.title!)
//        }
        for pkm in VM.randomPokemonFirestore.firestoreModels {
            
            if uiView.annotations.contains(where: { $0.title == pkm.name }) { continue }
//            print("adding annotation for \(pkm.name)")
            
            let marker = MKPointAnnotation()
            marker.title = pkm.name
            marker.coordinate = CLLocationCoordinate2D(latitude: pkm.location!.latitude, longitude: pkm.location!.longitude)
            // Add region
            //let region = CLCircularRegion(center: marker.coordinate, radius: CLLocationDistance(3), identifier: "pokemon\(pkm.id!)")
            uiView.addAnnotation(marker)
            //VM.locationManager.startMonitoring(for: region)
        }
        
        if VM.randomPokemonFirestore.firestoreModels.count > 6 { return }
        
//        let PKMManager = PokemonManager.shared
//
//        let highestPokemonId = 151
//
//        let randomLat = Float.random(in: 41.154001937356284 ..< 41.157117172039925)
//        let randomLon = Float.random(in: -80.08110060219843 ..< -80.07630910217662)
//
//        let randomPokemon = Int.random(in: 1..<highestPokemonId)
//        Task{
//            if let pokemon = await PKMManager.fetchPokemon(id: randomPokemon){
//                print("adding pokemon \(pokemon.name!)")
//
//                let fpokemon = FirestorePokemon(pokemonID: randomPokemon, name: (pokemon.name)!, level: 1, hp: 30, maxHP: 30, xp: 0, location: .init(latitude: Double(randomLat), longitude: Double(randomLon)))
//
//                PokemonManager.shared.newRandomPokemon(pokemon: fpokemon)
//
//            }
//        }
    }
    
    func updateEvents(_ uiView: MKMapView, _ events: [FirestoreEvent]) {

//        uiView.removeAnnotations(uiView.annotations)
//        uiView.removeOverlays(uiView.overlays)
        
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
            
//            print("PASSED: \(event.title)")
            
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
            if annotation is MKUserLocation{
                return nil
            }
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Reuse")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
//            annotationView.collisionMode = .circle

            // print(PokemonManager.shared.allPokemon.first(where: { $0.pokemon.name! == annotation.title! })?.pokemon.name!)
            
            if let pkm = PokemonManager.shared.allPokemon.first(where: { $0.pokemon.name! == annotation.title! }) {
                annotationView.image = pkm.sprite
                return annotationView
            }
            
            return annotationView
            
        }
        
        // how to respond to clicking annotation
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let MVM = MapViewModel.shared
            print("Uwu")
            parent.showEvent = true;
            if let event = MVM.firestore.firestoreModels.first(where: { $0.title == view.annotation?.title }) {
                
                MVM.pointOfInterest.setToEvent(event: event)
                
            } else { // is pokemon
                if let pokemon = MVM.randomPokemonFirestore.firestoreModels.first(where: { $0.name == view.annotation?.title }) {
                    
                    MVM.pointOfInterest.setToPokemon(pokemon: pokemon)
                    
                } else {
                    print("error")
                }
            }
            
        }
        
    }
    
}

