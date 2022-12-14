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
import FirebaseFirestore

class MapViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    let firestore = FirestoreManager<FirestoreEvent>(collection: "event")
    let randomPokemonFirestore = FirestoreManager<FirestorePokemon>(collection: "map_pokemon")
    let db = Firestore.firestore()
    
    var locationManager = CLLocationManager()
    
    @Published var userLat: Double? = nil
    @Published var userLon: Double? = nil
    @Published var eventTimer: EventTimer? = nil
    @Published var recentlyDeletedPokemon = ""
    
    var regionEvent: FirestoreActiveEvent? = nil
    var pointOfInterest = PointOfInterestModel()
    
    var currentEncounterablePokemon: [String] = [String]()
    
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
        
        if region.identifier.hasPrefix("pokemon") {
            // TODO: wild pokemon encounter
            print("Contacted with pokemon")
            let pokemonID = region.identifier.dropFirst(7) // drops the "pokemon" prefix (id remains)
            let wildPokemon = randomPokemonFirestore.firestoreModels.first(where: { $0.id! == pokemonID })
            currentEncounterablePokemon.append(String(pokemonID))
            print("Current encounterable pokemon (entering) \(currentEncounterablePokemon)")
            // TODO: continue
            
        } else { // Event encounter
            // Check if you have been to event
            let collection = db.collection("users/\(UserManager.shared.uid!)/active_events")
            let query = collection.whereField("event_id", isEqualTo: region.identifier)
            
            query.getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // If the event was active already
                    if let doc = querySnapshot?.documents.first, doc.exists {
                        
                        print("event was already activated before")
                        
                        // Get the remaining seconds to tick down from
                        do {
                            
                            self.regionEvent = try doc.data(as: FirestoreActiveEvent.self)
                            
                            if let seconds = self.regionEvent?.seconds, seconds <= 0 {
                                print("EVENT WAS FINISHED, SO DONT REACT TO THE REGION")
                                return
                            }
                            
                            print("You have entered the region: \(region.identifier)")
                            
                            // Start timer
                            self.eventTimer = EventTimer(event: self.regionEvent!)
                            self.eventTimer?.start()
                            
                        } catch {
                            print("Error reading in firestore active event model from firestore data")
                        }
                        //self.seconds = doc.data()["seconds"] as! Int
                        
                    } else { // New event => Initialize it in db
                        
                        print("discovered a brand new event!")
                        
                        if let event = self.firestore.firestoreModels.first(where: { $0.id == region.identifier }) {
                            // Add to user's active events
                            do {
                                print("Adding to user a new active event")
                                try collection.addDocument(from: FirestoreActiveEvent(event_id: region.identifier, seconds: event.seconds)) // ["event_id": region.identifier, "seconds": event.seconds])
                            } catch {
                                print("Error uploading the active event to firebase")
                            }
                            // Get the remaining seconds to tick down from
                            self.regionEvent = FirestoreActiveEvent(event_id: event.id!, seconds: event.seconds)
                            
                            // Start timer
                            self.eventTimer = EventTimer(event: self.regionEvent!)
                            self.eventTimer?.start()
                        }
                        
                    }
                }
            }
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {

        if region.identifier.hasPrefix("pokemon") {
            // TODO: wild pokemon dis-encounter
            let pokemonID = region.identifier.dropFirst(7) // drops the "pokemon" prefix (id remains)
            let wildPokemon = randomPokemonFirestore.firestoreModels.first(where: { $0.id! == pokemonID })
            currentEncounterablePokemon.removeAll{ $0 == String(pokemonID)}
            print("Current encounterable pokemon (leaving) \(currentEncounterablePokemon)")
            // TODO: continue
            
        } else { // Event dis-encounter
            if let timer = eventTimer {
                timer.stop()
                
                // Upload new time
                let collection = db.collection("users/\(UserManager.shared.uid!)/active_events")
                let query = collection.whereField("event_id", isEqualTo: region.identifier)
                query.getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        
                        if let doc = querySnapshot?.documents.first, doc.exists {
                            
                            do {
                                let e = try doc.data(as: FirestoreActiveEvent.self)
                                if e.seconds > 0 {
                                    print("Exiting region: \(region.identifier)")
                                    collection.document(doc.documentID).updateData(["seconds": timer.active_event.seconds])
                                }
                            } catch { print("Error getting data from firestore to make an active event") }
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    
}

// Event timer stuff

enum mode {
    case running
    case stopped
    case finished
}

class EventTimer: ObservableObject {
    var timer = Timer()
    
    let eventDetails: FirestoreEvent
    
    
    @Published var status : mode = .stopped
    var active_event: FirestoreActiveEvent
    
    init (event: FirestoreActiveEvent) {
        eventDetails = MapViewModel.shared.firestore.firestoreModels.first{$0.id == String(event.event_id)}!
        active_event = event
        print("Timer is init")
    }
    
    func start() {
        print("started timer")
        status = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.active_event.seconds -= 1
            print("Time remaining: \(self.active_event.seconds) seconds")
            if self.active_event.seconds <= 0 {
                print("Time limit reached!")
                self.finish()
            }
        }
    }
    
    func finish() {
        print("timer reached .finished")
        status = .finished

        let alertController = UIAlertController(title: "Congratulations!", message: "You completed \"Attend \(eventDetails.title)\"\n\n+\(eventDetails.experience) Experience\n\n\n             \(PokemonManager.shared.allPokemon.first{ $0.pokemon.id == eventDetails.pokemon_id }!.pokemon.name!.capitalized)\n             Lvl. \(eventDetails.pokemon_level)\n\n", preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Accept!", style: .default) { thing in
            PokemonManager.shared.addReward(pokemon: PokedexViewModel.shared.filteredPokemon.first{ $0.id == self.eventDetails.pokemon_id}!, level: self.eventDetails.pokemon_level)
            UserManager.shared.addXP(steps: self.eventDetails.experience)
        }
        
        alertController.addAction(acceptAction)
        
        var imageView = UIImageView(frame: CGRect(x: 50, y: 95, width: 80, height: 80))
        imageView.image = PokemonManager.shared.allPokemon.first{ $0.pokemon.id == eventDetails.pokemon_id }!.sprite

        alertController.view.addSubview(imageView)
        
        //allows the notification to be seen anywhere
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
        
        active_event.seconds = 0
        let db = Firestore.firestore()
        // Update the firestore
        let collection = db.collection("users/\(UserManager.shared.uid!)/active_events")
        let query = collection.whereField("event_id", isEqualTo: eventDetails.id as Any)
        query.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("ERROR")
                print(error.localizedDescription)
            } else {
                
                print("Trying to update")
                if let doc = querySnapshot?.documents.first, doc.exists {
                    collection.document(doc.documentID).updateData(["seconds": 0])
                }
                
            }
        }
        
        // Remove annotation
        
        
        timer.invalidate()
    }
    
    func stop() {
        print("stopped timer")
        if (status != .finished) {
            status = .stopped
        }
        timer.invalidate()
    }
}

class PointOfInterestModel {
    
    var event: FirestoreEvent? = nil
    var mapPokemon: FirestorePokemon? = nil
    
    init () {}
    
    func setToEvent(event: FirestoreEvent) {
        self.event = event
        mapPokemon = nil
    }
    
    func setToPokemon(pokemon: FirestorePokemon) {
        self.mapPokemon = pokemon
        event = nil
    }
    
    func isEvent() -> Bool { return event != nil }
    func isPokemon() -> Bool { return mapPokemon != nil }
    func isSet() -> Bool { return isEvent() || isPokemon() }
    
}


