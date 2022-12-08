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
    
    //@State var types: [PKMType] = []
    
    var body: some View {
        GeometryReader { geo in
            
            VStack {
                if let pokemon = pointOfInterest.mapPokemon, pointOfInterest.isPokemon() {
                    
                    Text("You spotted a wild pokemon!").font(.largeTitle)
                    
                    ZStack {
                        backgroundBox
                        pokemonRewardView
                    }
                    
                } else if let event = pointOfInterest.event, pointOfInterest.isEvent() {
                    
                    Text("You spotted an ongoing event!").font(.largeTitle)
                    
                    ZStack {
                        backgroundBox
                        
                        VStack {
                            Text("Title: \(event.title)")
                            Text("@ \(event.start.formatted()) - \(event.end.formatted())")
                            pokemonRewardView
                        }
                    }
                    
                } else { Text("Error") }
                    
            }.padding(30)
        } // geo
    }
    
    var backgroundBox: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.primary)
            .shadow(radius: 10)
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            .foregroundColor(.blue)
    }
    
    var pokemonRewardView : some View {
        VStack {
            if let pokemon = pointOfInterest.mapPokemon, pointOfInterest.isPokemon() {
                
                PokemonView(pokemon: allPokemon.first(where: { $0.pokemon.id! == pokemon.pokemonID })!.pokemon, dimensions: 120)
                
                Text("Level: \(pokemon.level)").padding(.top, 20)
                Text("Max Hp: \(pokemon.maxHP)")
                
//                Text("Type: \(types.compactMap{$0.name!}.reduce("", {String("\($0) \($1)")}))")
//                    .onAppear{
//                        Task(){
//                            types = await PKMManager.fetchType(types: pok.types!)
//                        }
//                    }
                
            } else if let event = pointOfInterest.event, pointOfInterest.isEvent() {
                
                PokemonView(pokemon: allPokemon.first(where: { $0.pokemon.id! == event.pokemon_id })!.pokemon, dimensions: 120)
                
                Text("Level: ???") // \(pokemon.level)").padding(.top, 20)
                Text("Max Hp: ???") // \(pokemon.maxHP)")
                
            } else { Text("Error") }
        }
    }
}

//struct MapSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapSheetView()
//    }
//}
