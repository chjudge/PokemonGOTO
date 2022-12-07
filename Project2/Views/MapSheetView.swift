//
//  MapSheetView.swift
//  Project2
//
//  Created by Heston Suorsa on 12/6/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MapSheetView: View {
    
    var event: FirestoreEvent
    
    var body: some View {
        VStack {
            // TODO: Get image of pokemon and its stats
            Text("Title: \(event.title)")
                .font(.largeTitle)
            Text("Pokemon ID: \(event.pokemon_id)")
                .font(.largeTitle)
            // TODO: Format time
            Text("Timeframe: \(event.start) - \(event.end)")
                .font(.largeTitle)
        }.padding(30)
    }
}

struct MapSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapSheetView(event: FirestoreEvent(title: "meh", sender: "meh", location: GeoPoint(latitude: 40, longitude: -80), radius: 20, seconds: 20, start: Date(), end: Date(), pokemon_id: 1))
    }
}
