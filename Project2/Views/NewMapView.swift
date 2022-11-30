//
//  NewMapView.swift
//  Project2
//
//  Created by Clayton Judge on 11/29/22.
//

import SwiftUI
import MapKit

struct NewMapView: View {

    @ObservedObject private var VM: MapViewModel = MapViewModel.shared

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.1548, longitude: -80.08), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))

    @State private var tracking = MapUserTrackingMode.follow


    var body: some View {
        Map(coordinateRegion: $region,
            showsUserLocation: true,
            userTrackingMode: $tracking,
            annotationItems: VM.firestore.firestoreModels
        ){ event in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)){
                ZStack{
                    AsyncImage(url: URL(string:PokedexViewModel.shared.allPokemon.first(where: { $0.id == event.pokemon_id })?.sprites?.frontDefault ?? "")) { image in
                        if let image = image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                    } placeholder: {
                        ProgressView()
                    }
                    .background(.thinMaterial)
                    .clipShape(Circle())
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear{
            let query = VM.firestore.query(collection: "event")
            VM.firestore.subscribe(to: query)
            if let lat = VM.userLat, let lon = VM.userLon {
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            }
        }
        .onDisappear{
            VM.firestore.unsubscribe()
        }
    }
}

struct NewMapView_Previews: PreviewProvider {
    static var previews: some View {
        NewMapView()
    }
}
