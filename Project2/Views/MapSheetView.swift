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
                    
                    if MapViewModel.shared.currentEncounterablePokemon.contains(where: { $0 == pokemon.id }) {
                        
                    }
                    
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
                            Text("**\(event.title)**\n").font(.title)
                            Text("From: \(event.start.formatted())\nUntil: \(event.end.formatted())\n")
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
            .opacity(0.6)
    }
    
    var pokemonRewardView : some View {
        VStack {
            if let pokemon = pointOfInterest.mapPokemon, pointOfInterest.isPokemon() {
                let pkm = allPokemon.first{ $0.pokemon.id! == pokemon.pokemonID }!
                
                if MapViewModel.shared.currentEncounterablePokemon.contains(where: { $0 == pokemon.id }) {
                    Spacer()
                    Button {
                        
                        
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .shadow(radius: 10)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                                .foregroundColor(.red)
                                .frame(width: 200, height: 80, alignment: .center)
                            Text("Battle!")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            
                        }
                    }
                }
                Spacer()
                
                PokemonView(pokemon: pkm.pokemon, dimensions: 120, showName: true, showID: true)
                
                Text("Level: \(pokemon.level)").padding(.top, 20)
                Text("Max Hp: \(pokemon.maxHP)")
                Text("Type: \(pkm.types.compactMap{$0.name!}.reduce("", {String("\($0) \($1)")}))")
//                Text("Type: \(types.compactMap{$0.name!}.reduce("", {String("\($0) \($1)")}))")
//                    .onAppear{
//                        Task(){
//                            types = await PKMManager.fetchType(types: pok.types!)
//                        }
//                    }
                Spacer()
                
            } else if let event = pointOfInterest.event, pointOfInterest.isEvent() {
                
                PokemonView(pokemon: allPokemon.first(where: { $0.pokemon.id! == event.pokemon_id })!.pokemon, dimensions: 120, showName: true, showID: true)
                
                Text("Level: ???") // \(pokemon.level)").padding(.top, 20)
                Text("Max Hp: ???") // \(pokemon.maxHP)")
                Text("Type: ???")
                
            } else { Text("Error") }
        }
    }
}

//struct MapSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapSheetView()
//    }
//}
