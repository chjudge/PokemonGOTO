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
    
//    private let mapAppearanceInstance = MKMapView.appearance()
//    private var mapCustomDelegate = MapCustomDelegate(MKMapView.appearance())

    var body: some View {
        Map(coordinateRegion: $region,
            showsUserLocation: true,
            userTrackingMode: $tracking,
            annotationItems: VM.firestore.firestoreModels
        ){ event in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)){
                ZStack{
                    AsyncImage(url: URL(string:PokemonManager.shared.allPokemon.first(where: { $0.id == event.pokemon_id })?.sprites?.frontDefault ?? "")) { image in
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
//            self.mapAppearanceInstance.delegate = mapCustomDelegate
//            for event in VM.firestore.firestoreModels{
//                let coord = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
//                let region = CLCircularRegion(center: coord, radius: CLLocationDistance(event.radius), identifier: "geofence")
//                self.mapAppearanceInstance.addOverlay(MKCircle(center: coord, radius: region.radius))
//            }
            
        }
        .onDisappear{
            VM.firestore.unsubscribe()
        }
    }
}

//class MapCustomDelegate: NSObject, MKMapViewDelegate {
//    var parent: MKMapView
//
//    init(_ parent: MKMapView) {
//        self.parent = parent
//    }
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay.isKind(of: MKCircle.self){
//            let circleRenderer = MKCircleRenderer(overlay: overlay)
//            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
//            circleRenderer.strokeColor = UIColor.blue
//            circleRenderer.lineWidth = 1
//            return circleRenderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//}
//

struct NewMapView_Previews: PreviewProvider {
    static var previews: some View {
        NewMapView()
    }
}
