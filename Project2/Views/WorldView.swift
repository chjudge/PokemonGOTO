//
//  WorldView.swift
//  Project2
//
//  Created by Heston Suorsa on 12/6/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct WorldView: View {
    
    @ObservedObject var MVM = MapViewModel.shared
    @State var showEvent = false
    
    var body: some View {
        MapView(showEvent: $showEvent)
            .sheet(isPresented: $showEvent) {
                MapSheetView(event: MVM.clickedEvent ?? FirestoreEvent(title: "meh", sender: "meh", location: GeoPoint(latitude: 40, longitude: -80), radius: 20, seconds: 20, start: Date(), end: Date(), pokemon_id: 1))
            }
//            .alert(
//                "Event pokemon added to your collection",
//                isPresented: // TODO: Bool to represent timer finished
//            ) { }
    }
}

struct WorldView_Previews: PreviewProvider {
    static var previews: some View {
        WorldView()
    }
}
