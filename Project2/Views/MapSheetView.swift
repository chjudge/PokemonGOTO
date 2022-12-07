//
//  MapSheetView.swift
//  Project2
//
//  Created by Heston Suorsa on 12/6/22.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MapSheetView: View {
    
    var pointOfInterest: PointOfInterestModel
    let allPokemon = PokemonManager.shared.allPokemon
    
    var body: some View {
        VStack {

            if let pokemon = pointOfInterest.mapPokemon, pointOfInterest.isPokemon() {
                // TODO: Display pokemon info
                Text("Pokemon: \(pokemon.name)")
                Text("ID: \(pokemon.pokemonID)")
                Text("Level: \(pokemon.level)")
                Text("Max Hp: \(pokemon.maxHP)")
                
            } else if let event = pointOfInterest.event, pointOfInterest.isEvent() {
                // TODO: Display event info
                Text("Title: \(event.title)")
                    .font(.largeTitle)
                Text("@ \(event.start.formatted()) - \(event.end.formatted())")
                    .font(.title)
                // TODO: Display stats of pokemon (NEED TO UPLOAD THESE INTO THE EVENT AS WELL)
                Text("Pokemon Reward: \(event.pokemon_id)")
                    .font(.title)
                
            } else { Text("Error") }
            
        }.padding(30)
    }
}

//struct MapSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapSheetView()
//    }
//}
